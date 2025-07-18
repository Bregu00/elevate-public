import { useState, useEffect } from "react";
import { MantineProvider, Box } from "@mantine/core";
import { TabComponent } from "./Tabs/Tabs";
import { getLang } from "../../hooks/getLang";
import { fetchNui } from "../../hooks/useNuiEvents";
import { Crews } from "./Crews/Crews";
import classes from "./style.module.css";
import { New } from "./NewCrew/New";

export const Admin = () => {
  const [lang, setLang] = useState({});
  const [loaded, setLoaded] = useState(false);
  const [activeTab, setActiveTab] = useState<string | null>("crews");
  const [allCrews, setAllCrews] = useState<any>([]);
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_racing", "closeAdmin");
        break;
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await getLang();
      setLang(resp);
      const crews = await fetchNui("av_racing", "getCrews");
      if (crews) {
        setAllCrews(crews);
      }
      setLoaded(true);
    };
    fetchData();
    window.addEventListener("keydown", onPressKey);
  }, []);

  if (!loaded) return <></>;
  return (
    <MantineProvider defaultColorScheme="dark">
      <Box className={classes.container}>
        <Box className={classes.box}>
          <TabComponent
            activeTab={activeTab}
            setTab={setActiveTab}
            lang={lang}
          />
          <Box className={classes.tabs} p="sm">
            {activeTab == "crews" && (
              <Crews
                lang={lang}
                allCrews={allCrews}
                setAllCrews={setAllCrews}
              />
            )}
            {activeTab == "newCrew" && <New lang={lang} />}
          </Box>
        </Box>
      </Box>
    </MantineProvider>
  );
};
