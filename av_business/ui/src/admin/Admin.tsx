import { useEffect, useState} from 'react'
import {MantineProvider} from "@mantine/core"
import '@mantine/core/styles.css';
import { Lang } from '../reducers/atoms';
import { Panel } from "./components/Panel";
import { fetchNui } from '../hooks/useNuiEvents';
import { getLang } from "../hooks/getLang";
import { useSetRecoilState } from "recoil";

export const Admin = ({zones}:any) => {
  const [loaded, setLoaded] = useState(false)
  const setLang = useSetRecoilState(Lang)
  const [options, setOptions] = useState([])

  const onPressKey = (e:any) => {
    switch (e.code) {
      case "Escape":
        fetchNui('av_business','close')
        break;
      default:
        break;
    }
  }
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
  }, []);
  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang()
      setLang(resp)
      const data = zones.map((item:any) => ({
        label: item.label,
        job: item.name,
        links: [
          { label: resp.overview_icon, action: 'overview' },
          { label: resp.menu_icon, action: 'menu' },
          { label: resp.admin.zones, action: 'zones' }
        ]
      })).sort((a:any, b:any) => a.label.localeCompare(b.label));
      setOptions(data)
      setTimeout(() => {
        setLoaded(true)
      }, 100);
    }
    fetchLang()
  }, [])
  return (
    <MantineProvider defaultColorScheme='dark'>
      {loaded && <Panel options={options}/>}
    </MantineProvider>
    
  )
}