import {
  Box,
  Select,
  TextInput,
  Button,
  Group,
  Text,
  Flex,
  rem,
} from "@mantine/core";
import { IconSearch, IconSteeringWheel } from "@tabler/icons-react";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

export const Header = ({
  options,
  count,
  handleSearch,
  handleFilter,
  handleNew,
  createTracks,
}: any) => {
  const lang: any = useRecoilValue(Lang);
  return (
    <Group className={classes.header}>
      <Group>
        <Box className={classes.flagBox}>
          <IconSteeringWheel style={{ width: "50%", height: "50%" }} />
        </Box>
        <Flex gap="0px" direction="column" mt={3}>
          <Text className={classes.title}>
            {lang.header_explore}{" "}
            {<a style={{ color: "rgba(205, 207, 102, 1)" }}>{count}</a>}{" "}
            {lang.header_tracks}
          </Text>
          <Text className={classes.subheader}>{lang.subheader}</Text>
        </Flex>
      </Group>
      <Group ml="auto" gap="xs">
        <TextInput
          classNames={classes}
          radius={0}
          placeholder={lang.search}
          leftSection={
            <IconSearch style={{ width: rem(12), height: rem(12) }} />
          }
          onChange={(e) => {
            handleSearch(e.target.value);
          }}
        />
        {createTracks && (
          <Button
            color="rgba(25, 25, 25, 1)"
            radius={0}
            classNames={classes}
            style={{ border: "1px solid rgba(255, 255, 255, 0.36)" }}
            onClick={handleNew}
          >
            {lang.create_track}
          </Button>
        )}

        <Select
          classNames={classes}
          ta="center"
          data={options}
          defaultValue={"all"}
          radius={0}
          w={120}
          allowDeselect={false}
          onChange={(e) => {
            handleFilter(e);
          }}
        />
      </Group>
    </Group>
  );
};
