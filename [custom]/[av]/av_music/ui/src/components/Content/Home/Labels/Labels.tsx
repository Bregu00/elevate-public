import { useEffect, useState } from "react";
import { Text, Box } from "@mantine/core";
import { Carousel } from "@mantine/carousel";
import { useHover } from "@mantine/hooks";
import { CardProp } from "./CardProp";
import { useViewportHeight } from "../../../../hooks/windowResize";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import classes from "./style.module.css";

interface recordLabel {
  name: string;
  thumbnail: string;
  label: string;
  likes: number;
  songs: number;
}

export const Labels = () => {
  const lang: any = useRecoilValue(Lang);
  const [allLabels, setAllLabels] = useState<recordLabel[]>([]);
  const { hovered, ref } = useHover();
  const height = useViewportHeight();

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_music", "getLabels");
      if (resp) {
        setAllLabels(resp);
      }
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.container} p="sm">
      <Text fz="md" c="rgba(218,218,218,1)">
        {lang.labels_header}
      </Text>
      <Carousel
        mt="xs"
        ref={ref}
        slideSize={"auto"}
        slideGap={"lg"}
        align="start"
        slidesToScroll={2}
        controlSize={15}
        w={"calc(100% - 190px)"}
        styles={{
          controls: {
            transition: "opacity 100ms ease",
            opacity: hovered ? 1 : 0,
          },
          control: {
            backgroundColor: "#363636",
            color: "white",
            border: "solid 1px #303030",
          },
        }}
      >
        {allLabels.map((item) => (
          <Carousel.Slide key={item.label}>
            <CardProp
              recordLabel={item}
              height={height}
              songLang={lang.songs}
            />
          </Carousel.Slide>
        ))}
      </Carousel>
    </Box>
  );
};
