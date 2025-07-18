import { Group, Box, Button, Paper, SimpleGrid, Text, Tooltip } from '@mantine/core';
import classes from './StatsGrid.module.css';
import { useEffect, useState } from "react";
import { fetchNui } from "../../../../hooks/useNuiEvents";

interface Properties {
  job: string;
}

export const Overview = ({job}:Properties) => {
  const [stats, setStats] = useState([])
  const handleReset = async() => {
    const resp = await fetchNui('av_business', 'resetBusiness', job)
    if(resp) {
      const data = resp.map((stat:any, index:number) => {
        return (
          <Paper withBorder p="md" radius="md" key={index}>
            <Group justify="space-between">
              <Text size="xs" c="dimmed" className={classes.title}>
                {stat.label}
              </Text>
            </Group>
            <Group align="flex-end" gap="xs" mt={25}>
              <Text className={classes.value}>{stat.value}</Text>
            </Group>
          </Paper>
        );
      });
      setStats(data)
    }
  }
  useEffect(() => {
    const fetchData = async() => {
      const resp = await fetchNui("av_business", "admin", {job, type: "overview"})
      if(resp) {
        const data = resp.map((stat:any, index:number) => {
          return (
            <Paper withBorder p="md" radius="md" key={index}>
              <Group justify="space-between">
                <Text size="xs" c="dimmed" className={classes.title}>
                  {stat.label}
                </Text>
              </Group>
              <Group align="flex-end" gap="xs" mt={25}>
                <Text className={classes.value}>{stat.value}</Text>
              </Group>
            </Paper>
          );
        });
        setStats(data)
      }
    }
    fetchData()
  }, [])
  
  return (
    <div className={classes.root}>
      <SimpleGrid cols={{ base: 1, xs: 2, md: 4 }}>{stats}</SimpleGrid>
      <Box className={classes.button}>
        <Tooltip label="Double click to confirm">
        <Button color='red' variant='light' onDoubleClick={()=>{
handleReset()
        }}>Reset Stats</Button>
        </Tooltip>
      </Box>
    </div>
  )
}