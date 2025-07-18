import { useEffect, useRef } from "react";

type ContinuousFunction = (option: string) => void;

export const useKeyHold = (
  key: string,
  onKeyPress: ContinuousFunction,
  onKeyRelease?: ContinuousFunction,
  delay = 1
) => {
  const isKeyPressedRef = useRef(false);
  const holdTimeoutRef = useRef<number | null>(null);

  const handleKeyDown = (event: KeyboardEvent) => {
    if (event.key === key && !isKeyPressedRef.current) {
      isKeyPressedRef.current = true;
      onKeyPress(key);
      startHoldCheck();
    }
  };

  const handleKeyUp = (event: KeyboardEvent) => {
    if (event.key === key) {
      isKeyPressedRef.current = false;
      onKeyRelease && onKeyRelease(key);
      stopHoldCheck();
    }
  };

  const startHoldCheck = () => {
    holdTimeoutRef.current = window.setTimeout(() => {
      if (isKeyPressedRef.current) {
        onKeyPress(key);
        startHoldCheck();
      }
    }, delay);
  };

  const stopHoldCheck = () => {
    if (holdTimeoutRef.current !== null) {
      clearTimeout(holdTimeoutRef.current);
      holdTimeoutRef.current = null;
    }
  };

  useEffect(() => {
    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("keyup", handleKeyUp);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
      window.removeEventListener("keyup", handleKeyUp);
      stopHoldCheck();
    };
  }, []);

  return stopHoldCheck;
};
