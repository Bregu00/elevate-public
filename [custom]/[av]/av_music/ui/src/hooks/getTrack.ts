import { QueryResults } from "../types/types";
import { fetchNui } from "./useNuiEvents";

export const YOUTUBE_URL = "https://www.youtube.com/watch?v=";

export const isYoutubeUrl = (url: string) => {
  const youtubeRegex = /^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$/;
  return youtubeRegex.test(url);
};

export const isSoundCloudUrl = (url: string) => {
  const soundcloudRegex = /^(https?\:\/\/)?(www\.)?(soundcloud\.com)\/.+$/;
  return soundcloudRegex.test(url);
};

export const isSpotifyUrl = (url: string) => {
  const spotifyRegex = /^(https?\:\/\/)?(www\.)?(open\.spotify\.com)\/.+$/;
  return spotifyRegex.test(url);
};

const validQueryDomains = new Set([
  "youtube.com",
  "www.youtube.com",
  "m.youtube.com",
  "music.youtube.com",
  "gaming.youtube.com",
]);

export const getYoutubePlaylistID = (url: string) => {
  try {
    const parsed = new URL(url);
    if (!validQueryDomains.has(parsed.hostname)) return null;
    const id = parsed.searchParams.get("list");
    if (!id) return null;
    return id;
  } catch (e) {
    return null;
  }
};

export const isSpotifyPlaylist = (url: string) => {
  const regex =
    /^(https:\/\/open\.spotify\.com\/playlist\/)([a-zA-Z0-9]+)(.*)$/;
  return regex.test(url);
};

export const isSpotifyAlbum = (url: string) => {
  const regex = /^(https:\/\/open\.spotify\.com\/album\/)([a-zA-Z0-9]+)(.*)$/;
  return regex.test(url);
};

export const isUrl = (url: string) => {
  try {
    new URL(url);
    return true;
  } catch (e) {
    return false;
  }
};

const generateId = () => "_" + Math.random().toString(36).substr(2, 9);

export const getTrackList = async (query: string) => {
  const _query = query.replace(/\s/g, "%20").replace(/\/intl-[a-z]{2}\//, "/");
  const isTracks =
    getYoutubePlaylistID(_query) ||
    isSpotifyPlaylist(_query) ||
    isSpotifyAlbum(_query);
  if (isTracks) {
    return false;
  }
  let result: QueryResults[] = await fetchNui(
    "av_music",
    "searchQuery",
    _query
  );
  if (!result) return false;
  result = result.map((track) => ({
    ...track,
    id: generateId(),
    videoId: track.videoId && `${YOUTUBE_URL}${track.videoId}`,
  }));
  return result;
};
