import {
  ActionIcon,
  Box,
  Group,
  ScrollArea,
  Stack,
  Text,
  Menu,
  rem,
} from "@mantine/core";
import {
  IconMusicHeart,
  IconHomeFilled,
  IconPlus,
  IconEdit,
  IconShare3,
  IconTrash,
  IconPlaylistAdd,
  IconChecklist,
} from "@tabler/icons-react";
import { useState } from "react";
import { useRecoilState, useRecoilValue, useSetRecoilState } from "recoil";
import {
  clearSearch,
  CurrentTab,
  IsBusy,
  Lang,
  MusicList,
  myPlaylists,
} from "../../reducers/atoms";
import { PlaylistType } from "../../types/types";
import classes from "./style.module.css";
import { fetchNui } from "../../hooks/useNuiEvents";

interface Properties {
  handlePlaylist: (playlist: PlaylistType) => void;
  openImport: () => void;
}

const defValue: PlaylistType = {
  name: "",
  cover: "",
  description: "",
};

export const NavBar = ({ handlePlaylist, openImport }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const setClear = useSetRecoilState(clearSearch);
  const [tab, setTab] = useRecoilState(CurrentTab);
  const [busy, setBusy] = useRecoilState(IsBusy);
  const [mainList, setMainList] = useRecoilState(MusicList);
  const [playlists, setPlaylists] = useRecoilState(myPlaylists);
  const [opened, setOpened] = useState(defValue);
  const [name, setName] = useState("scroll");
  const onMove = () => {
    setName("scroll");
  };
  const onBottomReached = () => {
    setName("");
  };
  const handleDelete = () => {
    if (!opened.identifier) return;
    const updatedPlaylists = playlists.filter(
      (playlist) => playlist.identifier !== opened.identifier
    );
    setPlaylists(updatedPlaylists);
    fetchNui("av_music", "deletePlaylist", opened.identifier);
    if (tab.identifier == opened.identifier) {
      setTab({ type: "home", identifier: "" });
    }
  };
  const handleFavorites = async () => {
    if (busy) return;
    setBusy(true);
    setTab({ type: "favorites", identifier: "" });
    setClear("_" + Math.random().toString(36).substr(2, 9));
    const resp = await fetchNui("av_music", "getFavorites");
    const copy = {
      ...mainList,
      cover: "./liked.png",
      name: lang.favorites_header,
      description: lang.favorites_subheader,
      songs: resp || [],
    };
    setMainList(copy);
    setBusy(false);
  };

  const fetchPlaylist = async (playlist: PlaylistType) => {
    if (busy || !playlist.identifier) return;
    setBusy(true);
    setTab({ type: "playlist", identifier: playlist.identifier });
    setClear("_" + Math.random().toString(36).substr(2, 9));
    const resp = await fetchNui("av_music", "getPlaylistSongs", {
      identifier: playlist.identifier,
    });
    const copy = {
      ...mainList,
      cover: resp.cover,
      name: resp.name,
      description: resp.description,
      songs: resp.songs || [],
    };
    setMainList(copy);
    setBusy(false);
  };
  return (
    <Box className={classes.container} p="lg">
      <Group
        gap={"sm"}
        onClick={() => {
          setClear("_" + Math.random().toString(36).substr(2, 9));
          setTab({ type: "home", identifier: "" });
        }}
      >
        <IconHomeFilled
          style={{
            width: rem(14),
            height: rem(14),
            color: tab.type == "home" ? "#fa5252" : "rgba(255,255,255,0.6)",
          }}
          stroke={1.5}
        />
        <Text
          fz="xs"
          c={tab.type == "home" ? "#fa5252" : "rgba(255,255,255,0.8)"}
          fw={500}
        >
          {lang.tab_home}
        </Text>
      </Group>
      <Group gap={"sm"} mt="md" onClick={handleFavorites}>
        <IconMusicHeart
          style={{
            width: rem(14),
            height: rem(14),
            color:
              tab.type == "favorites" ? "#fa5252" : "rgba(255,255,255,0.6)",
          }}
          stroke={1.5}
        />
        <Text
          fz="xs"
          c={tab.type == "favorites" ? "#fa5252" : "rgba(255,255,255,0.8)"}
          fw={500}
          truncate
        >
          {lang.tab_liked}
        </Text>
      </Group>
      <Group className={classes.category} gap="xs">
        <Text fz="xs">My Playlists</Text>
        <Menu>
          <Menu.Target>
            <ActionIcon
              ml="auto"
              size={16}
              variant="light"
              radius={20}
              color="rgba(255, 255, 255, 0.4)"
            >
              <IconPlus style={{ width: rem(12), height: rem(12) }} />
            </ActionIcon>
          </Menu.Target>
          <Menu.Dropdown>
            <Menu.Item
              fz="xs"
              leftSection={
                <IconPlaylistAdd style={{ width: rem(16), height: rem(16) }} />
              }
              onClick={() => {
                handlePlaylist(opened);
              }}
            >
              {lang.tab_create}
            </Menu.Item>
            <Menu.Item
              leftSection={
                <IconChecklist style={{ width: rem(16), height: rem(16) }} />
              }
              fz="xs"
              onClick={openImport}
            >
              {lang.tab_import}
            </Menu.Item>
          </Menu.Dropdown>
        </Menu>
      </Group>
      <ScrollArea
        mt="sm"
        h={500}
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={5}
        className={classes[name]}
        onBottomReached={() => {
          onBottomReached();
        }}
        onScrollPositionChange={() => {
          onMove();
        }}
      >
        <Stack gap={6}>
          {playlists[0] &&
            playlists.map((playlist: PlaylistType) => (
              <Menu
                key={playlist.identifier}
                opened={opened.identifier == playlist.identifier}
                position="right"
                loop={false}
                onChange={() => {
                  setOpened(defValue);
                }}
              >
                <Menu.Target key={playlist.identifier}>
                  <Text
                    c={
                      tab.identifier == playlist.identifier
                        ? "#fa5252"
                        : "rgba(255,255,255,0.8)"
                    }
                    fz="xs"
                    fw={500}
                    truncate
                    maw={140}
                    w="fit-content"
                    onClick={() => {
                      if (!playlist) return;
                      fetchPlaylist(playlist);
                    }}
                    onContextMenu={(e) => {
                      e.preventDefault();
                      if (!playlist) return;
                      setOpened(playlist);
                    }}
                  >
                    {playlist.name}
                  </Text>
                </Menu.Target>
                <Menu.Dropdown>
                  <Menu.Label fz="xs">{lang.playlist_options}</Menu.Label>
                  <Menu.Item
                    fz="xs"
                    leftSection={
                      <IconEdit style={{ width: rem(12), height: rem(12) }} />
                    }
                    onClick={() => {
                      handlePlaylist(opened);
                    }}
                  >
                    {lang.details}
                  </Menu.Item>
                  <Menu.Item
                    fz="xs"
                    leftSection={
                      <IconShare3 style={{ width: rem(12), height: rem(12) }} />
                    }
                    onClick={() => {
                      fetchNui("av_music", "copyCode", opened);
                    }}
                  >
                    {lang.share}
                  </Menu.Item>
                  <Menu.Item
                    fz="xs"
                    color="red"
                    leftSection={
                      <IconTrash style={{ width: rem(12), height: rem(12) }} />
                    }
                    onClick={handleDelete}
                  >
                    {lang.delete}
                  </Menu.Item>
                </Menu.Dropdown>
              </Menu>
            ))}
        </Stack>
      </ScrollArea>
    </Box>
  );
};
