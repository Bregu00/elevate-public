import { Box, Text, Button, Group } from "@mantine/core"
import classes from './Confirmation.module.css'
import { useRecoilValue } from "recoil";
import { Lang } from '../../../../reducers/atoms';

export const Confirmation = ({title, message, cb, data}:any) => {
  const daLang:any = useRecoilValue(Lang);
  return (
    <Box className={classes.container}>
        <Box className={classes.box}>
            <Text fw={500} fz="md" ta="center">{title}</Text>
            <Text fw={200} fz="sm" ta="center" c="gray.6">{message}</Text>
            <Group grow mt="md" w={"80%"} ml="auto" mr="auto" mb="xs">
                <Button size="xs" variant="light" color="teal" onClick={()=>{cb(true, data)}}>{daLang.confirm}</Button>
                <Button size="xs" variant="light" color="red" onClick={()=>{cb(false, data)}}>{daLang.cancel}</Button>
            </Group>
        </Box>
    </Box>
  )
}