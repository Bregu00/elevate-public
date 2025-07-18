import { useEffect, useState } from "react"
import { Box, LoadingOverlay } from "@mantine/core"
import { Header } from "./Header"
import { Logs } from "./Logs"
import { Confirmation } from "./Confirmation"
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents"


const sortArrayByDate = (arr: any) => {
  return arr.sort((a:any, b:any) => b.date - a.date);
};

const Bank = () => {
  const [confirm, setConfirm] = useState(false)
  const [title, setTitle] = useState('')
  const [text, setText] = useState('')
  const [value, setValue] = useState(0)
  const [event, setEvent] = useState('')
  const [myLogs, setMyLogs] = useState([])
  const [funds, setFunds] = useState(0)
  const [generated, setGenerated] = useState(0)
  const [goal, setGoal] = useState(0)
  const [loaded, setLoaded] = useState(false)
  useNuiEvent("setGoal", (data:any) => {
    setGoal(data)
  })
  useNuiEvent("setFunds", (data:any) => {
    setFunds(data)
  })
  useNuiEvent("setLogs", (data:any) => {
    const sorted = sortArrayByDate(data)
    setMyLogs(sorted)
  })
  useEffect(() => {
    const fetchData = async() => {
      const resp = await fetchNui("av_business", "bank")
      const sorted = sortArrayByDate(resp.logs)
      setMyLogs(sorted)
      setFunds(resp.funds)
      setGenerated(resp.generated)
      setGoal(resp.goal)
      setTimeout(() => {
        setLoaded(true)
      }, 100);
    }
    fetchData()
  }, [])
  
  return (
    <>
      {
        loaded ? <>
          {
            confirm && <Confirmation title={title} text={text} value={value} event={event} show={setConfirm}/>
          }
          <Header title={setTitle} text={setText} value={setValue} event={setEvent} show={setConfirm} funds={funds} generated={generated} goal={goal}/>
          <Logs myLogs={myLogs}/>
        </>
        :
        <>
          <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
            <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
          </Box>
        </>
      }
    </>
  )
}
export default Bank