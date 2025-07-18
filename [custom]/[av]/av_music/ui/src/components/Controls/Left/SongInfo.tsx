import { Group, Flex, Image, Text } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { CurrentSong } from "../../../reducers/atoms";

export const SongInfo = () => {
  const song = useRecoilValue(CurrentSong);
  return (
    <Group>
      <Image
        src={song.thumbnail}
        h={44}
        w={44}
        fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png"
      />
      <Flex gap={0} direction="column" maw="125px">
        <Text fz="xs" truncate fw={700} c="white">
          {song.name}
        </Text>
        <Text fz="xs" truncate fw={500} c="rgb(187,187,187)">
          {song.artist}
        </Text>
      </Flex>
    </Group>
  );
};
