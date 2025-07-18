import { useRecoilState, useSetRecoilState } from "recoil";
import { fetchNui, useNuiEvent } from "./hooks/useNuiEvents";
import { CurrentSong, PlayerStatus } from "./reducers/atoms";
import { QueryResults } from "./types/types";

export const Listeners = () => {
  const [player, setPlayer] = useRecoilState(PlayerStatus);
  const setSong = useSetRecoilState(CurrentSong);
  useNuiEvent("updatePlayer", (data: any) => {
    if (player.headphones) return;
    const copy = {
      ...player,
      url: data.url,
      loop: data.loop,
      playedSeconds: Math.floor(data.currentTime),
      playing: data.playing,
      duration: data.maxDuration,
      volume: data.volume,
      loaded: true,
    };
    setPlayer(copy);
  });
  useNuiEvent("toggle", (status: boolean) => {
    if (player.headphones) return;
    const copy = {
      ...player,
      playing: status,
    };
    setPlayer(copy);
  });
  useNuiEvent("duration", (seconds: number) => {
    if (player.headphones) return;
    const copy = {
      ...player,
      duration: seconds,
    };
    setPlayer(copy);
  });
  useNuiEvent("finished", () => {
    if (player.headphones) return;
    const copy = {
      ...player,
      playedSeconds: 0,
      playing: false,
      loaded: false,
    };
    setPlayer(copy);
    setTimeout(() => {
      fetchNui("av_music", "loaded");
    }, 1000);
  });
  useNuiEvent("setSong", (song: QueryResults) => {
    if (player.headphones) return;
    setPlayer({ ...song, playedSeconds: 0, playing: true, loaded: true });
    setSong({
      artist: song.artist.name,
      thumbnail: song.thumbnails[1]?.url || song.thumbnails[0].url,
      name: song.name,
      url: song.videoId,
      liked: false,
    });
  });
  useNuiEvent("setHeadphones", (state: boolean) => {
    const copy = {
      ...player,
      playerSeconds: 0,
      playing: false,
      loaded: false,
      headphones: state,
    };
    setPlayer(copy);
    setSong({
      artist: "",
      thumbnail: "",
      name: "",
      url: "",
      liked: false,
    });
  });
  return <></>;
};
