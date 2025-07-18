import { useEffect, useState } from "react";
import { Group, Text, Slider, ActionIcon } from "@mantine/core";
import {
  IconVolume,
  IconVolume2,
  IconVolume3,
  IconList,
  IconHeadphones,
  IconHeadphonesFilled,
} from "@tabler/icons-react";
import { useRecoilState } from "recoil";
import { PlayerStatus } from "../../../reducers/atoms";
import { FormatTime } from "../../../hooks/formatTime";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import classes from "./styles.module.css";

interface Properties {
  playlist: (state: boolean) => void;
}

export const Right = ({ playlist }: Properties) => {
  const [player, setPlayer] = useRecoilState(PlayerStatus);
  const [volumeIcon, setVolumeIcon] = useState(
    <IconVolume2 style={{ width: "20px", height: "20px" }} />
  );
  const handleVolume = (value: number) => {
    const copy = { ...player, volume: value };
    setPlayer(copy);
    fetchNui("av_music", "volume", value);
  };
  const handleHeadphones = () => {
    if (isEnvBrowser()) {
      setPlayer({ ...player, headphones: true });
    }
    fetchNui("av_music", "headphones");
  };
  useEffect(() => {
    if (player.volume > 0.5) {
      setVolumeIcon(<IconVolume style={{ width: "20px", height: "20px" }} />);
      return;
    }
    if (player.volume == 0) {
      setVolumeIcon(<IconVolume3 style={{ width: "20px", height: "20px" }} />);
      return;
    }
    setVolumeIcon(<IconVolume2 style={{ width: "20px", height: "20px" }} />);
  }, [player.volume]);

  return (
    <Group mr="sm">
      <Group gap={2}>
        <Text fz="xs" c="gray.5" mr={2} fw={500}>
          {player.playedSeconds ? FormatTime(player.playedSeconds) : `00:00`}
        </Text>
        <Text fz="xs" c="gray.5" fw={500}>
          /
        </Text>
        <Text fz="xs" ml={2} c="gray.2" fw={500}>
          {player.duration ? FormatTime(player.duration) : `00:00`}
        </Text>
      </Group>
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
          value={player.volume}
          label={Math.floor(player.volume * 100)}
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
      <Group gap="xs">
        <ActionIcon
          size="xs"
          variant="transparent"
          color={player.headphones ? "green" : "white"}
          onClick={handleHeadphones}
        >
          {player.headphones ? <IconHeadphonesFilled /> : <IconHeadphones />}
        </ActionIcon>
        {player.headphones && (
          <ActionIcon
            size="xs"
            variant="transparent"
            color="white"
            onClick={() => {
              playlist(true);
            }}
          >
            <IconList />
          </ActionIcon>
        )}
      </Group>
    </Group>
  );
};
