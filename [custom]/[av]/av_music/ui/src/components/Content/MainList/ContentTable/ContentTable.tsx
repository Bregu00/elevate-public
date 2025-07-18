import { useEffect, useState } from "react";
import {
  Table,
  TextInput,
  ScrollArea,
  Text,
  Image,
  Group,
  Flex,
  Menu,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import {
  IconSearch,
  IconPlaylistAdd,
  IconPlaylistX,
  IconHeartFilled,
  IconHeart,
} from "@tabler/icons-react";
import { QueryResults } from "../../../../types/types";
import { Th } from "./Th";
import { sortData } from "./utils";
import { FormatTime } from "../../../../hooks/formatTime";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { useRecoilState, useRecoilValue, useSetRecoilState } from "recoil";
import {
  backgroundImage,
  CurrentSong,
  CurrentTab,
  favoriteSongs,
  Lang,
  MusicList,
  myPlaylists,
  PlayerStatus,
} from "../../../../reducers/atoms";
import { capitalizeText } from "../../../../hooks/capitalizeText";
import { useViewportHeight } from "../../../../hooks/windowResize";
import classes from "./style.module.css";

export const ContentTable = () => {
  const lang: any = useRecoilValue(Lang);
  const tab = useRecoilValue(CurrentTab);
  const [musicList, setMusicList] = useRecoilState(MusicList);
  const playlists = useRecoilValue(myPlaylists);
  const [favSongs, setFavSongs] = useRecoilState(favoriteSongs);
  const [song, setSong] = useRecoilState(CurrentSong);
  const setBackground = useSetRecoilState(backgroundImage);
  const [player, setPlayer] = useRecoilState(PlayerStatus);
  const [search, setSearch] = useState("");
  const [sortedData, setSortedData] = useState(musicList.songs);
  const [sortBy, setSortBy] = useState<keyof QueryResults | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [currentClass, setCurrentClass] = useState({ url: "", class: "heart" });
  const height = useViewportHeight();
  function isSongInList(url: string) {
    if (favSongs[url]) {
      return true;
    }
    return false;
  }
  const handleLike = async (action: string, row: QueryResults) => {
    const resp = await fetchNui("av_music", "toggleLike", {
      song: row,
      action,
    });
    if (action === "remove") {
      const { [row.videoId]: removed, ...updatedFavSongs } = favSongs;
      setFavSongs(updatedFavSongs);
      if (tab.type === "favorites") {
        const updatedSongs = musicList.songs.filter((playlistSong: any) => {
          return playlistSong.videoId !== row.videoId;
        });
        setMusicList((prev: any) => ({
          ...prev,
          songs: updatedSongs,
        }));
      }
      return;
    }
    setFavSongs({
      ...favSongs,
      [row.videoId]: row,
    });
    setCurrentClass({ url: row.videoId, class: classes.heart });
    setTimeout(() => {
      setCurrentClass({ url: "", class: "heart" });
    }, 1000);
    if (resp && tab.type == "favorites") {
      const copy = {
        ...musicList,
        songs: [...musicList.songs, resp],
      };
      setMusicList(copy);
    }
  };
  const handlePlay = async (data: any) => {
    const copy = { ...data, volume: player.volume };
    const resp = await fetchNui("av_music", "play", {
      song: copy,
      playlist: musicList.songs,
    });
    if (resp) {
      setSong({
        ...data,
        artist: data.artist.name,
        thumbnail: data.thumbnails[1]?.url || data.thumbnails[0].url,
        name: data.name,
        url: data.videoId,
        liked: false,
      });
      setBackground(data.thumbnails[1]?.url || data.thumbnails[0].url);
      const newPlayer = { ...player, playing: true, duration: resp };
      setPlayer(newPlayer);
      setTimeout(() => {
        fetchNui("av_music", "loaded");
      }, 500);
    }
  };
  const setSorting = (field: keyof QueryResults) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(
      sortData(musicList.songs, { sortBy: field, reversed, search })
    );
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.currentTarget;
    setSearch(value);
    setSortedData(
      sortData(musicList.songs, {
        sortBy,
        reversed: reverseSortDirection,
        search: value,
      })
    );
  };
  const handleRemove = async (videoId: string, identifier: string) => {
    const resp = await fetchNui("av_music", "removeFromPlaylist", {
      videoId,
      identifier,
    });
    if (resp) {
      const copy: QueryResults[] = { ...musicList.songs };
      const filteredSongs = Object.values(copy).filter(
        (song) => song.videoId !== videoId
      );
      setMusicList({ ...musicList, songs: filteredSongs });
      setSortedData(filteredSongs);
    }
  };
  const addToPlaylist = (identifier: string, song: QueryResults) => {
    fetchNui("av_music", "addToPlaylist", { identifier, song });
  };
  const capitalizedSongs = sortedData.map((song: any) => ({
    ...song,
    artist: { ...song.artist, name: capitalizeText(song.artist.name) },
    name: capitalizeText(song.name),
    album: song.album
      ? { ...song.album, name: capitalizeText(song.album.name) }
      : undefined,
    seconds: FormatTime(song.duration),
  }));
  const addToDevice = (song: QueryResults) => {
    fetchNui("av_music", "addToDevice", song);
  };
  const rows = capitalizedSongs.map((row: any, index: number) => (
    <Table.Tr key={row.videoId}>
      <Table.Td c="gray.5" fz="xs" w={20}>
        {row.videoId == song.url && player.playing ? (
          <Image src="./equaliser.gif" w={15} />
        ) : (
          `${index + 1}`
        )}
      </Table.Td>
      <Table.Td>
        <Group
          onClick={() => {
            handlePlay(row);
          }}
        >
          {height > 700 && (
            <Image
              w={40}
              src={row.thumbnails[1]?.url || row.thumbnails[0].url}
            />
          )}
          <Flex direction="column" gap={1} maw={"70%"}>
            <Text
              c={row.videoId == song.url ? "red.5" : "white"}
              fz="sm"
              truncate
            >
              {row?.name ? row.name : "N/A"}
            </Text>
            <Text c="gray.5" fz="xs" truncate>
              {row?.artist?.name ? row?.artist?.name : "N/A"}
            </Text>
          </Flex>
        </Group>
      </Table.Td>
      {height > 700 && (
        <Table.Td
          onClick={() => {
            handlePlay(row);
          }}
        >
          {row?.album?.name ? row.album.name : "N/A"}
        </Table.Td>
      )}

      <Table.Td
        onClick={() => {
          handlePlay(row);
        }}
      >
        {row.seconds}
      </Table.Td>
      <Table.Td w={95}>
        <Group>
          <Menu disabled={tab.type == "playlist" && !player.headphones}>
            <Menu.Target>
              <Tooltip
                label={
                  tab.type == "playlist" && !player.headphones
                    ? lang.remove_song
                    : lang.add_to
                }
                fz="xs"
                color="dark.3"
              >
                <ActionIcon
                  variant="transparent"
                  size="xs"
                  color="white"
                  onDoubleClick={() => {
                    if (tab.type === "playlist") {
                      handleRemove(row.videoId, tab.identifier);
                    }
                  }}
                >
                  {tab.type == "playlist" ? (
                    <IconPlaylistX />
                  ) : (
                    <IconPlaylistAdd />
                  )}
                </ActionIcon>
              </Tooltip>
            </Menu.Target>
            <Menu.Dropdown miw={100}>
              {player.headphones && (
                <Menu.Item
                  fz="xs"
                  c="green"
                  onClick={() => {
                    addToDevice(row);
                  }}
                >
                  {lang.add_queue}
                </Menu.Item>
              )}
              {playlists.length > 0 && tab.type !== "playlist" ? (
                <>
                  {playlists.map((playlist) => (
                    <Menu.Item
                      key={playlist.identifier}
                      fz="xs"
                      onClick={() => {
                        if (!playlist.identifier) return;
                        addToPlaylist(playlist.identifier, row);
                      }}
                    >
                      {playlist.name}
                    </Menu.Item>
                  ))}
                </>
              ) : (
                <>
                  {!player.headphones && (
                    <Menu.Label>{lang.create_playlist}</Menu.Label>
                  )}
                </>
              )}
            </Menu.Dropdown>
          </Menu>
          <>
            {isSongInList(row.videoId) ? (
              <IconHeartFilled
                className={
                  currentClass.url == row.videoId ? currentClass.class : ""
                }
                style={{
                  color: "#f03e3e",
                  width: "20px",
                  height: "20px",
                  cursor: "pointer",
                }}
                onClick={() => {
                  handleLike("remove", row);
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
                  handleLike("add", row);
                }}
                stroke={1}
              />
            )}
          </>
        </Group>
      </Table.Td>
    </Table.Tr>
  ));
  useEffect(() => {
    setSortedData(musicList.songs);
  }, [musicList || player]);

  return (
    <>
      <TextInput
        classNames={classes}
        placeholder={lang.search_in}
        leftSection={<IconSearch size="0.9rem" />}
        value={search}
        onChange={handleSearchChange}
        mb="md"
        ml="auto"
        mr="sm"
        w="30vw"
        maw={255}
        size="xs"
      />
      <ScrollArea
        className={classes.scroll}
        mt="sm"
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
      >
        <Table
          horizontalSpacing="md"
          verticalSpacing="xs"
          layout="fixed"
          highlightOnHover
        >
          <Table.Thead>
            <Table.Tr>
              <Table.Th w={20}>#</Table.Th>
              <Th
                sorted={sortBy === "artist"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("artist")}
              >
                {lang.artist}
              </Th>
              {height > 700 && (
                <Th
                  sorted={sortBy === "album"}
                  reversed={reverseSortDirection}
                  onSort={() => setSorting("album")}
                >
                  {lang.album}
                </Th>
              )}
              <Th
                sorted={sortBy === "duration"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("duration")}
              >
                {lang.duration}
              </Th>
              <Table.Th w={95}></Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {rows.length > 0 ? (
              rows
            ) : (
              <Table.Tr>
                <Table.Td colSpan={4}>
                  <Text fw={500} ta="center" c="dimmed">
                    {lang.empty}
                  </Text>
                </Table.Td>
              </Table.Tr>
            )}
          </Table.Tbody>
        </Table>
      </ScrollArea>
    </>
  );
};
