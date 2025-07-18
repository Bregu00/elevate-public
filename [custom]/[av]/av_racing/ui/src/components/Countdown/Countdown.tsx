import { useEffect, useState } from "react";
import "./countdown.css";

interface Properties {
  unmount: (state: boolean) => void;
}

export const Countdown = ({ unmount }: Properties) => {
  const [currentNumber, setCurrentNumber] = useState<number | string>(5);
  useEffect(() => {
    const interval = setInterval(() => {
      if (!Number(currentNumber)) {
        unmount(false);
        return;
      }
      if (Number(currentNumber) <= 1) {
        setCurrentNumber("GO!");
      } else {
        setCurrentNumber(Number(currentNumber) - 1);
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [currentNumber]);

  return (
    <div className="show-numbers">
      <div className="big-outer animate-big-left-to-right">{currentNumber}</div>
      <div className="small-fill animate-small-left-to-right">
        {currentNumber}
      </div>
    </div>
  );
};
