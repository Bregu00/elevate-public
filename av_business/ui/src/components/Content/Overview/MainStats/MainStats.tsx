import { Stack, Grid, Group, Paper, Text, Image, Flex} from "@mantine/core"
import { AreaChart, ChartTooltip } from '@mantine/charts';
import { useViewportWidth } from "../../../../hooks/windowResize";
import { useRecoilValue } from "recoil";
import { Height, Permissions, RestData, Lang } from "../../../../reducers/atoms";
import { formatString } from "../../../../hooks/formatString";

export const MainStats = () => {
    const permissions:any = useRecoilValue(Permissions)
    const restData:any = useRecoilValue(RestData)
    const width = useViewportWidth()
    const height = useRecoilValue(Height)
    const data = restData?.chart ? restData.chart : []
    const { overview: lang }:any = useRecoilValue(Lang);
    const test = (value:any, payload:any) => {
        const res = payload.find((item:any) => item.value === value)
        if(res && res.name == "generated") {
            return `$${value}`
        }
        return value
    }
  return (
    <Grid 
        w={"100%"} 
        justify='center' 
        mt={5} 
    > 
        <Grid.Col span={width > 1290 ? 9 : 12} w={"100%"}>
            <Paper p="sm" bg={"rgba(39, 43, 54, 0.3)"} style={{border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px"}}>
                <Text fz={"md"} fw={500} c="gray.4">{lang.todayOverview}</Text>
                <AreaChart
                    h={"calc(28vh)"}
                    data={data}
                    dataKey="time"
                    series={[
                        { name: 'generated', color: 'indigo.4', label: "Generated" },
                        { name: 'sells', color: 'cyan.4', label: "Sells" },
                        
                    ]}
                    curveType="linear"
                    mt={"sm"}
                    tooltipProps={{
                    content: ({ label, payload}:any) => {
                        return (
                        <ChartTooltip
                            label={label as React.ReactNode}
                            payload={payload}
                            valueFormatter={value => test(value,payload)}
                        />
                        )
                    },
                    }}
                />
            </Paper>
        </Grid.Col>
        {width > 1290 &&
            <Grid.Col span={3} w={"100%"}>
                <Stack gap={"xs"}>
                    {permissions.isRestaurant &&
                        <>
                            <Paper p="sm" bg={"rgba(39, 43, 54, 0.3)"} style={{border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px"}}>
                                <Text fz={"sm"} fw={500} c="gray.4">{lang.topDish.title}</Text>
                                <Group mt={"xs"} gap={"xs"} w={"100%"}>
                                    <Image w={45} h={45} radius={25} src={`https://cfx-nui-${restData.inventory}${restData.todayDish.name}.png`} fallbackSrc="https://clarionhealthcare.com/wp-content/uploads/2020/12/default-fallback-image.png"/>
                                    <Flex
                                        gap={0}
                                        justify="flex-start"
                                        align="flex-start"
                                        direction="column"
                                        wrap="nowrap"
                                    >
                                        <Text fz={"sm"} c="gray.5">{restData.todayDish.label}</Text>
                                        <Text fz={"xs"} c="dimmed">{formatString(lang.topDish.description, restData.todayDish.amount)}</Text>
                                    </Flex>
                                </Group>
                            </Paper>
                        </>
                    }
                    {
                        height > 850 &&
                        <Paper p="sm" bg={"rgba(39, 43, 54, 0.3)"} style={{border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px"}}>
                            <Text fz={"sm"} fw={500} c="gray.4">{lang.topEmployee.title}</Text>
                            <Group mt={"xs"} gap={"xs"} w={"100%"}>
                                <Image w={45} h={45} src={restData.todayEmployee.image} radius={25} fallbackSrc="https://clarionhealthcare.com/wp-content/uploads/2020/12/default-fallback-image.png"/>
                                <Flex
                                    gap={0}
                                    justify="flex-start"
                                    align="flex-start"
                                    direction="column"
                                    wrap="nowrap"
                                >
                                    <Text fz={"sm"} c="gray.5">{restData.todayEmployee.name}</Text>
                                    <Text fz={"xs"} c="dimmed">{formatString(lang.topEmployee.description, restData.todayEmployee.hours)}</Text>
                                </Flex>
                            </Group>
                        </Paper>
                    }
                </Stack>
            </Grid.Col>
        }
    </Grid>
  )
}