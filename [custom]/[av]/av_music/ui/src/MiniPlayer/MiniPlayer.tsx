import { useState, useEffect } from "react";
import {
  MantineProvider,
  Box,
  Stack,
  Flex,
  Group,
  ActionIcon,
  Text,
  Slider,
  Image,
} from "@mantine/core";
import { useHover } from "@mantine/hooks";
import {
  IconPlayerTrackPrevFilled,
  IconPlayerPlayFilled,
  IconPlayerPauseFilled,
  IconPlayerSkipForwardFilled,
  IconVolume2,
  IconVolume,
  IconVolume3,
  IconPointFilled,
  IconList,
  IconDots,
} from "@tabler/icons-react";
import { QueryResults } from "../types/types";
import classes from "./style.module.css";
import { FormatTime } from "../hooks/formatTime";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../hooks/useNuiEvents";
import { Loading } from "../components/Loading";

interface Properties {
  songs: QueryResults[];
}

const MiniPlayer = ({ songs }: Properties) => {
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [minimized, setMinimized] = useState(false);
  const [volumeIcon, setVolumeIcon] = useState(
    <IconVolume2 style={{ width: "20px", height: "20px" }} />
  );
  const [volume, setVolume] = useState(0.25);
  const [playing, setPlaying] = useState(false);
  const [value, setValue] = useState(0);
  const [seeking, setSeeking] = useState(false);
  const [showPlaylist, setShowPlaylist] = useState(false);
  const { hovered, ref } = useHover();
  const [nowPlaying, setNowPlaying] = useState<QueryResults>({
    artist: { name: "", artistId: "" },
    album: { albumId: "", name: "" },
    duration: 0,
    name: "",
    thumbnails: [
      {
        url: "",
        height: 60,
        width: 60,
      },
    ],
    videoId: "",
    type: "song",
  });

  useNuiEvent("minimize", () => {
    setMinimized(true);
  });

  useNuiEvent("enabled", () => {
    setMinimized(false);
  });

  useNuiEvent("updateTime", (seconds: number) => {
    if (!seeking) {
      setValue(seconds);
    }
  });
  useNuiEvent("updateSong", (song: QueryResults) => {
    setNowPlaying(song);
  });
  useNuiEvent("updateState", (status: boolean) => {
    setPlaying(status);
  });

  const togglePlay = () => {
    setPlaying(!playing);
    fetchNui("av_music", "mini_toggle");
  };
  const handleChange = (value: number) => {
    fetchNui("av_music", "mini_seekTo", value);
    setSeeking(false);
  };
  const handleSkip = (value: string) => {
    if (value === "next") {
      fetchNui("av_music", "mini_next");
    } else {
      fetchNui("av_music", "mini_previous");
    }
  };
  const handleVolume = (value: number) => {
    setVolume(value);
    fetchNui("av_music", "mini_volume", value);
    if (value > 0.5) {
      setVolumeIcon(<IconVolume style={{ width: "20px", height: "20px" }} />);
      return;
    }
    if (value == 0) {
      setVolumeIcon(<IconVolume3 style={{ width: "20px", height: "20px" }} />);
      return;
    }
    setVolumeIcon(<IconVolume2 style={{ width: "20px", height: "20px" }} />);
  };
  const handlePlay = async (song: QueryResults, index: number) => {
    const resp = await fetchNui("av_music", "miniplayer_play", {
      song,
      volume,
      index,
    });
    if (resp) {
      setNowPlaying(song);
    }
  };
  const handleMinimize = () => {
    setShowPlaylist(false);
    setMinimized(true);
    fetchNui("av_music", "minimize");
  };
  const handleClose = () => {
    fetchNui("av_music", "miniplayer_close");
  };

  useEffect(() => {
    if (songs[0]) {
      setNowPlaying(songs[0]);
      fetchNui("av_music", "miniplayer_play", {
        song: songs[0],
        volume,
        index: 1,
      });
    }
    setMinimized(false);
    setTimeout(() => {
      setLoaded(true);
    }, 50);
  }, [songs]);

  return (
    <MantineProvider defaultColorScheme="dark">
      <Box className={classes.container}>
        <Flex className={classes.box} direction="column">
          <Box className={classes.player} opacity={minimized ? 0.5 : 1.0}>
            {!loaded ? (
              <Loading />
            ) : (
              <>
                <Box
                  className={classes.overlay}
                  style={{
                    backgroundImage: nowPlaying.thumbnails[1]?.url
                      ? `url(${nowPlaying.thumbnails[1]?.url})`
                      : `url(${nowPlaying.thumbnails[0]?.url})`,
                  }}
                />
                {!minimized && (
                  <Box className={classes.menuBar} w="100%">
                    <Group gap={0} justify="flex-end">
                      <ActionIcon
                        variant="transparent"
                        color="yellow.5"
                        size="xs"
                        onClick={handleMinimize}
                      >
                        <IconPointFilled />
                      </ActionIcon>

                      <ActionIcon
                        variant="transparent"
                        color="red.5"
                        size="xs"
                        onClick={handleClose}
                      >
                        <IconPointFilled />
                      </ActionIcon>
                    </Group>
                  </Box>
                )}
                <Group p="sm">
                  <Image
                    src={
                      nowPlaying.thumbnails[1]?.url
                        ? nowPlaying.thumbnails[1]?.url
                        : nowPlaying.thumbnails[0]?.url
                    }
                    h={55}
                    w={55}
                    fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png"
                  />

                  <Flex direction="column" gap={4} w="calc(100% - 75px)">
                    <Text
                      fz="xs"
                      fw={500}
                      className={classes.title}
                      truncate
                    >{`${nowPlaying.artist.name} - ${nowPlaying.name}`}</Text>
                    <Group>
                      <Group className={classes.buttons} gap="xs">
                        <ActionIcon
                          size="sm"
                          variant="transparent"
                          color="white"
                          onClick={() => {
                            handleSkip("previous");
                          }}
                        >
                          <IconPlayerTrackPrevFilled />
                        </ActionIcon>
                        <ActionIcon
                          variant="transparent"
                          color="white"
                          onClick={togglePlay}
                        >
                          {playing ? (
                            <IconPlayerPauseFilled />
                          ) : (
                            <IconPlayerPlayFilled />
                          )}
                        </ActionIcon>
                        <ActionIcon
                          size="sm"
                          variant="transparent"
                          color="white"
                          onClick={() => {
                            handleSkip("next");
                          }}
                        >
                          <IconPlayerSkipForwardFilled />
                        </ActionIcon>
                      </Group>
                      <Group ml="auto">
                        <Group display="flex">
                          <ActionIcon
                            color="white"
                            variant="transparent"
                            onClick={() => {
                              handleVolume(0.0);
                            }}
                          >
                            {volumeIcon}
                          </ActionIcon>
                          <Slider
                            value={volume}
                            label={Math.floor(volume * 100)}
                            size={2}
                            color="white"
                            w={100}
                            onChange={handleVolume}
                            min={0}
                            max={1}
                            step={0.01}
                            fz="xs"
                            classNames={classes}
                          />
                        </Group>
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="rgba(255,255,255,0.8)"
                          onClick={() => {
                            setShowPlaylist(!showPlaylist);
                          }}
                        >
                          <IconList />
                        </ActionIcon>
                      </Group>
                    </Group>
                  </Flex>
                </Group>
                <Slider
                  className={classes.progress}
                  ref={ref}
                  value={value}
                  max={nowPlaying.duration}
                  w="100%"
                  size={1.55}
                  color={playing ? "white" : "dark.4"}
                  label={<Text fz="xs">{FormatTime(value)}</Text>}
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
            )}
          </Box>
          {showPlaylist && (
            <Stack className={classes.playlist} gap={5}>
              {songs.map((song, index: number) => (
                <Group
                  className={classes.song}
                  justify="space-between"
                  w="100%"
                  mih={30}
                  onClick={() => {
                    handlePlay(song, index + 1);
                  }}
                >
                  <Text
                    ml="xs"
                    fz="xs"
                    fw={500}
                    truncate
                    maw={250}
                    c={nowPlaying.videoId == song.videoId ? `red.4` : `white`}
                  >{`${song.artist.name} - ${song.name}`}</Text>
                  <Text fz="xs" mr="xs">{`${FormatTime(song.duration)}`}</Text>
                </Group>
              ))}
            </Stack>
          )}
        </Flex>
      </Box>
    </MantineProvider>
  );
};

export default MiniPlayer;
