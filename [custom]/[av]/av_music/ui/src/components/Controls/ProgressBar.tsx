import { useEffect, useState } from "react";
import { Slider } from "@mantine/core";
import { useRecoilState, useRecoilValue } from "recoil";
import { useHover } from "@mantine/hooks";
import { CurrentSong, PlayerStatus } from "../../reducers/atoms";
import { FormatTime } from "../../hooks/formatTime";
import { fetchNui } from "../../hooks/useNuiEvents";

export const ProgressBar = () => {
  const [song, setSong] = useRecoilState(CurrentSong);
  const [value, setValue] = useState(0);
  const [seeking, setSeeking] = useState(false);
  const player = useRecoilValue(PlayerStatus);
  const { hovered, ref } = useHover();

  const handleChange = (value: any) => {
    fetchNui("av_music", "seekTo", value);
    setSeeking(false);
  };
  const getData = async () => {
    const resp = await fetchNui("av_music", "getSoundData", player.url);
    if (resp) {
      const copy = {
        ...song,
        url: player.url,
        thumbnail: resp.thumbnail,
        name: resp.title,
        artist: resp.artist,
      };
      setSong(copy);
    }
  };
  useEffect(() => {
    if (!seeking) {
      setValue(player.playedSeconds);
    }
    if (player.playing && song.url == "") {
      getData();
    }
  }, [player]);

  return (
    <>
      <Slider
        ref={ref}
        value={value}
        max={player.duration}
        w="100%"
        size={1.55}
        color={player.playing ? "red.5" : "dark.4"}
        label={FormatTime(value)}
        fz="xs"
        onChange={(e) => {
          setSeeking(true);
          setValue(e);
        }}
        onChangeEnd={(e) => {
          handleChange(e);
        }}
        styles={{
          thumb: {
            transition: "opacity 150ms ease",
            opacity: hovered ? 1 : 0,
          },
        }}
      />
    </>
  );
};
