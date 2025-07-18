import { useEffect, useState } from "react";
import { Box, Flex, Text, LoadingOverlay } from "@mantine/core";
import { StatsGrid } from "./TopStats/TopStats";
import { MainStats } from "./MainStats/MainStats";
import { Footer } from "./Footer/Footer";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, RestData } from "../../../reducers/atoms";
import { fetchNui } from "../../../hooks/useNuiEvents";
import "./style.css";
import { useViewportHeight } from "../../../hooks/windowResize";

const Overview = () => {
  const lang: any = useRecoilValue(Lang);
  const [data, setData] = useRecoilState(RestData);
  const [loaded, setLoaded] = useState(false);
  const height = useViewportHeight();
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "overview");
      setData(resp);
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <>
      {loaded ? (
        <Box className="overview">
          <Box mb="xs" hidden={height < 700}>
            <Flex direction="column">
              <Text
                fw={500}
                fz="sm"
              >{`${lang.welcome}, ${data.employeeName}!`}</Text>
              <Text c="dimmed" fz="xs">
                {`${lang.business}: ${data.jobLabel}`}
              </Text>
            </Flex>
          </Box>
          <StatsGrid />
          <MainStats />
          <Footer />
        </Box>
      ) : (
        <Box
          style={{
            display: "flex",
            alignContent: "center",
            alignItems: "center",
            height: "100%",
          }}
        >
          <LoadingOverlay
            visible
            zIndex={1000}
            loaderProps={{ color: "teal", type: "dots" }}
            overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
          />
        </Box>
      )}
    </>
  );
};
export default Overview;
