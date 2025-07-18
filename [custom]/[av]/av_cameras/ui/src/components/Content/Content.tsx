import { useEffect, useState } from "react";
import {
  Box,
  Card,
  Grid,
  Image,
  Text,
  Button,
  Group,
  Flex,
  ActionIcon,
  Menu,
  rem,
  TextInput,
} from "@mantine/core";
import {
  IconChevronRight,
  IconSettings,
  IconTrash,
  IconCirclesRelation,
} from "@tabler/icons-react";
import { CameraGroupType, CameraType } from "../../types/types";
import { fetchNui } from "../../hooks/useNuiEvents";
import { Timer } from "../../hooks/Timer";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  tab: CameraGroupType;
  handleShare: (identifier: string) => void;
}

export const Content = ({ tab, handleShare }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [allCameras, setAllCameras] = useState<CameraType[]>([]);
  const [filtered, setFiltered] = useState<CameraType[]>([]);

  const handleSearch = (input: string) => {
    if (input == "" || !input) {
      setFiltered(allCameras);
    } else {
      const result = allCameras.filter((camera) =>
        camera.label.toLowerCase().includes(input.toLowerCase())
      );
      setFiltered(result);
    }
  };
  const handleDelete = async (cam: CameraType) => {
    const resp = await fetchNui("av_cameras", "deleteCamera", cam);
    if (!resp) return;
    const updated = allCameras.filter(
      (camera) => camera.identifier !== cam.identifier
    );
    setAllCameras(updated);
    setFiltered(updated);
  };
  const watchCamera = (cam: CameraType) => {
    fetchNui("av_cameras", "watch", cam);
  };
  const handleConnect = (cam: CameraType) => {
    fetchNui("av_cameras", "connect", cam);
    const updatedCameras = allCameras.map((camera) =>
      camera.identifier === cam.identifier
        ? { ...camera, connected: !camera.connected }
        : camera
    );
    setAllCameras(updatedCameras);
    setFiltered(updatedCameras);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "getCameras", tab);
      if (resp) {
        setAllCameras(resp);
        setFiltered(resp);
      }
    };
    fetchData();
  }, [tab]);

  return (
    <Box className={classes.content}>
      <Box className={classes.divider} />
      <Box ml="sm" w="100%">
        <Group className={classes.header} justify="space-between">
          <Text
            className={classes.text}
          >{`${filtered.length} ${lang.cameras}`}</Text>
          <TextInput
            classNames={classes}
            placeholder={lang.search}
            ml="auto"
            mr="0"
            size="xs"
            onChange={(e) => {
              handleSearch(e.target.value);
            }}
          />
        </Group>
        <Grid className={classes.cameras} mt="sm">
          {filtered.map((camera: CameraType) => (
            <Grid.Col span={3} miw={280} key={camera.identifier}>
              <Menu shadow="md" position="right-end">
                <Card withBorder radius="xs" className={classes.card}>
                  <Card.Section>
                    <Image src={camera.thumbnail} height={135} />
                  </Card.Section>
                  <Group mb="xl" mt="xs" w="100%">
                    <Flex direction="column" gap={0} maw="80%">
                      <Text className={classes.name} fw={500} truncate>
                        {camera.label}
                      </Text>
                      <Text className={classes.location} fw={500}>
                        {camera.location}
                      </Text>
                    </Flex>
                    <Menu.Target>
                      <ActionIcon
                        ml="auto"
                        variant="transparent"
                        c="gray.4"
                        size="xs"
                      >
                        <IconChevronRight />
                      </ActionIcon>
                    </Menu.Target>
                    <Menu.Dropdown>
                      <Menu.Label fz="xs">{lang.cameraOptions}</Menu.Label>
                      <Menu.Item
                        fz="xs"
                        color={camera.connected ? `teal` : `gray.4`}
                        leftSection={
                          <IconCirclesRelation
                            style={{ width: rem(12), height: rem(12) }}
                          />
                        }
                        onClick={() => {
                          handleConnect(camera);
                        }}
                      >
                        {camera.connected ? `Connected` : `Connect To`}
                      </Menu.Item>
                      {!camera.isShared && (
                        <>
                          {!camera.isJob && (
                            <Menu.Item
                              fz="xs"
                              leftSection={
                                <IconSettings
                                  style={{ width: rem(12), height: rem(12) }}
                                />
                              }
                              onClick={() => {
                                handleShare(camera.identifier);
                              }}
                            >
                              {lang.shareCamera}
                            </Menu.Item>
                          )}
                          <Menu.Item
                            fz="xs"
                            color="red"
                            leftSection={
                              <IconTrash
                                style={{ width: rem(12), height: rem(12) }}
                              />
                            }
                            onClick={() => {
                              handleDelete(camera);
                            }}
                          >
                            {lang.deleteCamera}
                          </Menu.Item>
                        </>
                      )}
                    </Menu.Dropdown>
                  </Group>
                  <Timer deadline={camera.battery} expired={lang.expired} />
                  <Button
                    className={classes.button}
                    mt={4}
                    radius={0}
                    color="violet.9"
                    onClick={() => {
                      watchCamera(camera);
                    }}
                  >
                    {lang.watchCamera}
                  </Button>
                </Card>
              </Menu>
            </Grid.Col>
          ))}
        </Grid>
      </Box>
    </Box>
  );
};
