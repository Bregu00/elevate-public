import { useState, useEffect } from 'react'
import { Box, Accordion, Group, Button, TextInput, Text, ActionIcon } from '@mantine/core'
import { Loading } from '../Loading'
import { fetchNui, useNuiEvent } from '../../hooks/useNuiEvents'
import { useRecoilValue } from 'recoil';
import { Lang, Profile } from "../../reducers/atoms";
import { UserProfile } from "../../types/types";
import { IconUsersGroup, IconBubble, IconUser, IconX } from '@tabler/icons-react';
import { Input } from "../Input/Input";
import classes from './GroupStyle.module.css'

const isMember = (identifier: string, group: GroupType): boolean => {
  for (const member of group.members) {
    if (member.identifier === identifier) {
      return true;
    }
  }
  return false;
};

const Groups = () => {
    const lang:any = useRecoilValue(Lang)
    const profile = useRecoilValue<UserProfile>(Profile)
    const [loaded, setLoaded] = useState(false)
    const [allGroups, setAllGroups] = useState<GroupType[]>([])
    const [currentGroups, setCurrentGroups] = useState<GroupType[]>([])
    const [inputOptions, setInputOptions] = useState<Options>({
        title: '',
        event: '',
        extraData: undefined,
        fields: []
    })
    const [showInput, setShowInput] = useState(false)

    useNuiEvent("updateGroups", (data:any) => {
        setAllGroups(data)
        setCurrentGroups(data)
    })
    const deleteGroup = async (group:GroupType) => {
        if(group.owner === profile.identifier) {
            const resp = await fetchNui("av_boosting", "deleteGroup", {identifier: group.identifier})
            if(resp) {
                setAllGroups(resp);
                setCurrentGroups(resp);
            }
        }
    }
    const leaveGroup = async (group:GroupType) => {
        const resp = await fetchNui("av_boosting", "leaveGroup", {group: group.identifier})
        if(resp) {
            setAllGroups(resp)
            setCurrentGroups(resp)
        }
    }
    const handleSearch = (input: string) => {
        const trimmedInput = input.trim().toLowerCase();
        if (trimmedInput.length === 0) {
            setCurrentGroups(allGroups);
            return;
        }
        const res = allGroups.filter((group: GroupType) => group.label.toLowerCase().includes(trimmedInput));
        setCurrentGroups(res);
    };
    const handleCreate = () => {
        setInputOptions({
            title: lang.groups.create_header,
            fields: [
                {name: "groupName", type: "text", label: lang.groups.group_name},
                {name: "password", type: "password", label: lang.groups.group_password}
            ],
            event: "createGroup",
            extraData: profile.name
        })
        setShowInput(true)
    }
    const handleJoin = (group:GroupType) => {
        setInputOptions({
            title: lang.groups.join_group,
            fields: [
                {name: "password", type: "password", label: lang.groups.group_password}
            ],
            event: "joinGroup",
            extraData: {group: group.identifier, name: profile.name}
        })
        setShowInput(true)
    }
    const callback = async (data:any, event:string, extraData:any) => {
        const resp = await fetchNui("av_boosting", event, {data, extraData})
        if(resp) {
            setAllGroups(resp)
            setCurrentGroups(resp)
        }
    }
    const removeMember = async(group:GroupType, identifier:String) => {
        const resp = await fetchNui("av_boosting", 'removeMember', {group, identifier})
        if(resp) {
            setAllGroups(resp)
            setCurrentGroups(resp)
        }
    }
    useEffect(() => {
      const fetchData = async () => {
        const resp = await fetchNui("av_boosting", "getGroups")
        if(resp) {
            setAllGroups(resp)
            setCurrentGroups(resp)
        };
        setTimeout(() => {
            setLoaded(true)
        }, 100);
      }
      fetchData()
    }, [])
    
  return <>
    {loaded ? 
      <>
        {showInput && <Input options={inputOptions} callback={callback} show={setShowInput}/>}
        <Group gap="sm" mt="sm" p="xs">
            <TextInput 
                placeholder={lang.groups.search}
                size='sm'
                w={"20%"}
                classNames={classes}
                onChange={(e)=>{handleSearch(e.target.value)}}
            />
            <Button size="sm" variant='light' color='cyan' onClick={handleCreate}>{lang.groups.create_button}</Button>
        </Group>
        <Box p="xs" className={classes.container}>
            {currentGroups[0] && 
                <Accordion classNames={classes}>
                    {currentGroups.map((group:GroupType, index:number) => (
                        <Accordion.Item key={group.identifier} value={group.identifier} mb={currentGroups.length > index + 1 ? `xs` : 0}>
                            <Accordion.Control>
                                <Group grow>
                                    <Text fz="sm" fw={500}>{group.label}</Text>
                                    <Group gap="xs">
                                        <IconBubble style={{width: "15px", height: "15px"}} stroke={1.5}/>
                                        <Text size='xs' fw={500}>{group.status}</Text>
                                    </Group>
                                    <Group gap="xs">
                                        <IconUsersGroup style={{width: "15px", height: "15px"}} stroke={1.5}/>
                                        <Text size='xs' fw={500}>{`${group.members.length}/${group.maxMembers}`}</Text>
                                    </Group>
                                </Group>
                            </Accordion.Control>
                            <Accordion.Panel>
                                <Group p="xs">
                                    <Group gap="md">
                                        {group.members.map((member:Member, index:number) => (
                                            <Box display="flex">
                                                <IconUser style={{width: "15px", height: "15px"}}/>
                                                <Text fz="xs" ml={3}>{isMember(profile.identifier, group) ? member.name : `Anon ${index+1}`}</Text>
                                                {
                                                    profile.identifier == group.owner && profile.identifier !== member.identifier ? 
                                                    <ActionIcon size="xs" variant='transparent' color='red.5' onClick={()=>{removeMember(group, member.identifier)}}>
                                                        <IconX style={{height: "10px", width: "10px"}} stroke={1.5}/>
                                                    </ActionIcon>
                                                    :
                                                    null
                                                }
                                            </Box>
                                        ))}
                                    </Group>
                                    <Group ml="auto">
                                        {isMember(profile.identifier, group) ? 
                                            <>
                                                <Button size='xs' color='yellow.3' variant='light' onClick={()=>{leaveGroup(group)}}>{lang.groups.leave_button}</Button>
                                                {group.owner == profile.identifier && <Button size='xs' color='red' variant='subtle' onClick={()=>{deleteGroup(group)}}>{lang.groups.delete_button}</Button>}
                                            </>
                                            
                                        :
                                            <Button size='xs' color='cyan' variant='light' onClick={()=>{handleJoin(group)}}>{lang.groups.join_group}</Button>
                                        }
                                    </Group>
                                </Group>
                            </Accordion.Panel>
                        </Accordion.Item>

                    ))}
                </Accordion>
            }
        </Box>
      </>
    :
      <Loading/>
    }
  </>
}

export default Groups