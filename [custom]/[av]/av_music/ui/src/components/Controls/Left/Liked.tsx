import { useState } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import {
  CurrentSong,
  CurrentTab,
  favoriteSongs,
  MusicList,
} from "../../../reducers/atoms";
import { IconHeart, IconHeartFilled } from "@tabler/icons-react";
import classes from "../style.module.css";
import { fetchNui } from "../../../hooks/useNuiEvents";

export const Liked = () => {
  const tab = useRecoilValue(CurrentTab);
  const [playlists, setPlaylists] = useRecoilState(MusicList);
  const [favSongs, setFavSongs] = useRecoilState(favoriteSongs);
  const song = useRecoilValue(CurrentSong);
  const [currentClass, setCurrentClass] = useState<string>("");
  function isSongInList(url: string) {
    if (favSongs[url]) {
      return true;
    }
    return Object.values(favSongs).some((item) => favSongs.videoId === url);
  }
  const handleLike = async (action: string) => {
    const resp = await fetchNui("av_music", "toggleLike", {
      song,
      action,
    });
    if (action === "remove") {
      const urlToRemove = song.url;
      const { [urlToRemove]: removed, ...updatedFavSongs } = favSongs;
      setFavSongs(updatedFavSongs);
      if (tab.type === "favorites") {
        const updatedSongs = playlists.songs.filter(
          (playlistSong: any) => playlistSong.videoId !== urlToRemove
        );
        setPlaylists((prev: any) => ({
          ...prev,
          songs: updatedSongs,
        }));
      }
      return;
    }
    setFavSongs({
      ...favSongs,
      [song.url]: song,
    });
    setCurrentClass(classes.heart);
    setTimeout(() => {
      setCurrentClass("");
    }, 1000);
    if (resp && tab.type == "favorites") {
      const copy = {
        ...playlists,
        songs: [...playlists.songs, resp],
      };
      setPlaylists(copy);
    }
  };

  return (
    <>
      {isSongInList(song.url) ? (
        <IconHeartFilled
          className={currentClass}
          style={{
            color: "#f03e3e",
            width: "20px",
            height: "20px",
            cursor: "pointer",
          }}
          onClick={() => {
            handleLike("remove");
          }}
        />
      ) : (
        <IconHeart
          style={{
            width: "20px",
            height: "20px",
            cursor: "pointer",
          }}
          onClick={() => {
            handleLike("add");
          }}
          stroke={1}
        />
      )}
    </>
  );
};
