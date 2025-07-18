import { useState } from "react";
import {
  Box,
  Group,
  Text,
  Button,
  Flex,
  TextInput,
  Textarea,
  Image,
} from "@mantine/core";
import { useClickOutside } from "@mantine/hooks";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, myPlaylists } from "../../reducers/atoms";
import { PlaylistType } from "../../types/types";
import classes from "./style.module.css";

interface Properties {
  show: (option: boolean) => void;
  playlist: PlaylistType;
}

export const PlaylistMenu = ({ playlist, show }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [myPlaylist, setPlaylist] = useRecoilState(myPlaylists);
  const [data, setData] = useState(playlist);
  const ref = useClickOutside(() => show(false));
  const handleUpdate = (field: string, value: string) => {
    const copy = { ...data, [field]: value };
    setData(copy);
  };
  const savePlaylist = async () => {
    show(false);
    const resp = await fetchNui("av_music", "savePlaylist", data);
    if (resp) {
      const index = myPlaylist.findIndex(
        (playlist) => playlist.identifier === resp.identifier
      );
      if (index !== -1) {
        const updatedPlaylists = [...myPlaylist];
        updatedPlaylists[index] = resp;
        setPlaylist(updatedPlaylists);
      } else {
        setPlaylist((data) => [...data, resp]);
      }
    }
  };
  return (
    <Box className={classes.container}>
      <Box className={classes.box} ref={ref}>
        <Text fw={500} fz="sm" c="red.5">
          {data.name ? data.name : lang.tab_create}
        </Text>
        <Group className={classes.info} mt="xs" gap={"xs"}>
          <Image
            src={data.cover}
            bg="#101010"
            fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png"
            radius={4}
            h={130}
            w={130}
          />
          <Flex direction="column" gap="xs">
            <TextInput
              classNames={classes}
              placeholder={lang.name}
              value={data.name}
              radius={4}
              size="xs"
              onChange={(e) => {
                handleUpdate("name", e.target.value);
              }}
            />
            <TextInput
              classNames={classes}
              value={data.cover}
              placeholder={lang.cover}
              radius={4}
              size="xs"
              onChange={(e) => {
                handleUpdate("cover", e.target.value);
              }}
            />
            <Textarea
              classNames={classes}
              value={data.description}
              placeholder={lang.description}
              radius={4}
              size="xs"
              onChange={(e) => {
                handleUpdate("description", e.target.value);
              }}
              maxLength={30}
            />
          </Flex>
        </Group>
        <Button
          fullWidth
          mt="sm"
          size="xs"
          color="gray"
          variant="light"
          tt="uppercase"
          onClick={savePlaylist}
        >
          {lang.save_playlist}
        </Button>
      </Box>
    </Box>
  );
};
