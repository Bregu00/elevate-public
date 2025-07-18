import { Box, Group, Flex, TextInput, Image, Button } from "@mantine/core"
import { useRecoilState, useRecoilValue } from "recoil";
import { UserProfile } from "../../types/types";
import { Lang, Profile } from "../../reducers/atoms";
import { useClickOutside } from '@mantine/hooks';
import classes from './SettingsStyle.module.css'
import { fetchNui } from "../../hooks/useNuiEvents";

interface Properties {
  show: (arg:boolean) => void
}

const Settings = ({show}:Properties) => {
  const lang:any = useRecoilValue(Lang)
  const ref = useClickOutside(() => show(false));
  const [profile, setProfile] = useRecoilState<UserProfile>(Profile)
  const handleUpdate = (value:string, field:string) => {
    const updated = {...profile, [field]: value}
    setProfile(updated)
  }
  const saveProfile = () => {
    show(false)
    fetchNui("av_boosting", "saveProfile", {name: profile.name, photo: profile.photo})
  }
  return <>
    <Box className={classes.container}>
      <Box className={classes.box} ref={ref}>
        <Group justify='center' display={"flex"} p="xs" mt="sm" mb="xs" ta='center'>
          <Image src={profile.photo} h={120} w={120} radius={60} style={{border: "solid 2px rgba(255,255,255,0.7)"}} fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png"/>
          <Flex
            justify="flex-start"
            align="flex-start"
            direction="column"
            wrap="wrap"
          >
            <TextInput size="xs" label={lang.username} value={profile.name} classNames={classes} onChange={(e)=>{handleUpdate(e.target.value, "name")}}/>
            <TextInput size="xs" label={lang.photo} placeholder={lang.photo_url} classNames={classes} mt={4} onChange={(e)=>{handleUpdate(e.target.value, "photo")}}/>
            <Button 
              display="block" 
              w="100%" 
              ml="auto" 
              mr="auto" 
              ta="center" 
              mt="md" 
              size='xs' 
              variant='light' 
              color='cyan'
              onClick={saveProfile}
            >
              {lang.confirm}
            </Button>
          </Flex>
        </Group>
      </Box>
    </Box>
  </>
}

export default Settings