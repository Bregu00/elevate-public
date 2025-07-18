import {
  Box,
  Card,
  Group,
  Flex,
  Text,
  Tooltip,
  Badge,
  ActionIcon,
} from "@mantine/core";
import {
  IconMapSearch,
  IconCalendarEvent,
  IconAward,
  IconTrash,
} from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const TrackCard = ({
  track,
  serial,
  deleteTrack,
  handlePreview,
  createEvent,
  createRace,
  handleDelete,
  handleLeaderboard,
}: any) => {
  const lang: any = useRecoilValue(Lang);
  return (
    <Card padding="10px" radius="sm" className={classes.trackCard}>
      <Card.Section p="xs">
        <Group justify="space-between">
          <Text fw={500} truncate w={150} className={classes.trackName}>
            {track.name}
          </Text>
          <Badge
            variant="light"
            color={track.color ? `${track.color}` : "blue"}
            className={classes.badge}
          >
            {track.type ? <>{track.type}</> : <>{lang.default_type}</>}
          </Badge>
        </Group>
      </Card.Section>
      <Card.Section
        maw={"100%"}
        mah={54}
        style={{
          overflow: "auto",
          marginLeft: "1px",
        }}
      >
        <Text className={classes.description}>{track.description}</Text>
      </Card.Section>
      <Card.Section
        style={{
          display: "inline-flex",
          position: "absolute",
          bottom: "0",
          padding: "10px",
          justifyContent: "space-between",
          width: "100%",
          marginBottom: "-5px",
        }}
      >
        <Group w="100%">
          <Box style={{ display: "flex", margin: "auto", marginLeft: "0" }}>
            <Group gap={2}>
              <Flex direction="column">
                <Text className={classes.distance}>{lang.distance}</Text>
                <Text
                  className={classes.distanceData}
                >{`${track.distance} ${lang.distance_unit}`}</Text>
              </Flex>
            </Group>
          </Box>
          <Box ml="auto">
            <Flex
              gap="5px"
              justify="flex-start"
              align="center"
              direction="row"
              wrap="wrap"
            >
              <Tooltip label={lang.preview} color="dark.4" fz="xs" withArrow>
                <ActionIcon
                  size="sm"
                  p={2}
                  variant="filled"
                  color="rgba(56, 56, 56, 1)"
                  c="gray"
                  style={{ borderRadius: "0px" }}
                  onClick={() => {
                    handlePreview(track.checkpoints);
                  }}
                >
                  <IconMapSearch style={{ width: 14, height: 14 }} />
                </ActionIcon>
              </Tooltip>
              {createRace && (
                <Tooltip
                  label={lang.create_event}
                  color="dark.4"
                  fz="xs"
                  withArrow
                >
                  <ActionIcon
                    size="sm"
                    p={2}
                    variant="filled"
                    color="rgba(56, 56, 56, 1)"
                    c="gray"
                    style={{ borderRadius: "0px" }}
                    onClick={() => {
                      createEvent(track);
                    }}
                  >
                    <IconCalendarEvent style={{ width: 14, height: 14 }} />
                  </ActionIcon>
                </Tooltip>
              )}
              <Tooltip
                label={lang.leaderboard_tab}
                color="dark.4"
                fz="xs"
                withArrow
              >
                <ActionIcon
                  size="sm"
                  p={2}
                  variant="filled"
                  color="rgba(56, 56, 56, 1)"
                  c="gray"
                  style={{ borderRadius: "0px" }}
                  onClick={() => {
                    handleLeaderboard(track);
                  }}
                >
                  <IconAward style={{ width: 14, height: 14 }} />
                </ActionIcon>
              </Tooltip>

              {serial == track.createdby || deleteTrack ? (
                <>
                  <Tooltip
                    label={lang.delete_track}
                    color="dark.4"
                    fz="xs"
                    withArrow
                  >
                    <ActionIcon
                      size="sm"
                      p={2}
                      variant="filled"
                      color="rgba(56, 56, 56, 1)"
                      c="gray"
                      style={{ borderRadius: "0px" }}
                      onDoubleClick={() => {
                        handleDelete(track.identifier);
                      }}
                    >
                      <IconTrash style={{ width: 14, height: 14 }} />
                    </ActionIcon>
                  </Tooltip>
                </>
              ) : null}
            </Flex>
          </Box>
        </Group>
      </Card.Section>
    </Card>
  );
};
