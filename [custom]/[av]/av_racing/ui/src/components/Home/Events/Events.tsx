import { useEffect, useState } from "react";
import {
  Box,
  Accordion,
  Flex,
  Text,
  Badge,
  Tooltip,
  ActionIcon,
  Group,
} from "@mantine/core";
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../reducers/atoms";
import { GetTrackType } from "../../../hooks/getTrackType";
import { Timer } from "../../../hooks/Timer";
import { JoinedRace } from "../../../hooks/joinedRace";
import {
  IconUserPlus,
  IconEye,
  IconMapPinShare,
  IconUserX,
  IconClockPlay,
  IconTrash,
  IconMessage,
  IconGhost,
} from "@tabler/icons-react";
import { AllEvents, ProfileProperties } from "../../../types/types";
import classes from "./style.module.css";

export const Events = ({ setShowModal, setModalOptions }: any) => {
  const lang: any = useRecoilValue(Lang);
  const profile: ProfileProperties = useRecoilValue(Profile);
  const [allEvents, setAllEvents] = useState<AllEvents[]>([]);
  const [tracksCategories, setTracksCategories] = useState([]);

  useNuiEvent("updateEvents", (data: any) => {
    setAllEvents(data);
  });
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getEvents");
      if (resp) {
        setAllEvents(resp.events);
        setTracksCategories(resp.categories);
      }
    };
    fetchData();
  }, []);
  const handleJoin = (event: any) => {
    if (event.password) {
      setModalOptions({
        title: lang.join_event,
        options: [
          {
            name: "password",
            icon: "fa-solid fa-key",
            title: lang.event_password,
            type: "password",
          },
        ],
        button: lang.confirm_button,
        extraData: {
          event: "joinRace",
          eventInfo: event,
          settings: profile.settings,
          crew: profile.crew,
        },
        callback: handleCallback,
      });
      setShowModal(true);
    } else {
      fetchNui("av_racing", "joinRace", {
        eventInfo: event,
        settings: profile.settings,
        crew: profile.crew,
      });
    }
  };
  const handlePreview = (event: any) => {
    if (event.password) {
      setModalOptions({
        options: [
          {
            name: "password",
            icon: "fa-solid fa-key",
            title: lang.event_password,
            type: "password",
          },
        ],
        button: lang.confirm_button,
        extraData: {
          event: "previewEvent",
          eventInfo: event,
          settings: profile.settings,
        },
        callback: handleCallback,
      });
      setShowModal(true);
    } else {
      fetchNui("av_racing", "previewEvent", {
        eventInfo: event,
        settings: profile.settings,
      });
    }
  };
  const handleRoute = (track: any) => {
    if (track.password) {
      setModalOptions({
        options: [
          {
            name: "password",
            icon: "fa-solid fa-key",
            title: lang.event_password,
            type: "password",
          },
        ],
        button: lang.confirm_button,
        extraData: { event: "setRoute", track },
        callback: handleCallback,
      });
      setShowModal(true);
    } else {
      fetchNui("av_racing", "setRoute", track);
    }
  };
  const handleQuit = (data: any) => {
    fetchNui("av_racing", "quitRace", data);
  };
  const handleStart = (data: any) => {
    setModalOptions({
      title: lang.start_race,
      options: [
        {
          name: "info",
          description: lang.event_warning,
          type: "info",
          style: { maxWidth: "25vw", marginTop: "10px" },
        },
      ],
      button: lang.confirm_button,
      extraData: { event: "startRace", eventInfo: data },
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleDelete = async (id: any) => {
    const resp = await fetchNui("av_racing", "deleteRace", id);
    if (resp) setAllEvents(resp);
  };
  const handleAnnounce = (event: any) => {
    setModalOptions({
      title: lang.message,
      options: [
        {
          name: "message",
          type: "textarea",
        },
      ],
      button: lang.confirm_button,
      extraData: {
        event: "sendMessage",
        eventInfo: event.trackid,
      },
      callback: handleCallback,
    });
    setShowModal(true);
  };
  const handleCallback = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    if (data.extraData.event == "startRace") {
      const resp = await fetchNui("av_racing", "startRace", {
        event: data.extraData.eventInfo,
      });
      if (resp) setAllEvents(resp);
    } else {
      fetchNui("av_racing", data.extraData.event, data);
    }
  };
  return (
    <>
      <Box className={classes.events}>
        <Text className={classes.eventsText}>{lang.upcoming_events}</Text>
      </Box>
      {Object.keys(allEvents).length > 0 ? (
        <>
          <Accordion
            classNames={classes}
            mt={10}
            chevronPosition="left"
            w={"100%"}
            variant="default"
          >
            {Object.entries(allEvents).map(([index, event]: any) => (
              <>
                {GetTrackType(event.type, tracksCategories) ? (
                  <>
                    <Accordion.Item
                      value={event.identifier + index}
                      key={index}
                      id={event.identifier + index}
                      classNames={classes}
                    >
                      <Accordion.Control>
                        <Flex
                          justify="flex-start"
                          align="center"
                          direction="row"
                          wrap="wrap"
                          style={{
                            display: "inline-flex",
                            width: "100%",
                            justifyContent: "space-between",
                          }}
                        >
                          <Group gap="sm">
                            <Flex direction="column">
                              <Text fw={300} fz="xl" c="rgba(237, 237, 237, 1)">
                                {event.title}
                              </Text>
                              <Timer deadline={event.seconds} />
                            </Flex>
                          </Group>
                          <Group gap={5} ml="auto">
                            <Badge
                              size="lg"
                              lts={1.25}
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${lang.class}: ${event.class}`}</Badge>
                            <Badge
                              lts={1.25}
                              size="lg"
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${lang.event_buyin}: ${event.buyin} ${event.accountLabel}`}</Badge>
                            <Badge
                              lts={1.25}
                              size="lg"
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${lang.laps}: ${event.laps}`}</Badge>
                            <Badge
                              lts={1.25}
                              size="lg"
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${lang.event_racers}: ${event.numRacers}`}</Badge>
                            <Badge
                              lts={1.25}
                              size="lg"
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${lang.phasing}: ${
                              event.phasing
                                ? `${event.phasing}`
                                : lang.phasing_off
                            }`}</Badge>
                            <Badge
                              lts={1.25}
                              size="lg"
                              classNames={{
                                root: classes.badge,
                              }}
                            >{`${event.type}`}</Badge>
                          </Group>
                        </Flex>
                      </Accordion.Control>
                      <Accordion.Panel>
                        <Box
                          w={"100%"}
                          style={{
                            display: "inline-flex",
                            justifyContent: "space-between",
                          }}
                          mt={5}
                        >
                          <Box>{event.description}</Box>
                          <Box
                            style={{
                              display: "inline-flex",
                              alignContent: "center",
                              alignItems: "center",
                            }}
                          >
                            {!JoinedRace(event.racers, profile.identifier) ? (
                              <>
                                {!event.started && (
                                  <>
                                    <Tooltip
                                      label={lang.join_event}
                                      color="dark.4"
                                      fz="xs"
                                    >
                                      <ActionIcon
                                        size="sm"
                                        p={2}
                                        mr={5}
                                        variant="filled"
                                        color="rgba(56, 56, 56, 1)"
                                        c="gray"
                                        style={{ borderRadius: "0px" }}
                                        onClick={() => {
                                          handleJoin(event);
                                        }}
                                      >
                                        <IconUserPlus
                                          style={{ width: 14, height: 14 }}
                                        />
                                      </ActionIcon>
                                    </Tooltip>
                                    <Tooltip
                                      label={lang.preview}
                                      color="dark.4"
                                      fz="xs"
                                    >
                                      <ActionIcon
                                        style={{ borderRadius: "0px" }}
                                        size="sm"
                                        p={2}
                                        mr={5}
                                        variant="filled"
                                        color="rgba(56, 56, 56, 1)"
                                        c="gray"
                                        onClick={() => {
                                          handlePreview(event);
                                        }}
                                      >
                                        <IconEye
                                          style={{ width: 14, height: 14 }}
                                        />
                                      </ActionIcon>
                                    </Tooltip>
                                    <Tooltip
                                      label={lang.set_route}
                                      color="dark.4"
                                      fz="xs"
                                    >
                                      <ActionIcon
                                        style={{ borderRadius: "0px" }}
                                        size="sm"
                                        p={2}
                                        variant="filled"
                                        color="rgba(56, 56, 56, 1)"
                                        c="gray"
                                        mr={5}
                                        onClick={() => {
                                          handleRoute(event);
                                        }}
                                      >
                                        <IconMapPinShare
                                          style={{ width: 14, height: 14 }}
                                        />
                                      </ActionIcon>
                                    </Tooltip>
                                  </>
                                )}
                              </>
                            ) : (
                              <>
                                <Tooltip
                                  label={lang.quit_event}
                                  color="dark.4"
                                  fz="xs"
                                >
                                  <ActionIcon
                                    style={{ borderRadius: "0px" }}
                                    size="sm"
                                    p={2}
                                    variant="filled"
                                    color="rgba(56, 56, 56, 1)"
                                    c="gray"
                                    mr={5}
                                    onClick={() => {
                                      handleQuit(event);
                                    }}
                                  >
                                    <IconUserX
                                      style={{ width: 14, height: 14 }}
                                    />
                                  </ActionIcon>
                                </Tooltip>
                              </>
                            )}
                            {profile.identifier == event.host ||
                            profile.isAdmin ? (
                              <>
                                <Tooltip
                                  label={lang.announce}
                                  color="dark.4"
                                  fz="xs"
                                >
                                  <ActionIcon
                                    style={{ borderRadius: "0px" }}
                                    size="sm"
                                    p={2}
                                    variant="filled"
                                    color="rgba(56, 56, 56, 1)"
                                    c="gray"
                                    mr={5}
                                    onClick={() => {
                                      handleAnnounce(event);
                                    }}
                                  >
                                    <IconMessage
                                      style={{ width: 14, height: 14 }}
                                    />
                                  </ActionIcon>
                                </Tooltip>
                                {!event.started && (
                                  <Tooltip
                                    label={lang.start_race}
                                    color="dark.4"
                                    fz="xs"
                                  >
                                    <ActionIcon
                                      style={{ borderRadius: "0px" }}
                                      size="sm"
                                      p={2}
                                      variant="filled"
                                      color="rgba(56, 56, 56, 1)"
                                      c="gray"
                                      mr={5}
                                      onClick={() => {
                                        handleStart(event);
                                      }}
                                    >
                                      <IconClockPlay
                                        style={{ width: 14, height: 14 }}
                                      />
                                    </ActionIcon>
                                  </Tooltip>
                                )}
                                <Tooltip
                                  label={lang.delete}
                                  color="dark.4"
                                  fz="xs"
                                >
                                  <ActionIcon
                                    style={{ borderRadius: "0px" }}
                                    size="sm"
                                    p={2}
                                    variant="filled"
                                    color="rgba(56, 56, 56, 1)"
                                    c="gray"
                                    mr={5}
                                    onDoubleClick={() => {
                                      handleDelete(event.trackid);
                                    }}
                                  >
                                    <IconTrash
                                      style={{ width: 14, height: 14 }}
                                    />
                                  </ActionIcon>
                                </Tooltip>
                              </>
                            ) : null}
                          </Box>
                        </Box>
                      </Accordion.Panel>
                    </Accordion.Item>
                  </>
                ) : null}
              </>
            ))}
          </Accordion>
        </>
      ) : (
        <Box
          className={classes.events}
          mt="sm"
          h={90}
          style={{
            display: "flex",
            alignContent: "center",
            alignItems: "center",
          }}
        >
          <Text className={classes.eventsText} fz="sm" c="dimmed">
            {lang.no_events}
          </Text>
        </Box>
      )}
    </>
  );
};
