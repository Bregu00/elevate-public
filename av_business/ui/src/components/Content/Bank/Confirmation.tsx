import { useState } from "react"
import { Box, Group, Button, NumberInput, Text } from "@mantine/core"
import { fetchNui } from "../../../hooks/useNuiEvents"
import classes from './Confirmation.module.css'
import { useRecoilValue } from "recoil"
import { Lang } from "../../../reducers/atoms"

export const Confirmation = ({title, text, value, event, show}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const [amount, setAmount] = useState<number | string>(0)
  const handleConfirm = () => {
    show(false)
    fetchNui("av_business", event, amount)
  }
  return (
    <Box className={classes.container}>
        <Box className={classes.box}>
            <Text fw={500} fz="md" ta="center">{title}</Text>
            <NumberInput 
                label={text}
                defaultValue={value ? value : 0}
                onChange={setAmount}
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
            />
            <Group grow mt="md" w={"80%"} ml="auto" mr="auto" mb="xs">
                <Button size="xs" variant="light" color="teal" onClick={()=>{handleConfirm()}}>{daLang.confirm}</Button>
                <Button size="xs" variant="light" color="red" onClick={()=>{show(false)}}>{daLang.cancel}</Button>
            </Group>
        </Box>
    </Box>
  )
}