import { Box, Group, Button, Tooltip, ActionIcon } from "@mantine/core"
import { useRecoilState, useRecoilValue } from "recoil"
import { Lang, Profile } from "../../reducers/atoms";
import ProgressBarWithLabels from "./ProgressBarWithLabels";
import { IconCurrencySolana, IconDeviceLaptop, IconAlarm, IconSteeringWheel, IconHourglassOff, IconHourglassEmpty, IconUserCircle } from '@tabler/icons-react';
import { FormatTime } from '../../hooks/formatTime'
import { fetchNui } from "../../hooks/useNuiEvents";
import './header.css'

interface Properties {
  open: (arg:boolean) => void;
  isOpen: boolean;
}

export const Header = ({open, isOpen}:Properties) => {
  const lang:any = useRecoilValue(Lang)
  const [profile, setProfile] = useRecoilState(Profile)
  const toggleQueue = () => {
    fetchNui("av_boosting", "queue", {queue:!profile.queue})
    const updated = {...profile, queue: !profile.queue}
    setProfile(updated)
  }
  const iconStyle = {width: "16px", height: "16px"}
  return (
    <Box className="header" p={"sm"}>
      <Group w={"100%"} justify="space-between">
        <Group gap="xs" justify="space-between" grow fz="xs" c="rgba(200,200,200,0.85)">
          <Tooltip label={lang.crypto} color="dark.4" withinPortal fz="sm">
            <Group className="stats" gap={4}>
              <IconCurrencySolana style={iconStyle} stroke={1.5}/>
              {profile.crypto ? (profile.crypto).toLocaleString("en-US") : `0`}
            </Group>
          </Tooltip>
          <Tooltip label={lang.header.deliveries} color="dark.4" withinPortal fz="sm">
            <Group className="stats" gap={4}>
              <IconSteeringWheel style={iconStyle} stroke={1.5}/>
              {profile.deliveries ? profile.deliveries : `0`}
            </Group>
          </Tooltip>
          <Tooltip label={lang.header.hacked} color="dark.4" withinPortal fz="sm">
            <Group className="stats" gap={4}>
              <IconDeviceLaptop style={iconStyle} stroke={1.5}/>
              {profile.hacks ? profile.hacks : `0`}
            </Group>
          </Tooltip>
          <Tooltip label={lang.header.best_time} color="dark.4" withinPortal fz="sm">
            <Group className="stats" gap={4}>
              <IconAlarm style={iconStyle} stroke={1.5}/>
              {FormatTime(profile.time)}
            </Group>
          </Tooltip>
        </Group>
        <ProgressBarWithLabels/>
        <Group gap="xs">
          {
            profile.queue ?
              <Tooltip label={lang.header.exit_queue} color="dark.4" withinPortal fz="sm">
                <ActionIcon variant="light" color="teal" onClick={toggleQueue} radius={20}>
                  <IconHourglassEmpty style={iconStyle} stroke={1.5}/>
                </ActionIcon>
              </Tooltip>
            :
              <Tooltip label={lang.header.join_queue} color="dark.4" withinPortal fz="sm" >
                <ActionIcon variant="light" color="red" onClick={toggleQueue} radius={20}>
                  <IconHourglassOff style={iconStyle} stroke={1.5}/>
                </ActionIcon>
              </Tooltip>
          }
          <Tooltip label={lang.header.profile} color="dark.4" withinPortal fz="sm">
            <ActionIcon variant="light" color="cyan" radius={20} onClick={()=>{open(!isOpen)}}>
              <IconUserCircle style={iconStyle} stroke={1.5}/>
            </ActionIcon>
          </Tooltip>
        </Group>
      </Group>
    </Box>
  )
}
