import { useState } from "react"
import { Box } from "@mantine/core"
import classes from "./Panel.module.css"
import { NavbarNested } from "./Navbar/Navbar"
import { Overview } from "./Content/Overview/Overview"
import { Menu } from "./Content/Menu/Menu"
import { Zones } from "./Content/Zones/Zones"

export const Panel = ({options}:any) => {
  const [job, setJob] = useState("")
  const [getter, setGetter] = useState("")
  const [loaded, setLoaded] = useState(false)
  const action = (job:string, action:string) => {
    setLoaded(false)
    setJob(job)
    setGetter(action)
    setTimeout(() => {
      setLoaded(true)
    }, 55);
  }
  return (
    <Box className={classes.container}>
        <Box className={classes.panel}>
            <NavbarNested action={action} options={options}/>
            {loaded && 
              <>
                {getter == "overview" && <Overview job={job}/>}
                {getter == "menu" && <Menu job={job}/>}
                {getter == "zones" && <Zones job={job}/>}
              </>
            }
        </Box>
    </Box>
  )
}