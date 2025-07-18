import { atom } from "recoil";
import { SongType, PlaylistType, SongListType } from "../types/types";
export const Lang = atom<Object>({
  key: "lang",
  default: {},
});

export const CurrentSong = atom<SongType>({
  key: "song",
  default: {
    url: "",
    artist: "",
    name: "",
    thumbnail: "",
    liked: false,
  },
});

export const PlayerStatus = atom<any>({
  key: "player",
  default: {
    url: "",
    playing: false,
    volume: 0.25,
    shuffle: false,
    loop: false,
    duration: 0,
    playedSeconds: 0,
  },
});

export const MusicList = atom<any>({
  key: "musiclist",
  default: {
    cover: "",
    name: "",
    description: "",
    identifier: "",
    songs: [
      {
        album: { albumId: "MPREb_GMXGlpVpiRQ", name: "BELLAKEO" },
        artist: { artistId: "UCzmabbKsmXlWnI9N2kKQ4lA", name: "Peso Pluma" },
        duration: 198,
        name: "BELLAKEO",
        thumbnails: [
          {
            height: 60,
            url: "https://lh3.googleusercontent.com/eS4noUUQYCzV03I4KuawJB4aEnfuHec8n7Po8hzJBkU66wZ6_YdXiM0ZRJls84NBKmF_ebxXRDQiQljj=w60-h60-l90-rj",
            width: 60,
          },
          {
            height: 120,
            url: "https://lh3.googleusercontent.com/eS4noUUQYCzV03I4KuawJB4aEnfuHec8n7Po8hzJBkU66wZ6_YdXiM0ZRJls84NBKmF_ebxXRDQiQljj=w120-h120-l90-rj",
            width: 120,
          },
        ],
        type: "SONG",
        videoId: "https://www.youtube.com/watch?v=Qt5F-qJkt4s",
      },
    ],
  },
});

export const myPlaylists = atom<PlaylistType[]>({
  key: "playlists",
  default: [],
});

export const favoriteSongs = atom<any>({
  key: "favorites",
  default: [],
});

export const backgroundImage = atom<string>({
  key: "background",
  default: "",
});

export const IsBusy = atom<boolean>({
  key: "busyState",
  default: false,
});

export const clearSearch = atom<string>({
  key: "clear",
  default: "",
});

export const CurrentTab = atom({
  key: "tab",
  default: { type: "home", identifier: "" },
});
