import { useState, useEffect } from "react";
import { Text } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";
interface TimerProps {
  deadline: number;
}

export const Timer = ({ deadline }: TimerProps) => {
  const lang: any = useRecoilValue(Lang);
  const [currentTime, setCurrentTime] = useState("");
  const [currentDeadline, setCurrentDeadline] = useState(deadline);
  const getTime = () => {
    deadline -= 1;
    setCurrentDeadline(deadline);
    //const time = new Date(deadline * 1000).toISOString().substring(11, 19)
    setCurrentTime(secondsToHMS(deadline));
  };
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
    const interval = setInterval(() => getTime(), 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <Text display="flex" fz={"xs"} fw={"lighter"} c="gray.5">
      {currentDeadline > 0 ? (
        <>
          <Text fz={"xs"} mr={5} fw={"lighter"} c="dimmed">
            {lang.startsin}
          </Text>{" "}
          {currentTime}
        </>
      ) : (
        <>{lang.started}</>
      )}
    </Text>
  );
};
