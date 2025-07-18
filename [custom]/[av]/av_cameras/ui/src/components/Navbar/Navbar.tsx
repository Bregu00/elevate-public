import { useState } from "react";
import { Box, Group, Flex, Text, Menu, rem } from "@mantine/core";
import {
  IconLayersLinked,
  IconVideo,
  IconShare,
  IconSettings,
  IconTrash,
  IconEye,
} from "@tabler/icons-react";
import { AllGroupsType, CameraGroupType } from "../../types/types";
import { useViewportWidth } from "../../hooks/windowResize";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  tab: CameraGroupType;
  setTab: (option: CameraGroupType) => void;
  allGroups: AllGroupsType;
  handleDelete: (option: string) => void;
  handleShare: (option: string) => void;
  newGroup: () => void;
}

export const Navbar = ({
  tab,
  setTab,
  allGroups,
  handleDelete,
  handleShare,
  newGroup,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [opened, setOpened] = useState("");
  const [currentGroup, setCurrentGroup] = useState<string>("");
  const iconStyle = { width: "14px", height: "14px" };
  const width = useViewportWidth();
  return (
    <Box className={classes.navbar}>
      <Box display="block" className={classes.groupList}>
        {Object.values(allGroups).map((group: CameraGroupType) => (
          <Menu
            key={group.identifier}
            opened={opened == group.identifier}
            loop={false}
            position="right"
            withinPortal
            onChange={() => {
              setOpened("");
            }}
          >
            <Group
              mt={4}
              c={tab.identifier == group.identifier ? `violet.2` : `white`}
              onClick={() => {
                setTab(group);
              }}
              onContextMenu={(e) => {
                e.preventDefault();
                if (group.identifier == "shared") return;
                setCurrentGroup(group.identifier);
                setOpened(group.identifier);
              }}
              w="100%"
            >
              {width > 1580 && (
                <>
                  {group.identifier == "shared" ? (
                    <IconShare stroke={1.5} style={iconStyle} />
                  ) : (
                    <IconVideo stroke={1.5} style={iconStyle} />
                  )}
                </>
              )}
              <Menu.Target key={group.value}>
                <Text className={classes.groupName} truncate maw={150}>
                  {group.label}
                </Text>
              </Menu.Target>
              <Menu.Dropdown>
                <Menu.Label fz="xs">{lang.groupOptions}</Menu.Label>
                <Menu.Item
                  fz="xs"
                  leftSection={
                    <IconEye style={{ width: rem(12), height: rem(12) }} />
                  }
                  onClick={() => {
                    fetchNui("av_cameras", "watchGroup", currentGroup);
                  }}
                >
                  {lang.watchGroup}
                </Menu.Item>
                {!group.isJob && (
                  <>
                    <Menu.Item
                      fz="xs"
                      leftSection={
                        <IconSettings
                          style={{ width: rem(12), height: rem(12) }}
                        />
                      }
                      onClick={() => {
                        handleShare(currentGroup);
                      }}
                    >
                      {lang.sendGroup}
                    </Menu.Item>
                    <Menu.Item
                      fz="xs"
                      color="red"
                      leftSection={
                        <IconTrash
                          style={{ width: rem(12), height: rem(12) }}
                        />
                      }
                      onClick={() => {
                        if (currentGroup) {
                          handleDelete(currentGroup);
                        }
                      }}
                    >
                      {lang.deleteGroup}
                    </Menu.Item>
                  </>
                )}
              </Menu.Dropdown>
            </Group>
          </Menu>
        ))}
      </Box>
      <Group className={classes.footer} onClick={newGroup}>
        {width > 1000 && (
          <Box className={classes.iconBox}>
            <IconLayersLinked
              style={{ width: "16px", height: "16px" }}
              stroke={1.5}
            />
          </Box>
        )}
        <Flex direction="column">
          <Text className={classes.text} fw={500}>
            {lang.createNew}
          </Text>
          <Text className={classes.text} fz="xs" fw={300}>
            {lang.group}
          </Text>
        </Flex>
      </Group>
    </Box>
  );
};
