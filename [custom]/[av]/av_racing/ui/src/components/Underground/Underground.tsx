import { useState, useEffect } from "react";
import { MantineProvider, Box, Text, Kbd } from "@mantine/core";
import { useNuiEvent, fetchNui } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";

export const Underground = () => {
  const [playerInfo, setPlayerInfo]: any = useState();
  useNuiEvent("slotInfo", (data: any) => {
    setPlayerInfo(data);
  });
  const handleClose = () => {
    fetchNui("av_racing", "exitUnderground");
  };
  const handleLeft = () => {
    fetchNui("av_racing", "leftCam");
  };
  const handleRight = () => {
    fetchNui("av_racing", "rightCam");
  };
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        handleClose();
        break;
      case "Backspace":
        handleClose();
        break;
      case "ArrowLeft":
        handleLeft();
        break;
      case "ArrowRight":
        handleRight();
        break;
      default:
        break;
    }
  };
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
    return () => {
      window.removeEventListener("keydown", onPressKey);
    };
  }, []);
  return (
    <MantineProvider defaultColorScheme="dark">
      <Box className={classes.wrapper}>
        {playerInfo && (
          <>
            <Box className={classes.trackName}>{playerInfo.trackName}</Box>
            <Box className={classes.trackShadow}>{playerInfo.trackName}</Box>
            <Box className={classes.box}>
              <Box className={classes.boxInfo}>
                <Box className={classes.header}>{playerInfo.name}</Box>
                <Box
                  style={{
                    background: "url(./underground.jpeg)",
                    width: "100%",
                    height: "22px",
                  }}
                />
                <Box className={classes.story} mt="xs" p="xs">
                  {playerInfo.settings.story}
                </Box>
                <Box className={classes.info} p="xs">
                  <Text
                    c="yellow.3"
                    size="lg"
                  >{`Age / ${playerInfo?.settings?.age}`}</Text>
                  <Text
                    c="yellow.3"
                    size="lg"
                  >{`Nationality / ${playerInfo?.settings?.nationality}`}</Text>
                  <Text
                    c="yellow.3"
                    size="lg"
                  >{`Total Time / ${playerInfo.time}`}</Text>
                  {playerInfo?.crew && (
                    <Text
                      c="yellow.3"
                      size="lg"
                    >{`Crew / ${playerInfo.crew.label}`}</Text>
                  )}
                </Box>
              </Box>
              <Box mt={"xs"}>
                <Kbd
                  size="sm"
                  styles={{
                    root: {
                      backgroundColor: "rgba(26,26,26,0.8)",
                      border: "solid 1px rgba(255,255,255,0.3)",
                    },
                  }}
                >{` ← `}</Kbd>
                <Kbd
                  size="sm"
                  ml={10}
                  styles={{
                    root: {
                      backgroundColor: "rgba(26,26,26,0.8)",
                      border: "solid 1px rgba(255,255,255,0.3)",
                    },
                  }}
                >{` → `}</Kbd>
                <Kbd
                  size="sm"
                  ml={10}
                  styles={{
                    root: {
                      backgroundColor: "rgba(26,26,26,0.8)",
                      border: "solid 1px rgba(255,255,255,0.3)",
                    },
                  }}
                >{` ESC `}</Kbd>
              </Box>
            </Box>
          </>
        )}
      </Box>
    </MantineProvider>
  );
};
