import { useState, Suspense, lazy, useEffect } from "react";
import { Box } from '@mantine/core';
import { fetchNui, isEnvBrowser, useNuiEvent } from "../hooks/useNuiEvents";
import { useRecoilState } from 'recoil';
import { Profile } from "../reducers/atoms";
import { Header } from "./Header/Header";
import { Navbar } from "./NavBar/Navbar";
import { Loading } from "./Loading";
import Settings from "./Settings/Settings";
import './appstyle.css'

const Contracts = lazy(() => import("./Contracts/Contracts"));
const Auctions = lazy(() => import("./Auctions/Auctions"));
const Leaderboard = lazy(() => import("./Leaderboard/Leaderboard"));
const Groups = lazy(() => import("./Groups/Groups"));

export const MainApp = () => {
  const [loaded, setLoaded] = useState(isEnvBrowser())
  const [showProfile, setShowProfile] = useState(false)
  const [currentTab, setCurrentTab] = useState<string | null>("contracts")
  const [profile, setProfile] = useRecoilState(Profile);

  useNuiEvent("updateCrypto", (data:number) => {
    const newProfile = {...profile, ['crypto']: data}
    setProfile(newProfile)
  })
  useEffect(() => {
    const fetchProfile = async () => {
      const resp = await fetchNui("av_boosting", "getProfile")
      if(resp) {
        setProfile(resp)
        setTimeout(() => {
          setLoaded(true)
        }, 100);
      } else { 
        console.log("[WARNING] Something went wrong when trying to fetch your Boosting profile, report it to your server admin.")
        console.log("[WARNING] Something went wrong when trying to fetch your Boosting profile, report it to your server admin.")
        console.log("[WARNING] Something went wrong when trying to fetch your Boosting profile, report it to your server admin.")
      }
    }
    fetchProfile()
  }, [])
  
  return (
    <Box className="app" p={"sm"} >
      {loaded ?
        <Box className="app-container">
          <Header open={setShowProfile} isOpen={showProfile}/>
          <Box className="container">
            <Suspense
              fallback={
                <Loading/>
              }
            >
              {showProfile && <Settings show={setShowProfile}/>}
              <Navbar currentTab={currentTab} setCurrentTab={setCurrentTab}/>
              <Box className="content">
                {currentTab == "contracts" && <Contracts/>}
                {currentTab == "auctions" && <Auctions/>}
                {currentTab == "leaderboard" && <Leaderboard/>}
                {currentTab == "groups" && <Groups/>}
              </Box>
            </Suspense>
          </Box>
        </Box>
      :
        <Loading/>
      }
    </Box>
  )
}