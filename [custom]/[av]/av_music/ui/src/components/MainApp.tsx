import { useState, useEffect } from "react";
import { Box, Grid } from "@mantine/core";
import { ModalMenu } from "./ModalMenu/ModalMenu";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { useRecoilState, useRecoilValue, useSetRecoilState } from "recoil";
import {
  backgroundImage,
  CurrentTab,
  favoriteSongs,
  Lang,
  myPlaylists,
  PlayerStatus,
} from "../reducers/atoms";
import { NavBar } from "./NavBar/NavBar";
import { Content } from "./Content/Content";
import { Controls } from "./Controls/Controls";
import { Loading } from "./Loading";
import { PlaylistMenu } from "./PlaylistMenu/PlaylistMenu";
import { PlaylistType } from "../types/types";
import classes from "./appStyle.module.css";

const defValue: PlaylistType = {
  name: "",
  cover: "",
  description: "",
  identifier: "",
};

export const MainApp = () => {
  const lang: any = useRecoilValue(Lang);
  const tab = useRecoilValue(CurrentTab);
  const background = useRecoilValue(backgroundImage);
  const [player, setPlayer] = useRecoilState(PlayerStatus);
  const setPlaylists = useSetRecoilState(myPlaylists);
  const setFavorites = useSetRecoilState(favoriteSongs);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [showModal, setShowModal] = useState(false);
  const [playlist, setPlaylist] = useState(defValue);
  const [showPlaylist, setShowPlaylist] = useState(false);
  const [modalOptions, setModalOptions] = useState({});

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_music", "getData");
      if (resp) {
        setPlaylists(resp.playlists);
        setFavorites(resp.favorites);
        setPlayer({ ...player, headphones: resp.headphones });
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  const handlePlaylist = (data?: PlaylistType) => {
    setPlaylist({
      cover: data?.cover || "",
      name: data?.name || "",
      description: data?.description || "",
      identifier: data?.identifier,
    });
    setShowPlaylist(true);
  };
  const importMenu = () => {
    setModalOptions({
      title: lang.import_playlist,
      options: [
        { type: "text", name: "code", title: lang.code, asterisk: true },
      ],
      button: lang.import,
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleCallback = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    const { code } = data;
    if (code) {
      const resp = await fetchNui("av_music", "importPlaylist", code);
      if (resp) {
        setPlaylists(resp);
      }
    }
  };
  return (
    <Box className={classes.app}>
      {showPlaylist && (
        <PlaylistMenu playlist={playlist} show={setShowPlaylist} />
      )}
      <Controls />
      {showModal && <ModalMenu data={modalOptions} />}
      <Grid className={classes.mainGrid} h="100%" gutter={0}>
        <Grid.Col maw={185} style={{ zIndex: 1 }}>
          <NavBar handlePlaylist={handlePlaylist} openImport={importMenu} />
        </Grid.Col>
        <Grid.Col span={"auto"}>
          <Box
            style={{
              position: "absolute",
              filter: "blur(75px)",
              zIndex: 0,
              opacity: 0.1,
              display:
                background !== "" && tab.type !== "home" ? "block" : "none",
              background: `url('${background}')`,
              backgroundSize: "cover",
              width: "100%",
              height: "100%",
            }}
          />
          {!loaded ? <Loading /> : <Content />}
        </Grid.Col>
      </Grid>
    </Box>
  );
};
