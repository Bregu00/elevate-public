import { useState, useEffect } from "react";
import { Box, Text, Group } from "@mantine/core";
import classes from "./style.module.css";

interface TimerProps {
  deadline: any;
  expired: string;
}

export const Timer = ({ deadline, expired }: TimerProps) => {
  if (deadline === "") {
    return (
      <Box className={classes.container}>
        <Group gap={2} justify="center">
          <Text className={classes.title}>Battery Connected</Text>
        </Group>
      </Box>
    );
  }

  const [timeRemaining, setTimeRemaining] = useState(
    deadline - Math.floor(Date.now() / 1000)
  );

  const secondsToHMS = (sec: number): string => {
    const hours = Math.floor(sec / 3600);
    const minutes = Math.floor((sec % 3600) / 60);
    const remainingSeconds = sec % 60;

    const formattedHours = hours < 10 ? `0${hours}` : `${hours}`;
    const formattedMinutes = minutes < 10 ? `0${minutes}` : `${minutes}`;
    const formattedSeconds =
      remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;

    return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
  };

  useEffect(() => {
    const interval = setInterval(() => {
      setTimeRemaining((prevTimeRemaining) => {
        const newTimeRemaining = prevTimeRemaining - 1;
        return newTimeRemaining;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, [deadline]);

  return (
    <Box className={classes.container}>
      <Group gap={2} justify="center">
        <Text className={classes.title}>Battery :</Text>
        <Text className={classes.timer}>
          {timeRemaining > 0 ? secondsToHMS(timeRemaining) : expired}
        </Text>
      </Group>
    </Box>
  );
};
