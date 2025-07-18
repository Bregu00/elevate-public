import { useState, useEffect, useRef } from "react";
import {
  ActionIcon,
  Box,
  Group,
  Text,
  Tooltip,
  rem,
  Image,
} from "@mantine/core";
import {
  IconVideo,
  IconSun,
  IconMoon,
  IconLogout,
  IconScreenshot,
  IconPlayerRecord,
  IconPlayerRecordFilled,
  IconView360Arrow,
} from "@tabler/icons-react";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import { CameraType } from "../../types/types";
import classes from "./style.module.css";
import { useGameViewWithRecording } from "../../hooks/gameView";
import { useKeyHold } from "../../hooks/keypressed";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

const test = {
  thumbnail:
    "https://cdn.discordapp.com/attachments/1065015399026020372/1267594784273338510/screenshot.jpg?ex=66a95b23&is=66a809a3&hm=f6da099b94d88a4876c856b0a3331e2b80c5b7a9604f53d1a5f9874035402293&",
  id: 3,
  label: "Test Cam",
  coords: {
    h: 56.42404174804685,
    y: -1474.6820068359376,
    z: 36.72748565673828,
    rotZ: 57.92404174804687,
    rotY: -0.0,
    rotX: -9.99999999999998,
    x: -46.93073654174805,
  },
  type: "normal",
  battery: 1722461336,
  status: "working",
  owner: "EIU61222",
  location: "Forum Dr",
  group: "W35UIO1OS248969",
  settings: {
    vehicle: true,
    canDestroy: true,
    nightvision: true,
    rotation: false,
    thermal: true,
    hackeable: true,
    prop: -203475463,
    battery: 48,
  },
  identifier: "testcam-65J1O1P",
};

interface Properties {
  camera: CameraType | null;
}

export const Overlay = ({ camera }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [token, setToken] = useState("");
  const [service, setService] = useState("fivemanage");
  const [showUI, setShowUI] = useState(true);
  const [recording, setRecording] = useState(false);
  const [allCameras, setAllCameras] = useState<CameraType[]>([]);
  const [currentCam, setCurrentCam] = useState(camera || test);
  const [thermal, setThermal] = useState(false);
  const [nightvision, setNightvision] = useState(false);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const { startRecording, stopRecording } = useGameViewWithRecording(
    canvasRef,
    setRecording
  );
  const iconStyle = { width: rem(18), height: rem(18) };

  useNuiEvent("setCameras", (data: any) => {
    setAllCameras(data);
  });
  useNuiEvent("setCamera", (data: any) => {
    setCurrentCam(data);
  });
  const handleNight = () => {
    const state = !nightvision;
    setNightvision(state);
    fetchNui("av_cameras", "nightvision", state);
  };
  const handleThermal = () => {
    const state = !thermal;
    setThermal(state);
    fetchNui("av_cameras", "thermal", state);
  };
  const useCam = (cam: CameraType) => {
    setCurrentCam(cam);
    setNightvision(false);
    setThermal(false);
    fetchNui("av_cameras", "useCam", cam);
  };
  const handleExit = () => {
    fetchNui("av_cameras", "exit");
  };
  const handlePhoto = async () => {
    setShowUI(false);
    await fetchNui("av_cameras", "takePhoto", {
      identifier: currentCam.identifier,
    });
    setShowUI(true);
  };
  const handleRecording = () => {
    if (!recording) {
      startRecording(currentCam.identifier, token, service);
    } else {
      stopRecording();
    }
    setRecording(!recording);
  };
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_cameras", "exit");
        break;
      default:
        break;
    }
  };
  const handleMove = () => {
    fetchNui("av_cameras", "rotation");
  };
  const onHoldKey = (key: string) => {
    if (!currentCam?.settings?.rotation || currentCam.status == "broken")
      return;
    fetchNui("av_cameras", "rotate", key);
  };
  useKeyHold("a", onHoldKey);
  useKeyHold("s", onHoldKey);
  useKeyHold("d", onHoldKey);
  useKeyHold("w", onHoldKey);
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "getConfig");
      if (resp) {
        setToken(resp.token);
        setService(resp.service);
      }
    };
    fetchData();
    window.addEventListener("keydown", onPressKey);
    return () => {
      window.removeEventListener("keydown", onPressKey);
    };
  }, []);
  return (
    <>
      <Box className={classes.container}>
        <canvas ref={canvasRef} style={{ display: "none" }}></canvas>
        {showUI && (
          <Box className={classes.box} p="sm">
            <Text ta="center" fz="lg" fw={500}>
              {lang.cameraControls}
            </Text>
            <Group className={classes.controls} mt="sm" gap="xs">
              {currentCam?.settings?.thermal &&
              currentCam.status !== "broken" ? (
                <Tooltip label={lang.thermal} color="dark.4" fz="xs">
                  <ActionIcon
                    variant="transparent"
                    color={thermal ? `teal` : `gray`}
                    onClick={handleThermal}
                  >
                    <IconSun style={iconStyle} />
                  </ActionIcon>
                </Tooltip>
              ) : null}
              {currentCam?.settings?.nightvision &&
              currentCam.status !== "broken" ? (
                <Tooltip label={lang.nightvision} color="dark.4" fz="xs">
                  <ActionIcon
                    variant="transparent"
                    color={nightvision ? `teal` : `gray`}
                    onClick={handleNight}
                  >
                    <IconMoon style={iconStyle} />
                  </ActionIcon>
                </Tooltip>
              ) : null}
              {currentCam.status !== "broken" && (
                <>
                  <Tooltip label={lang.photo} color="dark.4" fz="xs">
                    <ActionIcon
                      variant="transparent"
                      color="gray"
                      onClick={handlePhoto}
                    >
                      <IconScreenshot style={iconStyle} />
                    </ActionIcon>
                  </Tooltip>
                  {recording ? (
                    <Tooltip label={lang.stop} color="dark.4" fz="xs">
                      <ActionIcon
                        variant="transparent"
                        color="red"
                        onClick={handleRecording}
                      >
                        <IconPlayerRecordFilled style={iconStyle} />
                      </ActionIcon>
                    </Tooltip>
                  ) : (
                    <Tooltip label={lang.record} color="dark.4" fz="xs">
                      <ActionIcon
                        variant="transparent"
                        color="gray"
                        onClick={handleRecording}
                      >
                        <IconPlayerRecord style={iconStyle} />
                      </ActionIcon>
                    </Tooltip>
                  )}
                </>
              )}

              {currentCam?.settings?.rotation &&
              currentCam.status !== "broken" ? (
                <Tooltip label={lang.rotate} color="dark.4" fz="xs">
                  <ActionIcon variant="transparent" onClick={handleMove}>
                    <IconView360Arrow style={iconStyle} />
                  </ActionIcon>
                </Tooltip>
              ) : null}
              <Tooltip label={lang.exit} color="dark.4" fz="xs">
                <ActionIcon
                  variant="transparent"
                  color="red"
                  onClick={handleExit}
                >
                  <IconLogout style={iconStyle} />
                </ActionIcon>
              </Tooltip>
            </Group>
            <Box className={classes.camList} mt="sm">
              {allCameras.map((cam: CameraType) => (
                <Group
                  key={cam.identifier}
                  p={4}
                  className={classes.camera}
                  onClick={() => {
                    useCam(cam);
                  }}
                >
                  <IconVideo
                    style={{
                      width: rem(18),
                      height: rem(18),
                      color:
                        currentCam.identifier == cam.identifier
                          ? "#63e6be"
                          : "#b197fc",
                    }}
                    stroke={1.5}
                  />
                  <Text>{cam.label}</Text>
                </Group>
              ))}
            </Box>
          </Box>
        )}
        {currentCam.status == "broken" && (
          <Image src="./broken.png" w="100%" h="100%" />
        )}
      </Box>
    </>
  );
};
