import {useState, useEffect} from 'react'
interface TimerProps {
  deadline: number,
  expired: string
}

export const Timer = ({ deadline, expired }:TimerProps) => {
   const [currentTime, setCurrentTime] = useState("");
   const [currentDeadline, setCurrentDeadline] = useState(deadline);
  const getTime = () => {
    deadline -= 1
    setCurrentDeadline(deadline)
    setCurrentTime(secondsToHMS(deadline))
  };
  const secondsToHMS = (sec: number): string => {
    const hours = Math.floor(sec / 3600);
    const minutes = Math.floor((sec % 3600) / 60);
    const remainingSeconds = sec % 60;

    const formattedHours = hours < 10 ? `0${hours}` : `${hours}`;
    const formattedMinutes = minutes < 10 ? `0${minutes}` : `${minutes}`;
    const formattedSeconds = remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;

    return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
  };
  useEffect(() => {
    const interval = setInterval(() => getTime(), 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <>
      {currentDeadline > 0 ? `${currentTime}` : `${expired}`}
    </>
  );
};