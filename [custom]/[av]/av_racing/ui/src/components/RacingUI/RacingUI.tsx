import { useState } from "react";
import { MantineProvider, Box, Text, Group, Flex } from "@mantine/core";
import { useNuiEvent } from "../../hooks/useNuiEvents";
import { FormatTime } from "../../hooks/formatTime";
import {
  IconGrain,
  IconCircleDotted,
  IconHistoryToggle,
} from "@tabler/icons-react";
import "@mantine/core/styles.css";
import classes from "./style.module.css";

export const RacingUI = ({ lang }: any) => {
  const [info, setInfo] = useState({
    CurrentCheckpoint: 1,
    TotalCheckpoints: 1,
    TotalLaps: 1,
    CurrentLap: 1,
    RaceName: "AV Scripts",
    Time: 0,
    TotalTime: 0,
    BestLap: 0,
    Position: 0,
    TotalRacers: 0,
  });
  useNuiEvent("updateUI", (data) => {
    setInfo(data);
  });

  return (
    <MantineProvider defaultColorScheme="dark">
      <Box className={classes.wrapper}>
        <Box className={classes.box}>
          <Group className={classes.group} grow gap="xs">
            <Flex direction="column" gap={0} mt="sm">
              <Text className={classes.title} lh={0.75}>
                {lang.position}
              </Text>
              <Text
                className={classes.text}
                fw={600}
              >{`${info.Position}/${info.TotalRacers}`}</Text>
            </Flex>
            <IconGrain className={classes.icon} />
          </Group>
          {info.TotalLaps > 0 && (
            <Group className={classes.group} grow gap="xs">
              <Flex direction="column" gap={0} mt="sm">
                <Text className={classes.title} lh={0.75}>
                  {lang.laps}
                </Text>
                <Text
                  className={classes.text}
                  fw={600}
                >{`${info.CurrentLap}/${info.TotalLaps}`}</Text>
              </Flex>
              <IconCircleDotted className={classes.icon} />
            </Group>
          )}
          <Group className={classes.group} grow gap="xs">
            <Flex direction="column" gap={0} mt="sm">
              <Text className={classes.title} lh={0.75}>
                {lang.checkpoints}
              </Text>
              <Text
                className={classes.text}
                fw={600}
              >{`${info.CurrentCheckpoint}/${info.TotalCheckpoints}`}</Text>
            </Flex>
            <IconCircleDotted className={classes.icon} />
          </Group>
          <Group className={classes.group} grow gap="xs">
            <Flex direction="column" gap={0} mt="sm">
              <Text className={classes.title} lh={0.75}>
                {lang.best}
              </Text>
              <Text className={classes.text} fw={600}>
                <FormatTime milli={info.BestLap} />
              </Text>
            </Flex>
            <IconHistoryToggle className={classes.icon} stroke={1.5} />
          </Group>
          <Group className={classes.group} grow gap="xs">
            <Flex direction="column" gap={0} mt="sm">
              <Text className={classes.title} lh={0.75}>
                {lang.current}
              </Text>
              <Text className={classes.text} fw={600}>
                <FormatTime milli={info.Time} />
              </Text>
            </Flex>
            <IconHistoryToggle className={classes.icon} stroke={1.5} />
          </Group>
          <Group className={classes.group} grow gap="xs">
            <Flex direction="column" gap={0} mt="sm">
              <Text className={classes.title} lh={0.75}>
                {lang.total}
              </Text>
              <Text className={classes.text} fw={600}>
                <FormatTime milli={info.TotalTime} />
              </Text>
            </Flex>
            <IconHistoryToggle className={classes.icon} stroke={1.5} />
          </Group>
        </Box>
      </Box>
    </MantineProvider>
  );
};
