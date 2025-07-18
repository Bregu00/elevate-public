import { Box, Group, Text, Paper } from "@mantine/core";
import { IconHeart, IconVinyl } from "@tabler/icons-react";
import classes from "./style.module.css";
import { useSetRecoilState, useRecoilState } from "recoil";
import {
  clearSearch,
  CurrentTab,
  IsBusy,
  MusicList,
} from "../../../../reducers/atoms";
import { fetchNui } from "../../../../hooks/useNuiEvents";

interface CardProps {
  recordLabel: {
    thumbnail: string;
    name: string;
    label: string;
    likes: number;
    songs: number;
  };
  height: number;
  songLang: string;
}

export const CardProp = ({ recordLabel, height, songLang }: CardProps) => {
  const setTab = useSetRecoilState(CurrentTab);
  const setClear = useSetRecoilState(clearSearch);
  const [mainList, setMainList] = useRecoilState(MusicList);
  const [busy, setBusy] = useRecoilState(IsBusy);

  const handleOpen = async (name: string) => {
    if (busy || !name) return;
    setBusy(true);
    setTab({ type: "labels", identifier: name });
    setClear("_" + Math.random().toString(36).substr(2, 9));
    const resp = await fetchNui("av_music", "getPlaylistSongs", {
      identifier: name,
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
    <Paper radius="sm" className={classes.card}>
      <Box
        className={classes.overlay}
        style={{ backgroundImage: `url(${recordLabel.thumbnail})` }}
      />
      <Box
        className={classes.cover}
        style={{ backgroundImage: `url(${recordLabel.thumbnail})` }}
        onClick={() => {
          handleOpen(recordLabel.name);
        }}
      />
      <Box className={classes.content} mt="md">
        <Text fz="lg" c="white" truncate>
          {recordLabel.label}
        </Text>
        {height > 700 && (
          <Group gap="xs" justify="center" className={classes.info} mt="xs">
            <IconVinyl
              style={{
                width: "18px",
                height: "18px",
                color: "rgba(255,255,255,0.8)",
              }}
            />
            <Text fz="xs" c="rgba(255,255,255,0.8)" truncate>{`${
              recordLabel.songs ? recordLabel.songs : 0
            } ${songLang}`}</Text>
          </Group>
        )}
      </Box>
    </Paper>
  );
};
