import { useState, useEffect, lazy, Suspense } from "react";
import { Box, Tabs } from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { Loading } from "./Loading";
import { useRecoilState, useRecoilValue } from "recoil";
import { Leaderboard } from "./Leaderboard/Leaderboard";
import { Lang, Profile } from "../reducers/atoms";
import { Header } from "./Header/Header";
import classes from "./appStyle.module.css";

const Home = lazy(() => import("./Home/Home"));
const Tracks = lazy(() => import("./Tracks/Tracks"));
const Crew = lazy(() => import("./Crew/Crew"));
const Settings = lazy(() => import("./Settings/Settings"));

export const MainApp = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [profile, setProfile] = useRecoilState(Profile);
  const [currentTab, setCurrentTab] = useState<string | null>("home");
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getData");
      if (resp) {
        setProfile(resp);
        setTimeout(() => {
          setLoaded(true);
        }, 200);
      }
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.app}>
      {loaded ? (
        <>
          <Header />
          <div className={classes.gradient} />
          <Tabs
            color="rgba(205, 207, 102, 1)"
            defaultValue="home"
            classNames={classes}
            radius={0}
            onChange={(e) => {
              setCurrentTab(e);
            }}
          >
            <Tabs.List>
              <Tabs.Tab value="home">{lang.home_tab}</Tabs.Tab>
              <Tabs.Tab value="tracks" ml={4}>
                {lang.tracks_tab}
              </Tabs.Tab>
              {!profile.isCop && (
                <Tabs.Tab value="leaderboard" ml={4}>
                  {lang.leaderboard_tab}
                </Tabs.Tab>
              )}

              {profile.crew && profile.crew.name && (
                <Tabs.Tab value="crew" ml={4}>
                  {lang.crew_tab}
                </Tabs.Tab>
              )}
              <Tabs.Tab value="settings" ml={4}>
                {lang.settings_tab}
              </Tabs.Tab>
            </Tabs.List>
          </Tabs>
          <Suspense fallback={<Loading />}>
            {currentTab == "home" && <Home />}
            {currentTab == "tracks" && <Tracks />}
            {currentTab == "leaderboard" && <Leaderboard />}
            {currentTab == "crew" && <Crew />}
            {currentTab == "settings" && <Settings />}
          </Suspense>
        </>
      ) : (
        <Loading />
      )}
    </Box>
  );
};
