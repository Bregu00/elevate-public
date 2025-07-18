import { Box, Group, Transition } from "@mantine/core";
import { Buttons } from "./Mid/Buttons";
import { ProgressBar } from "./ProgressBar";
import { Right } from "./Right/Right";
import { SongInfo } from "./Left/SongInfo";
import { Liked } from "./Left/Liked";
import { useRecoilValue } from "recoil";
import { CurrentSong } from "../../reducers/atoms";
import { isEnvBrowser } from "../../hooks/useNuiEvents";
import { useState } from "react";
import { Playlist } from "./Playlist";
import classes from "./style.module.css";

export const Controls = () => {
  const song = useRecoilValue(CurrentSong);
  const [showPlaylist, setShowPlaylist] = useState(false);

  return (
    <>
      <Transition
        mounted={showPlaylist}
        transition="slide-left"
        enterDelay={500}
        exitDelay={55}
        timingFunction="ease"
      >
        {(styles) => <Playlist style={styles} show={setShowPlaylist} />}
      </Transition>
      <Box className={classes.container} mb={isEnvBrowser() ? `0` : `27px`}>
        <ProgressBar />
        <Box className={classes.controls}>
          <Box className={classes.buttonsContainer}>
            <Buttons />
          </Box>
          <Group
            className={classes.group}
            h="100%"
            w="100%"
            justify="space-between"
          >
            <Group ml="sm">
              {song.url !== "" && (
                <>
                  <SongInfo />
                  <Liked />
                </>
              )}
            </Group>

            <Right playlist={setShowPlaylist} />
          </Group>
          <Box className={classes.overlay} />
          <Box
            className={classes.backgroundImage}
            style={{
              backgroundImage: song.thumbnail
                ? `url('${song.thumbnail}')`
                : `transparent`,
            }}
          />
          <Box className={classes.backgroundColor} />
        </Box>
      </Box>
    </>
  );
};
