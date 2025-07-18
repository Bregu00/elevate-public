import { useState, useEffect } from "react";
import { getLang } from "./hooks/getLang";
import { useNuiEvent } from "./hooks/useNuiEvents";
import { Countdown } from "./components/Countdown/Countdown";
import { RacingUI } from "./components/RacingUI/RacingUI";

export const RacingPanel = () => {
  const [loaded, setLoaded] = useState(false);
  const [lang, setLang] = useState<any>({});
  const [countdown, setCountdown] = useState(false);
  const [showPanel, setShowPanel] = useState(true);
  useNuiEvent("showCountdown", (state: boolean) => {
    setCountdown(state);
  });
  useNuiEvent("showPanel", (state: boolean) => {
    setShowPanel(state);
  });
  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang();
      setLang(resp);
      setLoaded(true);
    };
    fetchLang();
  }, []);
  if (!loaded) return <></>;

  return (
    <>
      {countdown && <Countdown unmount={setCountdown} />}
      {showPanel && <RacingUI lang={lang} setShowPanel={setShowPanel} />}
    </>
  );
};
