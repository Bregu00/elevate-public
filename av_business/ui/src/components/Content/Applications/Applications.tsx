import { useEffect, useState } from 'react'
import { Box, Group, Text, Button, Paper, ActionIcon, LoadingOverlay } from '@mantine/core'
import { IconUser, IconPhone, IconMail } from '@tabler/icons-react';
import { fetchNui } from '../../../hooks/useNuiEvents'
import { useRecoilValue } from 'recoil';
import { Height, Lang } from "../../../reducers/atoms";
import { formatTimestamp } from "../../../hooks/formatTime";
import classes from './Applications.module.css'

const Applications = () => {
  const height = useRecoilValue(Height)
  const daLang:any = useRecoilValue(Lang);
  const { appplications: lang } = daLang
  const [status, setStatus] = useState(true)
  const [list, setList] = useState<any>([])
  const [loaded, setLoaded] = useState(false)
  const handleButton = () => {
    setStatus(!status)
    fetchNui("av_business", "toggleApplications", status)
  }
  const handleCopy = (text:string) => {
    fetchNui("av_laptop", "copy", text)
  }
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui('av_business', 'getApplications')
      const sorted = resp.applications.sort((a:any, b:any) => b.date - a.date)
      setList(sorted)
      setStatus(resp.status)
      setTimeout(() => {
        setLoaded(true)
      }, 100);
    }
    fetchData()
  }, [])
  
  return <>
    {!loaded ?
        <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
          <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
        </Box>
      :
        <Box h={height > 900 ? `calc(100%)` : `calc(95%)`}>
        <Group justify="space-between" align="center" display={"flex"}>
          <Text fz={"md"} fw={500}>{`${list.length} ${lang.header}`}</Text>
          <Button size="xs" variant="light" color={status ? 'teal.4' : 'red.4'} onClick={handleButton}>{status ? lang.open : lang.closed}</Button>
        </Group>
        <Box mt="md" h={height > 900 ? `calc(90%)` : `calc(80%)`} style={{overflow: "auto"}}>
          {list.map((data:any, index:number) => (
            <Paper
                key={index} 
                p={"sm"} 
                className={classes.card}
                mb={"xs"}
                mah={155}
            >
              <Group gap={5}>
                <IconUser stroke={1.5} size={14}/>
                <Text fz="sm" c="gray.5">{data?.name}</Text>
              </Group>
              <Box mt={"xs"} className={classes.description}>
                <Text fz={"sm"}>{data?.description}</Text>
              </Box>
              <Group justify='space-between' mt={"xs"}>
                <Box display="flex">
                  <Group gap={5}>
                    <IconPhone stroke={1.5} size={14}/>
                    <Text fz="sm" onClick={()=>{handleCopy(data?.phone)}} className={classes.copy}>{data?.phone}</Text>
                  </Group>
                  <Group gap={5} ml="md">
                    <IconMail stroke={1.5} size={14}/>
                    <Text fz="sm" onClick={()=>{handleCopy(data?.email)}} className={classes.copy}>{data?.email}</Text>
                  </Group>
                </Box>
                <Text c="dimmed" fz="sm">{formatTimestamp(data.date)}</Text>
              </Group>
            </Paper>
          ))}
        </Box>
      </Box>
    }
  </>
}

export default Applications