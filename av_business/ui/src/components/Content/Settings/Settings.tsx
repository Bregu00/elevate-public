import { useState, useEffect } from 'react';
import { Box, Grid, Paper, Text, TextInput, rem, Button, LoadingOverlay } from '@mantine/core'
import { IconBrandDiscord } from '@tabler/icons-react';
import { fetchNui } from '../../../hooks/useNuiEvents';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';

const Settings = () => {
  const [loaded, setLoaded] = useState(false)
  const [Logs, setLogs] = useState<any>([])
  const daLang:any = useRecoilValue(Lang);
  const { settings: lang } = daLang
  useEffect(() => {
    const fetchData = async() => {
      const resp = await fetchNui("av_business", "getLogs")
      if(resp) {
        setLogs(resp)
        setTimeout(() => {
          setLoaded(true)
        }, 100);
      }
    }
    fetchData()
  }, [])
  const handleUpdate = (index: number, webhook: string) => {
    const newLogs = Logs.map((log:any, i:number) => {
      if (i === index) {
        return { ...log, webhook: webhook };
      }
      return log;
    });
    setLogs(newLogs)
  };
  const handleSave = (index:number) => {
    fetchNui("av_business", "saveLogs", Logs[index])
  }
  const icon = <IconBrandDiscord style={{ width: rem(16), height: rem(16) }} />;
  return <>
    {
      loaded ?
        <Box style={{overflow: "hidden", overflowX: "hidden"}} h={"calc(100%)"}>
          <Text c="gray.5" fz="sm">{lang.header}</Text>
          <Grid h={"calc(75%)"} style={{overflow: "auto", overflowX: "hidden"}} mt="xs">
            {Logs.map((log:any, index:number) => (
              <Grid.Col key={log.value} span={{base: 4, sm: 6, lg: 3}}>
                <Paper
                  p={"sm"}
                  bg={"rgba(39, 43, 54, 0.3)"}
                  style={{
                      border: "solid 1px rgba(200,200,200,0.15)",
                      borderRadius: "6px",
                      overflow: "hidden",
                  }}
                  mah={220}
                >
                  <Text>{log.label}</Text>
                  <Box h={60} style={{overflow: "auto", overflowX: "hidden"}}>
                    <Text fz={"xs"} c="dimmed">{log.description}</Text>
                  </Box>
                  <TextInput
                    leftSectionPointerEvents="none"
                    leftSection={icon}
                    label={<Text fz="xs">{lang.webhook}</Text>}
                    placeholder={lang.placeholder}
                    value={log.webhook ? log.webhook : null}
                    onChange={(e)=>{handleUpdate(index, e.target.value)}}
                    size='xs'
                    styles={{
                      input: {
                        backgroundColor: "rgba(40, 40, 40, 0.25)"
                      }
                    }}
                  />
                  <Button display="block" ml={"auto"} mr={"auto"} mt="xs" size='xs' variant='filled' w={'100%'} ta="center" color='cyan' onClick={()=>{handleSave(index)}}>
                    Save
                  </Button>
                </Paper>
              </Grid.Col>
            ))}
          </Grid>
        </Box>
      :
        <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
          <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
        </Box>
    }
  </>
}

export default Settings