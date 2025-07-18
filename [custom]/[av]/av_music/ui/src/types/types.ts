export interface SongType {
  name: string;
  url: string;
  artist: string;
  thumbnail: string;
  liked: boolean;
}

export interface PlaylistType {
  identifier?: string;
  name: string;
  cover: string;
  description: string;
}

type Thumbnail = {
  url: string;
  width: number;
  height: number;
};

type Artist = {
  name: string;
  artistId: string;
};

type Album = {
  albumId: string;
  name: string;
};

export interface QueryResults {
  artist: Artist;
  thumbnails: Thumbnail[];
  name: string;
  videoId: string;
  duration: number;
  album: Album;
  type: string;
}

export interface SongListType {
  songs: QueryResults[];
  info: {
    header?: string;
    subheader?: string;
    thumbnail?: string;
  };
}
