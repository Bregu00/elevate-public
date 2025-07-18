import { Box, Group, Image, Flex, Text } from "@mantine/core";
import { ContentTable } from "./ContentTable/ContentTable";
import { useRecoilValue } from "recoil";
import { Lang, MusicList } from "../../../reducers/atoms";
import { useViewportHeight } from "../../../hooks/windowResize";
import classes from "./style.module.css";

const MainList = () => {
  const lang: any = useRecoilValue(Lang);
  const musicList = useRecoilValue(MusicList);
  const height = useViewportHeight();
  return (
    <Box className={classes.container} p="xl" pt={4}>
      <Group className={classes.header}>
        <Image
          className={classes.image}
          fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png"
          src={musicList.cover}
          h={135}
          w={135}
          radius={3}
        />
        <Flex
          direction="column"
          style={{
            justifyContent: "flex-end",
            height: "100%",
            width: "80%",
          }}
          maw={height > 70 ? "45vw" : "30vw"}
        >
          <Text fz="sm" c="gray.5">
            {lang.playlist}
          </Text>
          <Text
            c="white"
            fz="2.55rem"
            tt="capitalize"
            truncate
            fw={500}
            style={{
              maxWidth: "80%",
              textOverflow: "ellipsis",
              overflow: "hidden",
            }}
          >
            {musicList.name}
          </Text>
          <Text
            fz="md"
            c="gray.5"
          >{`${musicList.description} - ${musicList.songs.length} ${lang.songs}`}</Text>
        </Flex>
      </Group>
      <ContentTable />
    </Box>
  );
};

export default MainList;
