import { useEffect, useState, lazy, Suspense } from "react";
import { Box, LoadingOverlay } from "@mantine/core"
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { useSetRecoilState } from 'recoil';
import { Permissions } from "../reducers/atoms";
import { NavbarMinimal } from "./NavBar/NavBar";
import './restaurants.css'

const Overview = lazy(() => import("./Content/Overview/Overview"));
const Bank = lazy(() => import("./Content/Bank/Bank"));
const Applications = lazy(() => import("./Content/Applications/Applications"));
const Employees = lazy(() => import("./Content/Employees/Employees"));
const Menu = lazy(() => import("./Content/Menu/Menu"));
const Settings = lazy(() => import("./Content/Settings/Settings"));

export const Restaurants = () => {
  const setPermissions = useSetRecoilState(Permissions)
  const [currentTab, setCurrentTab] = useState("overview")
  const [loaded, setLoaded] = useState(true)
  const [blip, setBlip] = useState(false)

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "fetchApp")
      if(resp) {
        setTimeout(() => {
          setBlip(resp.blip)
          setPermissions(resp.permissions)
          setLoaded(true)
        }, 100);
      } else {
            console.log("Something went wrong while loading this app, please report it to the server admin.")
            console.log("Something went wrong while loading this app, please report it to the server admin.")
            console.log("Something went wrong while loading this app, please report it to the server admin.")
            fetchNui("av_laptop", "sendNotification", {
              title: "APP ERROR",
              msg: "This app can't be loaded, verify F8 console for more info about this.",
              type: "error"
            })
      }
    }
    fetchData()
  }, [])
  
  return (
    <Box className="restaurants" h={isEnvBrowser() ? "100%" : "calc(100vh)"}>
      {loaded ?
        <Box className="container">
          <NavbarMinimal setCurrentTab={setCurrentTab} blip={blip} setBlip={setBlip}/>
          <Box p={"md"} className="content">
            <Suspense
                fallback={
                  <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
                    <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
                  </Box>
                }
            >
              {currentTab == "overview" && <Overview/>}
              {currentTab == "employees" && <Employees/>}
              {currentTab == "bank" && <Bank/>}
              {currentTab == "menu" && <Menu/>}
              {currentTab == "applications" && <Applications/>}
              {currentTab == "settings" && <Settings/>}
            </Suspense>
          </Box>
        </Box>
      :
        <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
          <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
        </Box>
      }
    </Box>
  )
}