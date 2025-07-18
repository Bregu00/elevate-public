import {
  Box,
  Group,
  Grid,
  Button,
  Image,
  Text,
  TextInput,
  Flex,
  rem,
  ColorSwatch,
  Select,
  Textarea,
} from "@mantine/core";
import {
  IconUserEdit,
  IconPhotoEdit,
  IconMap,
  IconCalendarQuestion,
  IconCheck,
  IconBubble,
  IconCrown,
} from "@tabler/icons-react";
import classes from "./style.module.css";
import { useEffect, useState } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";

interface SettingsType {
  name: string;
  nationality: string;
  age: number | string;
  photo: string;
  lights: string;
  blip: string;
  animation: string;
  story: string;
}

const ColorsMap = ({ type, colors, selected, setChecked }: any) => {
  return (
    <Group grow mt="sm" gap="xs">
      {colors.map((color: any, index: number) => (
        <ColorSwatch
          mah={30}
          maw={30}
          radius={0}
          key={index}
          component="button"
          color={color.color}
          onClick={() => {
            setChecked(type, color.name);
          }}
          style={{ color: "#fff", cursor: "pointer" }}
        >
          {selected == color.name && (
            <IconCheck
              style={{ width: rem(18), color: "#343A40" }}
              stroke={2.45}
            />
          )}
        </ColorSwatch>
      ))}
    </Group>
  );
};

const Settings = () => {
  const lang: any = useRecoilValue(Lang);
  const [profile, setProfile] = useRecoilState(Profile);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [animations, setAnimations] = useState([]);
  const colorLights = [
    { name: "blue", color: "#339AF0" },
    { name: "green", color: "#51CF66" },
    { name: "orange", color: "#FF922B" },
    { name: "pink", color: "#F06595" },
    { name: "violet", color: "#845EF7" },
    { name: "red", color: "#FF6B6B" },
    { name: "gray", color: "#E9ECEF" },
    { name: "yellow", color: "#FCC419" },
  ];

  const handleEdit = (
    field: keyof SettingsType,
    value: number | string | null,
    type?: string | undefined | null
  ) => {
    if (type && type == "profile") {
      const copy = { ...profile, [field]: value };
      setProfile(copy);
    } else {
      const settings = { ...profile["settings"], [field]: value };
      const copy = { ...profile, ["settings"]: settings };
      setProfile(copy);
    }
  };
  const handleSave = () => {
    fetchNui("av_racing", "saveProfile", profile);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getAnimations");
      setAnimations(resp);
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) <Loading />;
  return (
    <Box className={classes.container}>
      <Grid w="65%" justify="center" mt="md" grow ml="auto" mr="auto" miw={700}>
        <Grid.Col span={5}>
          <Box
            bg="#252525"
            w="100%"
            p="lg"
            style={{
              border: "0.98px solid rgba(255, 255, 255, 0.26)",
              overflow: "auto",
            }}
            h="100%"
          >
            <Group grow justify="center" gap="sm">
              <Image
                bg="rgba(24, 24, 24, 1)"
                w={300}
                h={130}
                src={profile.photo}
                fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png"
              />
              <Box
                h={130}
                bg={
                  profile.settings.lights
                    ? `${profile.settings.lights}.3`
                    : `gray.3`
                }
                c="black"
                className={classes.colorBox}
                ta="center"
              >
                <Text className={classes.colorsText}>{lang.lights}</Text>
              </Box>
              <Box
                h={130}
                bg={
                  profile.settings.blip
                    ? `${profile.settings.blip}.3`
                    : `gray.3`
                }
                className={classes.colorBox}
                c="black"
                ta="center"
              >
                <Text className={classes.colorsText}>{lang.blips}</Text>
              </Box>
            </Group>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
            >
              <IconUserEdit
                style={{
                  width: rem(20),
                  height: rem(20),
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.username}</Text>
                <TextInput
                  classNames={classes}
                  w={"150%"}
                  size="xs"
                  variant="unstyled"
                  value={profile.name}
                  onChange={(e) => {
                    handleEdit("name", e.target.value, "profile");
                  }}
                />
              </Flex>
            </Group>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
              grow
            >
              <IconMap
                style={{
                  width: "fit-content",
                  maxWidth: "5%",
                  maxHeight: "5%",
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.country}</Text>
                <TextInput
                  classNames={classes}
                  w={"150%"}
                  size="xs"
                  variant="unstyled"
                  value={profile.settings.nationality}
                  onChange={(e) => {
                    handleEdit("nationality", e.target.value);
                  }}
                />
              </Flex>
            </Group>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
              grow
            >
              <IconCalendarQuestion
                style={{
                  width: "fit-content",
                  maxWidth: "5%",
                  maxHeight: "5%",
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.age}</Text>
                <TextInput
                  classNames={classes}
                  w={"150%"}
                  size="xs"
                  variant="unstyled"
                  value={profile.settings.age}
                  onChange={(e) => {
                    handleEdit("age", e.target.value);
                  }}
                />
              </Flex>
            </Group>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
              grow
            >
              <IconPhotoEdit
                style={{
                  width: "fit-content",
                  maxWidth: "5%",
                  maxHeight: "5%",
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.photo}</Text>
                <TextInput
                  classNames={classes}
                  w={"150%"}
                  size="xs"
                  variant="unstyled"
                  value={profile.photo}
                  onChange={(e) => {
                    handleEdit("photo", e.target.value, "profile");
                  }}
                />
              </Flex>
            </Group>
          </Box>
        </Grid.Col>
        <Grid.Col span={5}>
          <Box
            bg="#252525"
            w="100%"
            p="lg"
            style={{ border: "0.98px solid rgba(255, 255, 255, 0.26)" }}
            h="100%"
          >
            <Box
              bg="#363636"
              p="md"
              style={{ border: "0.98px solid rgba(255, 255, 255, 0.1)" }}
            >
              <Text className={classes.username} c="gray" fz="lg">
                {lang.lights}
              </Text>
              <ColorsMap
                type="lights"
                colors={colorLights}
                margin={5}
                setChecked={handleEdit}
                selected={profile.settings.lights}
              />
            </Box>
            <Box
              bg="#363636"
              p="md"
              mt="sm"
              style={{ border: "0.98px solid rgba(255, 255, 255, 0.1)" }}
            >
              <Text className={classes.username} c="gray" fz="lg">
                {lang.blips}
              </Text>
              <ColorsMap
                type="blip"
                colors={colorLights}
                margin={5}
                setChecked={handleEdit}
                selected={profile.settings.blip}
              />
            </Box>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
              grow
            >
              <IconCrown
                style={{
                  width: "fit-content",
                  maxWidth: "5%",
                  maxHeight: "5%",
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.animation}</Text>
                <Select
                  classNames={classes}
                  data={animations}
                  value={profile.settings.animation}
                  onChange={(e) => {
                    handleEdit("animation", e);
                  }}
                  w={"190%"}
                  size="xs"
                  variant="unstyled"
                />
              </Flex>
            </Group>
            <Group
              className={classes.inputField}
              bg="#363636"
              mt="md"
              gap="xs"
              p="xs"
              w="100%"
              grow
            >
              <IconBubble
                style={{
                  width: "fit-content",
                  maxWidth: "5%",
                  maxHeight: "5%",
                }}
              />
              <Flex direction="column">
                <Text className={classes.username}>{lang.about_me}</Text>
                <Textarea
                  classNames={classes}
                  w={"190%"}
                  size="xs"
                  variant="unstyled"
                  value={profile.settings.story}
                  onChange={(e) => {
                    handleEdit("story", e.target.value);
                  }}
                />
              </Flex>
            </Group>
          </Box>
        </Grid.Col>
      </Grid>
      <Box mt="md" w="65%" ml="auto" mr="auto">
        <Button
          className={classes.buttonText}
          fullWidth
          radius={0}
          color="rgba(205, 207, 102, 1)"
          c="black"
          size="md"
          onClick={handleSave}
        >
          {lang.save}
        </Button>
      </Box>
    </Box>
  );
};

export default Settings;
