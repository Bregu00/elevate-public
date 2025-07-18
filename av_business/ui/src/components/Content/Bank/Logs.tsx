import { useState, useEffect } from "react"
import { Box, Paper, Text, Group, Flex, Select } from "@mantine/core"
import { useRecoilValue } from 'recoil'
import { Height, Lang } from '../../../reducers/atoms'
import { formatTimestamp } from "../../../hooks/formatTime";
import classes from './Logs.module.css'

const sortArrayByDate = (arr: any) => {
  return arr.sort((a:any, b:any) => b.date - a.date);
};

export const Logs = ({myLogs}:any) => {
  const [currentLogs, setCurrentLogs] = useState(myLogs)
  const height = useRecoilValue(Height)
  const daLang:any = useRecoilValue(Lang);
  const { bank: lang } = daLang

  const filterLogs = (type:any) => {
    if(!type){
        const sorted = sortArrayByDate(myLogs)
        setCurrentLogs(sorted)
        return
    }
    const res = myLogs.filter((data:any) => data.type === type)
    const sorted = sortArrayByDate(res)
    setCurrentLogs(sorted)
  }

  useEffect(() => {
    setCurrentLogs(myLogs)
  }, [myLogs])
  
  return (
    <Box h={height > 900 ? `calc(100%)` : `calc(85%)`}>
        <Group justify="space-between" mt="xs" align="center" display={"flex"} p={'xs'}>
            <Text fz={"sm"} fw={500}>{lang.latest}</Text>
            <Select
                placeholder={daLang.filter}
                data={[
                    {value: "deposit", label: lang.deposit},
                    {value: "withdraw", label: lang.withdraw},
                ]}
                classNames={{
                    option: classes.option
                }}
                styles={{
                    input: {
                        backgroundColor: "rgba(39, 43, 54, 0.15)"
                    },
                    dropdown: {
                        backgroundColor: "rgba(39, 43, 54, 0.9)"
                    }
                }}
                onChange={(e)=>{filterLogs(e)}}
            />
        </Group>
        {currentLogs && currentLogs[0] ?
            <Box className={classes.logContainer} mt={5} h={height > 900 ? `calc(80%)` : `calc(65%)`}>
                {currentLogs.slice(0,30).map((log:any) => (
                    <Paper 
                        key={log.date} 
                        p={"sm"} 
                        bg={"rgba(39, 43, 54, 0.3)"} 
                        style={{
                            border: "solid 1px rgba(200,200,200,0.15)", 
                            borderRadius: "6px",
                            overflow: "hidden",
                        }} 
                        mb={"sm"}
                    >
                        <Group justify="space-between" w={"100%"} grow>
                            <Flex justify="flex-start" align="flex-start" direction="column" mah={100}>
                                <Text fz="xs" c="dimmed">{lang.description}</Text>
                                <Text fz="xs" style={{overflow: "auto", wordWrap: "break-word", overflowWrap: 'break-word'}} maw={"100%"}>{log.description}</Text>
                            </Flex>
                            <Flex justify="flex-start" align="flex-start" direction="column" wrap="wrap">
                                <Text fz="xs" c="dimmed">{lang.employee}</Text>
                                <Text fz="xs">{log.employee}</Text>
                                
                            </Flex>
                            <Flex justify="flex-start" align="flex-start" direction="column" wrap="wrap">
                                <Text fz="xs" c="dimmed">{lang.date}</Text>
                                <Text fz="xs">{formatTimestamp(log.date)}</Text>
                            </Flex>
                            <Flex justify="flex-start" align="flex-start" direction="column" wrap="wrap">
                                <Text fz="xs" c="dimmed">{daLang.amount}</Text>
                                <Text fz="xs">{`$${(log.amount).toLocaleString("en-US")}`}</Text>
                            </Flex>
                            <Flex justify="flex-start" align="flex-start" direction="column" wrap="wrap">
                                <Text fz="xs" c="dimmed">{daLang.type}</Text>
                                <Text fz="xs" c={log.type == 'deposit' ? `teal` : `red`}>{log.type == 'deposit' ? lang.deposit : lang.withdraw}</Text>
                                
                            </Flex>
                        </Group>
                        
                    </Paper>
                ))}
            </Box>
            :
            <Paper p={"sm"} bg={"rgba(39, 43, 54, 0.3)"} style={{border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px"}}>
                <Text fz={"sm"}>{lang.empty}</Text>
            </Paper>
        }
    </Box>
  )
}