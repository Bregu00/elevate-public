import { useEffect, useState } from "react";
import {
  Box,
  Grid,
  Group,
  Flex,
  Image,
  Text,
  TextInput,
  Button,
  rem,
} from "@mantine/core";
import { PlayersTable } from "./PlayersTable/PlayersTable";
import { Footer } from "./Footer/Footer";
import { IconUserFilled, IconPhotoFilled } from "@tabler/icons-react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { Loading } from "../Loading";
import { ProfileProperties } from "../../types/types";

const Crew = () => {
  const lang: any = useRecoilValue(Lang);
  const [profile, setProfile] = useRecoilState(Profile);
  const { crew }: any = useRecoilValue(Profile);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [currentPage, setCurrentPage] = useState(1);
  const [total, setTotal] = useState(0);
  const [members, setMembers] = useState<any>([]);
  const handleInvite = async () => {
    const resp = await fetchNui("av_racing", "inviteCrew", crew);
    if (resp) {
      setMembers(resp);
    }
  };
  const handleEdit = (identifier: string, value: number) => {
    const updatedMembers = members.map((member: ProfileProperties) =>
      member.identifier === identifier ? { ...member, isBoss: value } : member
    );
    setMembers(updatedMembers);
    fetchNui("av_racing", "changeBoss", { identifier, value });
  };
  const handleFire = (identifier: string) => {
    const updatedMembers = members.filter(
      (member: ProfileProperties) => member.identifier !== identifier
    );
    setMembers(updatedMembers);
    fetchNui("av_racing", "fireMember", identifier);
  };
  const handleCrewPhoto = (url: string) => {
    if (profile.crew && typeof profile.crew !== "boolean") {
      const updatedProfile = {
        ...profile,
        crew: {
          ...profile.crew,
          photo: url,
        },
      };
      setProfile(updatedProfile);
    }
  };
  const handleSave = () => {
    fetchNui("av_racing", "updateCrew", crew);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getCrew", crew.name);
      if (resp) {
        setMembers(resp);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Box p="md">
      <Grid grow>
        <Grid.Col span={"auto"}>
          <Box className={classes.crewBox}>
            <Group grow gap={"auto"}>
              <Image
                src={crew.photo}
                mah={130}
                maw={130}
                fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png"
              />
              <Flex direction="column" w={140}>
                <Text className={classes.crewName} truncate>
                  {crew.label}
                </Text>
                <Box className={classes.racers}>
                  <IconUserFilled
                    style={{
                      width: rem(18),
                      height: rem(18),
                    }}
                  />
                  <Text ml={2} fz="xs">
                    {`${members.length} ${lang.members}`}
                  </Text>
                </Box>
              </Flex>
            </Group>
            <TextInput
              mt="sm"
              size="sm"
              classNames={classes}
              radius={0}
              placeholder={lang.photo}
              value={crew.photo}
              onChange={(e) => {
                handleCrewPhoto(e.target.value);
              }}
              leftSection={
                <IconPhotoFilled
                  style={{
                    color: "rgba(255,255,255,0.3)",
                    width: rem(18),
                    height: rem(18),
                  }}
                />
              }
              disabled={!crew.isBoss}
            />
            <Button
              mt="sm"
              fullWidth
              radius={0}
              className={classes.save}
              size="sm"
              color="rgba(205, 207, 102, 1)"
              c="black"
              style={{ zIndex: "99" }}
              disabled={!crew.isBoss}
              onClick={handleSave}
            >
              {lang.save}
            </Button>
          </Box>
        </Grid.Col>
        <Grid.Col span={7}>
          <PlayersTable
            handleInvite={handleInvite}
            handleEdit={handleEdit}
            handleFire={handleFire}
            members={members}
            currentPage={currentPage}
            setCurrentPage={setCurrentPage}
            setTotal={setTotal}
          />
        </Grid.Col>
      </Grid>

      <Footer
        page={currentPage}
        setCurrentPage={setCurrentPage}
        total={total}
      />
    </Box>
  );
};

export default Crew;
