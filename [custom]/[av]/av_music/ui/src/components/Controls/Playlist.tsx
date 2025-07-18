import { useState, useEffect, CSSProperties } from "react";
import { Box, Stack, Group, Image, Text, ActionIcon } from "@mantine/core";
import { useClickOutside } from "@mantine/hooks";
import { IconX } from "@tabler/icons-react";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import classes from "./playlist.module.css";
import { Loading } from "../Loading";
import { QueryResults } from "../../types/types";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  style: CSSProperties;
  show: (state: boolean) => void;
}

export const Playlist = ({ style, show }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allSongs, setAllSongs] = useState<QueryResults[]>([]);
  const [playing, setPlaying] = useState({ videoId: "" });
  const ref = useClickOutside(() => show(false));
  const handlePlay = async (song: any, index: number) => {
    const resp = await fetchNui("av_music", "playQueue", { song, index });
    if (resp) {
      setPlaying(resp);
    }
  };
  const handleDelete = async (videoId: string) => {
    const resp = await fetchNui("av_music", "removeQueue", videoId);
    if (resp) {
      setAllSongs(resp);
    }
  };
  useNuiEvent("updateSong", (song) => {
    setPlaying(song);
  });
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_music", "getDeviceQueue");
      if (resp) {
        setAllSongs(resp.playlist);
        setPlaying(resp.song);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <Box
      className={classes.container}
      style={{ ...style, position: "absolute", zIndex: 1 }}
    >
      <Box className={classes.box} p="sm" ref={ref}>
        {loaded ? (
          <>
            <Text fz="sm" fw={500} c="red.4">
              {lang.device_queue}
            </Text>
            {allSongs[0] && (
              <Stack mt="xs" gap={2}>
                {allSongs.map((song, index) => (
                  <Group className={classes.song} key={song.videoId}>
                    <Group
                      grow
                      gap="xs"
                      onClick={() => {
                        handlePlay(song, index + 1);
                      }}
                    >
                      <Image
                        w={35}
                        h={35}
                        src={
                          song.thumbnails[1]?.url
                            ? song.thumbnails[1]?.url
                            : song.thumbnails[0]?.url
                        }
                        fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png"
                      />
                      <Text
                        fz="xs"
                        truncate
                        maw={150}
                        c={playing?.videoId == song.videoId ? `red.4` : `gray`}
                      >{`${song.artist.name} - ${song.name}`}</Text>
                    </Group>
                    <Box w={5} ml="auto" mr="xs">
                      <ActionIcon
                        size="xs"
                        color="red.5"
                        variant="transparent"
                        onClick={() => {
                          handleDelete(song.videoId);
                        }}
                      >
                        <IconX style={{ width: "14px", height: "14px" }} />
                      </ActionIcon>
                    </Box>
                  </Group>
                ))}
              </Stack>
            )}
          </>
        ) : (
          <Loading />
        )}
      </Box>
    </Box>
  );
};
