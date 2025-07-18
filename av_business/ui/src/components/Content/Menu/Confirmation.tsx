import { Box, Text, Button, Group } from "@mantine/core"
import classes from './Confirmation.module.css'
import { useRecoilValue } from "recoil"
import { Lang } from "../../../reducers/atoms"
import { formatString } from "../../../hooks/formatString"

export const Confirmation = ({item, show, handleDelete}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { menu: lang } = daLang
  return (
    <Box className={classes.container}>
        <Box className={classes.box}>
            <Text fw={500} fz="md" ta="center">{lang.delete_header}</Text>
            <Text fw={200} fz="sm" ta="center" c="gray.6">{formatString(lang.delete_text, item.label)}</Text>
            <Group grow mt="md" w={"80%"} ml="auto" mr="auto" mb="xs">
                <Button size="xs" variant="light" color="teal" onClick={()=>{handleDelete(item.name)}}>{daLang.confirm}</Button>
                <Button size="xs" variant="light" color="red" onClick={()=>{show(false)}}>{daLang.cancel}</Button>
            </Group>
        </Box>
    </Box>
  )
}