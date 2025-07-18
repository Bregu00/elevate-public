import { useEffect, useState } from "react";
import { Accordion, Box, Title, Group, Text, Divider } from "@mantine/core";
import { AccordionResults } from "./AccordionResults";
import { GetTrackType } from "../../../hooks/getTrackType";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";
import { fetchNui } from "../../../hooks/useNuiEvents";

export const Results = () => {
  const lang: any = useRecoilValue(Lang);
  const [oldEvents, setOldEvents] = useState([]);
  const [tracksCategories, setTracksCategories] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getResults");
      setOldEvents(resp.events);
      setTracksCategories(resp.categories);
    };
    fetchData();
  }, []);

  return (
    <>
      <Box className={classes.events} mt="md">
        <Text className={classes.eventsText}>{lang.today_result}</Text>
      </Box>
      {oldEvents.length > 0 ? (
        <>
          <Accordion
            classNames={classes}
            chevronPosition="left"
            w={"100%"}
            variant="default"
            mt={10}
          >
            {oldEvents.map((event: any, index: any) => (
              <>
                {GetTrackType(event.type, tracksCategories) ? (
                  <AccordionResults event={event} key={index} />
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
            {lang.no_records}
          </Text>
        </Box>
      )}
    </>
  );
};
