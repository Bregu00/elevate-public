import { useState } from "react";
import { Box, Text, Button, NumberInput, Group } from "@mantine/core"
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import classes from './Confirmation.module.css'


interface Properties {
    identifier: string,
    type: string,
    show: (arg:boolean) => void;
    handleFire: (arg:string) => void;
}

export const Confirmation = ({identifier, type, show, handleFire}:Properties) => {
  const daLang:any = useRecoilValue(Lang);
  const { employees: lang } = daLang
  const [amount, setAmount] = useState(0)
  const sendBonus = () => {
    fetchNui("av_business", "sendBonus", {identifier, amount})
    show(false)
  }
  const fireEmployee = async () => {
    show(false)
    const resp = await fetchNui("av_business", "fireEmployee", identifier)
    if (resp) handleFire(identifier);
  }
  return (
    <Box className={classes.container}>
        {type == "money" ?
            <Box className={classes.moneyBox}>
                <Text fw={500} fz="md" ta="center">{lang.bonus}</Text>
                <NumberInput
                    label={daLang.amount}
                    w={"80%"}
                    mr={"auto"}
                    ml={"auto"}
                    size="xs"
                    mt="xs"
                    styles={{
                        input: {
                            backgroundColor: "transparent"
                        }
                    }}
                    onChange={(e)=>{setAmount(Number(e))}}
                />
                <Group grow mt="md" w={"80%"} ml="auto" mr="auto" mb="xs">
                    <Button size="xs" variant="light" color="teal" onClick={()=>{sendBonus()}}>{daLang.confirm}</Button>
                    <Button size="xs" variant="light" color="red" onClick={()=>{show(false)}}>{daLang.cancel}</Button>
                </Group>
            </Box>
        :
            <Box className={classes.moneyBox}>
                <Text fw={500} fz="md" ta="center">{lang.fireEmployee}</Text>
                <Text fw={200} fz="sm" ta="center" c="gray.6">{lang.fireText}</Text>
                <Group grow mt="md" w={"80%"} ml="auto" mr="auto" mb="xs">
                    <Button size="xs" variant="light" color="teal" onClick={()=>{fireEmployee()}}>{daLang.confirm}</Button>
                    <Button size="xs" variant="light" color="red" onClick={()=>{show(false)}}>{daLang.cancel}</Button>
                </Group>
            </Box>
        }
    </Box>
  )
}