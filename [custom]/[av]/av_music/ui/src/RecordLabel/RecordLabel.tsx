import { useEffect, useState } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { Lang } from "../reducers/atoms";
import { useRecoilValue } from "recoil";
import { Loading } from "../components/Loading";
import { Panel } from "./Panel/Panel";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { QueryResults } from "../types/types";
import { ModalMenu } from "../components/ModalMenu/ModalMenu";
import { isYoutubeUrl } from "../hooks/getTrack";
import { GetYoutubeInfo } from "../hooks/getYoutubeInfo";
import classes from "./style.module.css";

interface Properties {
  zone: string;
}

interface LabelData {
  name: string;
  label: string;
  thumbnail: string;
  description: string;
}

const test: LabelData = {
  name: "av_scripts",
  label: "AV Scripts",
  thumbnail: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png",
  description: "Best Laptop in Fivem <3",
};

const RecordLabel = ({ zone }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [info, setInfo] = useState<LabelData>(test);
  const [allSongs, setAllSongs] = useState<QueryResults[]>([]);
  const [permissions, setPermissions] = useState({
    canBurn: false,
    canDelete: false,
    canAdd: false,
  });
  const [showModal, setShowModal] = useState(false);
  const [modalOptions, setModalOptions] = useState({});
  const handleAdd = () => {
    setModalOptions({
      title: lang.add_song,
      options: [
        {
          name: "url",
          type: "text",
          title: lang.song_url,
          asterisk: true,
        },
        {
          name: "title",
          type: "text",
          title: lang.song_title,
        },
        {
          name: "artist",
          type: "text",
          title: lang.artist,
        },
        {
          name: "album",
          type: "text",
          title: lang.album,
        },
        {
          name: "cover",
          type: "text",
          title: lang.cover,
        },
      ],
      button: lang.confirm,
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleBurn = (data: QueryResults[]) => {
    setModalOptions({
      title: lang.burn_cd,
      options: [
        {
          name: "copies",
          type: "number",
          max: 20,
          title: lang.amount,
          asterisk: true,
        },
        {
          name: "cover",
          type: "text",
          title: lang.cover,
        },
        {
          name: "description",
          type: "text",
          max: 30,
          title: lang.description,
        },
      ],
      button: lang.confirm,
      extraData: data,
      callback: burnCallback,
    });
    setShowModal(true);
  };
  const burnCallback = (data: any) => {
    setShowModal(false);
    if (!data) return;
    fetchNui("av_music", "burnCD", data);
  };
  const handleCallback = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    const { url } = data;
    if (!url) return;
    if (isYoutubeUrl(url)) {
      const resp = await GetYoutubeInfo(url);
      const list = await fetchNui("av_music", "registerSong", {
        info: resp,
        input: data,
        zone,
      });
      if (list) {
        setAllSongs(list);
      }
    }
  };
  const handleDelete = (songs: QueryResults[]) => {
    setModalOptions({
      title: lang.delete_confirmation,
      options: [
        {
          type: "info",
          description: lang.delete_message,
          style: { textAlign: "center" },
        },
      ],
      button: lang.confirm,
      callback: confirmDelete,
      extraData: songs,
    });
    setShowModal(true);
  };
  const confirmDelete = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    const { extraData } = data;
    const resp = await fetchNui("av_music", "deleteSongs", {
      songs: extraData,
      zone,
    });
    if (resp) {
      setAllSongs(resp);
    }
  };
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_music", "closeLabel");
        break;
      default:
        break;
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const data = await fetchNui("av_music", "getRecordData", zone);
      if (data) {
        setPermissions(data.permissions);
        setAllSongs(data.songs);
        setInfo(data.info);
        setLoaded(true);
      } else {
        fetchNui(
          "av_music",
          "error",
          `Label ${zone} doesn't exist in your server (?)`
        );
      }
    };
    fetchData();
    window.addEventListener("keydown", onPressKey);
    return () => {
      window.removeEventListener("keydown", onPressKey);
    };
  }, []);
  return (
    <MantineProvider defaultColorScheme="dark">
      {!loaded ? (
        <Loading />
      ) : (
        <>
          <Box className={classes.container}>
            <Box className={classes.box} p="md">
              {showModal && <ModalMenu data={modalOptions} />}
              <Panel
                info={info}
                allSongs={allSongs}
                permissions={permissions}
                handleAdd={handleAdd}
                handleDelete={handleDelete}
                handleBurn={handleBurn}
              />
            </Box>
          </Box>
        </>
      )}
    </MantineProvider>
  );
};

export default RecordLabel;
