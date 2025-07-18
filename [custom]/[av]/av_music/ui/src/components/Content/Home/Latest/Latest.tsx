import { useEffect, useState } from "react";
import {
  Text,
  Box,
  Image,
  Group,
  Flex,
  Table,
  ScrollArea,
  Menu,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import {
  IconPlaylistAdd,
  IconHeartFilled,
  IconHeart,
} from "@tabler/icons-react";
import cx from "clsx";
import { QueryResults } from "../../../../types/types";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { capitalizeText } from "../../../../hooks/capitalizeText";
import { FormatTime } from "../../../../hooks/formatTime";
import { useRecoilState, useRecoilValue } from "recoil";
import {
  CurrentSong,
  favoriteSongs,
  Lang,
  myPlaylists,
  PlayerStatus,
} from "../../../../reducers/atoms";
import { useViewportHeight } from "../../../../hooks/windowResize";

export const Latest = () => {
  const lang: any = useRecoilValue(Lang);
  const [favSongs, setFavSongs] = useRecoilState(favoriteSongs);
  const playlists = useRecoilValue(myPlaylists);
  const [song, setSong] = useRecoilState(CurrentSong);
  const [player, setPlayer] = useRecoilState(PlayerStatus);
  const [allSongs, setAllSongs] = useState<QueryResults[]>([]);
  const [scrolled, setScrolled] = useState(false);
  const [currentClass, setCurrentClass] = useState({ url: "", class: "heart" });
  const height = useViewportHeight();

  function isSongInList(url: string) {
    if (favSongs[url]) {
      return true;
    }
    return false;
  }
  const capitalizedSongs = allSongs.map((song: any) => ({
    ...song,
    artist: { ...song.artist, name: capitalizeText(song.artist.name) },
    name: capitalizeText(song.name),
    album: song.album
      ? { ...song.album, name: capitalizeText(song.album.name) }
      : undefined,
    seconds: FormatTime(song.duration),
  }));
  const handlePlay = async (data: any, index: number) => {
    const copy = { ...data, volume: player.volume };
    const resp = await fetchNui("av_music", "play", {
      song: copy,
      playlist: allSongs,
      index,
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
      const newPlayer = { ...player, playing: true, duration: resp };
      setPlayer(newPlayer);
      setTimeout(() => {
        fetchNui("av_music", "loaded");
      }, 500);
    }
  };
  const handleLike = (action: string, row: QueryResults) => {
    fetchNui("av_music", "toggleLike", {
      song: row,
      action,
    });
    if (action === "remove") {
      const { [row.videoId]: removed, ...updatedFavSongs } = favSongs;
      setFavSongs(updatedFavSongs);
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
  };
  const addToPlaylist = (identifier: string, url: string) => {
    fetchNui("av_music", "addToPlaylist", { identifier, url });
  };
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
            handlePlay(row, index + 1);
          }}
        >
          <Image
            w={40}
            src={
              row.thumbnails[1]?.url
                ? row.thumbnails[1]?.url
                : row.thumbnails[0]?.url
            }
          />
          <Flex direction="column" gap={1} w={"80%"}>
            <Text
              c={row.videoId == song.url ? "red.5" : "white"}
              fz="sm"
              truncate
            >
              {row?.name ? row.name : ``}
            </Text>
            <Text c="gray.5" fz="xs" truncate>
              {row?.artist?.name ? row?.artist?.name : ``}
            </Text>
          </Flex>
        </Group>
      </Table.Td>
      <Table.Td
        onClick={() => {
          handlePlay(row, index + 1);
        }}
      >
        {row?.album?.name ? row.album.name : ""}
      </Table.Td>
      <Table.Td
        onClick={() => {
          handlePlay(row, index + 1);
        }}
      >
        {row.seconds}
      </Table.Td>
      <Table.Td>
        <Group>
          <Menu>
            <Menu.Target>
              <Tooltip label={"Add To"} fz="xs" color="dark.3">
                <ActionIcon variant="transparent" size="xs" color="white">
                  <IconPlaylistAdd />
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
              {playlists.length > 0 ? (
                <>
                  {playlists.map((playlist) => (
                    <Menu.Item
                      key={playlist.identifier}
                      fz="xs"
                      onClick={() => {
                        if (!playlist.identifier) return;
                        addToPlaylist(playlist.identifier, row.videoId);
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
    const fetchData = async () => {
      const resp = await fetchNui("av_music", "getLatest");
      if (resp) {
        setAllSongs(resp);
      }
    };
    fetchData();
  }, []);

  return (
    <Box
      className={classes.container}
      p="sm"
      style={{ top: height > 700 ? "37vh" : "42vh" }}
    >
      <Text fz="md" c="rgba(218,218,218,1)">
        {lang.latest_header}
      </Text>
      <ScrollArea
        h={"calc(43.5vh)"}
        onScrollPositionChange={({ y }) => setScrolled(y !== 0)}
        className={classes.scroll}
        mt="sm"
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
      >
        <Table miw={700}>
          <Table.Thead
            className={cx(classes.header, { [classes.scrolled]: scrolled })}
          >
            <Table.Tr>
              <Table.Th w={20}>
                <Text fw={500} fz="xs">
                  #
                </Text>
              </Table.Th>
              <Table.Th>
                <Text fw={500} fz="xs">
                  {lang.artist}
                </Text>
              </Table.Th>
              <Table.Th>
                <Text fw={500} fz="xs">
                  {lang.album}
                </Text>
              </Table.Th>
              <Table.Th>
                <Text fw={500} fz="xs">
                  {lang.duration}
                </Text>
              </Table.Th>
              <Table.Th></Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>{rows}</Table.Tbody>
        </Table>
      </ScrollArea>
    </Box>
  );
};
