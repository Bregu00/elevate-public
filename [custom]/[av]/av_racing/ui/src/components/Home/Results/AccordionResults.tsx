import { Accordion, Group, Text, Box, Button, Flex } from "@mantine/core";
import { PositionTable } from "./PositionTable";
import { fetchNui } from "../../../hooks/useNuiEvents";
export const AccordionResults = ({ event }: any) => {
  const openUnderground = (event: any) => {
    fetchNui("av_racing", "underground", event);
  };
  return (
    <>
      <Accordion.Item value={event.trackid} id={event.trackid}>
        <Accordion.Control>
          <Group grow>
            <Flex direction="column">
              <Text c="white" fw={300} fz="xl" truncate>
                {event.eventName}
              </Text>
              <Text c="dimmed" fz={12} fw={200}>
                Event Name
              </Text>
            </Flex>
            <Flex direction="column">
              <Text c="white" fw={300} fz="xl" truncate>
                {event.trackName}
              </Text>
              <Text c="dimmed" fz={12} fw={200}>
                Track Name
              </Text>
            </Flex>
            <Flex direction="column">
              <Text c="white" fw={300} fz="xl" truncate>
                {event.racers}
              </Text>
              <Text c="dimmed" fz={12} fw={200}>
                Racers
              </Text>
            </Flex>
            <Flex direction="column">
              <Text c="white" fw={300} fz="xl" truncate>
                {event.class}
              </Text>
              <Text c="dimmed" fz={12} fw={200}>
                Class
              </Text>
            </Flex>
            <Flex direction="column">
              <Text c="white" fw={300} fz="xl" truncate>
                {event.laps}
              </Text>
              <Text c="dimmed" fz={12} fw={200}>
                Laps
              </Text>
            </Flex>
          </Group>
        </Accordion.Control>
        <Accordion.Panel>
          <PositionTable data={event.results} />
          <Box style={{ width: "100%", textAlign: "right" }} mt={5}>
            <Button
              size="xs"
              variant="filled"
              radius={0}
              color="rgba(83, 83, 83, 1)"
              fw={100}
              lts={1.25}
              onClick={() => {
                openUnderground(event);
              }}
            >
              The Underground
            </Button>
          </Box>
        </Accordion.Panel>
      </Accordion.Item>
    </>
  );
};
