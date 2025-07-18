import { Group, Text, Image, Flex, Switch, rem } from "@mantine/core";
import { IconBellFilled } from "@tabler/icons-react";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../reducers/atoms";
import { fetchNui } from "../../hooks/useNuiEvents";
import classes from "./style.module.css";

export const Header = () => {
  const lang: any = useRecoilValue(Lang);
  const [profile, setProfile] = useRecoilState(Profile);

  const handleAlerts = (state: boolean) => {
    fetchNui("av_racing", "notifications", state);
    setProfile({ ...profile, alerts: state });
  };
  return (
    <Group p="xl" className={classes.header}>
      <Group>
        <Image
          className={classes.avatarBox}
          src={profile.photo}
          fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png"
        />
        <Flex
          justify="flex-start"
          align="flex-start"
          direction="column"
          wrap="wrap"
        >
          <Text className={classes.title}>{profile.name}</Text>
          {profile.crew && (
            <Text className={classes.crew} c="rgba(92, 92, 92, 1)">
              {profile.crew.label}
            </Text>
          )}
        </Flex>
      </Group>
      {!profile.isCop && (
        <Group ml="auto">
          <Switch
            classNames={classes}
            radius={0}
            checked={profile.alerts}
            onChange={(event) => handleAlerts(event.currentTarget.checked)}
            color="teal"
            size={"xl"}
            onLabel={lang.alerts_on}
            offLabel={lang.alerts_off}
            styles={{
              thumb: {
                left: profile.alerts ? `unset` : 0,
                right: profile.alerts ? 0 : `unset`,
              },
            }}
            thumbIcon={
              profile.alerts ? (
                <IconBellFilled
                  style={{ width: rem(18), height: rem(18) }}
                  color={"white"}
                  stroke={3}
                />
              ) : (
                <IconBellFilled
                  style={{ width: rem(18), height: rem(18) }}
                  color={"white"}
                  stroke={3}
                />
              )
            }
          />
        </Group>
      )}
    </Group>
  );
};
