import { useEffect, useState } from "react";
import { MantineProvider } from "@mantine/core";
import { Lang } from "./reducers/atoms";
import { useSetRecoilState } from "recoil";
import { Overlay } from "./components/Overlay/Overlay";
import { getLang } from "./hooks/getLang";
import "@mantine/core/styles.css";
import { CameraType } from "./types/types";

interface Properties {
  camera: CameraType | null;
}

const View = ({ camera }: Properties) => {
  const setLang = useSetRecoilState(Lang);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang();
      setLang(resp);
      setLoaded(true);
    };
    fetchLang();
  }, []);
  return (
    <>
      {loaded && (
        <MantineProvider defaultColorScheme="dark">
          <Overlay camera={camera} />
        </MantineProvider>
      )}
    </>
  );
};

export default View;
