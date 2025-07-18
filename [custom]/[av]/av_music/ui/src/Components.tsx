import { useEffect, useState } from "react";
import { MantineProvider } from "@mantine/core";
import RecordLabel from "./RecordLabel/RecordLabel";
import MiniPlayer from "./MiniPlayer/MiniPlayer";
import { QueryResults } from "./types/types";
import { getLang } from "./hooks/getLang";
import App from "./App";
import { useSetRecoilState } from "recoil";
import { Lang } from "./reducers/atoms";
import { isEnvBrowser, useNuiEvent } from "./hooks/useNuiEvents";

export const Components = () => {
  const setLang = useSetRecoilState(Lang);
  const [showApp, setShowApp] = useState(isEnvBrowser());
  const [showPlayer, setShowPlayer] = useState(false);
  const [showRecord, setShowRecord] = useState(false);
  const [zone, setZone] = useState("");
  const [songs, setSongs] = useState<QueryResults[]>([]);

  useNuiEvent("updatePlaylist", (playlist: QueryResults[]) => {
    setSongs(playlist);
  });
  window.addEventListener("message", (event) => {
    switch (event.data.message) {
      case "loadApp":
        setShowApp(true);
        break;
      case "player":
        setShowPlayer(event.data.state);
        setSongs(event.data.songs);
        break;
      case "recordLabel":
        setShowRecord(event.data.state);
        setZone(event.data.zone);
        break;
      case "close":
        setShowApp(false);
        break;
      default:
        break;
    }
  });
  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang();
      setLang(resp);
    };
    fetchLang();
  }, []);

  return (
    <MantineProvider defaultColorScheme="dark">
      {showPlayer && <MiniPlayer songs={songs} />}
      {showRecord && <RecordLabel zone={zone} />}
      {showApp && <App />}
    </MantineProvider>
  );
};
