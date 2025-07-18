import { useEffect, useState } from "react";
import {
  Box,
  Group,
  Button,
  TextInput,
  Table,
  Checkbox,
  ScrollArea,
  Flex,
  Image,
  Text,
  rem,
} from "@mantine/core";
import cx from "clsx";
import { QueryResults } from "../../types/types";
import { FormatTime } from "../../hooks/formatTime";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  allSongs: QueryResults[];
  info: {
    name: string;
    label: string;
    thumbnail: string;
    description: string;
  };
  permissions: {
    canBurn: boolean;
    canDelete: boolean;
    canAdd: boolean;
  };
  handleAdd: () => void;
  handleDelete: (songs: QueryResults[]) => void;
  handleBurn: (selection: QueryResults[]) => void;
}

export const Panel = ({
  allSongs,
  info,
  permissions,
  handleAdd,
  handleDelete,
  handleBurn,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [filtered, setFiltered] = useState<QueryResults[]>(allSongs);
  const [selection, setSelection] = useState<QueryResults[]>([]);
  const [scrolled, setScrolled] = useState(false);

  const handleSearch = (value: string) => {
    if (value == "") {
      setFiltered(allSongs);
      return;
    }
    const res = allSongs.filter((song) =>
      song.name.toLowerCase().includes(value.toLowerCase())
    );
    setFiltered(res);
  };

  const toggleRow = (song: QueryResults) =>
    setSelection((current) =>
      current.includes(song)
        ? current.filter((item) => item !== song)
        : [...current, song]
    );

  const toggleAll = () =>
    setSelection((current) =>
      current.length === filtered.length ? [] : [...filtered]
    );

  const rows = filtered.map((item) => {
    const selected = selection.includes(item);
    return (
      <Table.Tr
        key={item.videoId}
        className={cx({ [classes.rowSelected]: selected })}
      >
        <Table.Td>
          <Checkbox
            radius={0}
            size="xs"
            checked={selected}
            onChange={() => toggleRow(item)}
          />
        </Table.Td>
        <Table.Td>
          <Group gap="sm">
            <Image
              w={40}
              src={item.thumbnails[1]?.url || item.thumbnails[0].url}
            />
            <Flex direction="column" gap={1} w={"80%"}>
              <Text fz="sm" truncate>
                {item?.name ? item.name : "N/A"}
              </Text>
              <Text c="gray.5" fz="xs" truncate>
                {item?.artist?.name ? item?.artist?.name : "N/A"}
              </Text>
            </Flex>
          </Group>
        </Table.Td>
        <Table.Td>{item?.album?.name ? item.album.name : "N/A"}</Table.Td>
        <Table.Td>
          <Text c="gray.5" fz="xs" truncate>
            {FormatTime(item.duration)}
          </Text>
        </Table.Td>
      </Table.Tr>
    );
  });

  useEffect(() => {
    setFiltered(allSongs);
  }, [allSongs]);

  return (
    <>
      <Box className={classes.options}>
        <Group justify="space-between" w="100%">
          <Group gap="sm">
            <Image src={info.thumbnail} h={55} w={55} />
            <Flex direction="column">
              <Text fz="md" c="gray.3" fw={500}>
                {info.label}
              </Text>
              <Text fz="sm" c="gray.6">
                {info.description}
              </Text>
            </Flex>
          </Group>
          <Group ml="auto" gap="xs">
            <TextInput
              placeholder={lang.search}
              radius={0}
              size="xs"
              onChange={(e) => {
                handleSearch(e.target.value);
              }}
            />
            {permissions.canAdd && (
              <Button size="xs" radius={0} color="teal" onClick={handleAdd}>
                {lang.add_song}
              </Button>
            )}
            {permissions.canBurn && (
              <Button
                size="xs"
                disabled={selection.length == 0}
                radius={0}
                onClick={() => {
                  handleBurn(selection);
                }}
              >
                {lang.burn_cd}
              </Button>
            )}
            {permissions.canDelete && (
              <Button
                size="xs"
                disabled={selection.length == 0}
                radius={0}
                onClick={() => {
                  handleDelete(selection);
                  setSelection([]);
                }}
                color="red"
              >
                {lang.delete_selected}
              </Button>
            )}
          </Group>
        </Group>
      </Box>
      <ScrollArea
        mt="sm"
        onScrollPositionChange={({ y }) => setScrolled(y !== 0)}
        className={classes.scrollbar}
        type="always"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
      >
        <Table layout="auto" verticalSpacing="xs">
          <Table.Thead
            className={cx(classes.header, { [classes.scrolled]: scrolled })}
          >
            <Table.Tr>
              <Table.Th style={{ width: rem(10) }}>
                <Checkbox
                  radius={0}
                  size="xs"
                  onChange={toggleAll}
                  checked={selection.length === filtered.length}
                  indeterminate={
                    selection.length > 0 && selection.length !== filtered.length
                  }
                />
              </Table.Th>
              <Table.Th fw={500} fz="sm">
                {lang.song}
              </Table.Th>
              <Table.Th fw={500} fz="sm">
                {lang.album}
              </Table.Th>
              <Table.Th fw={500} fz="sm">
                {lang.duration}
              </Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>{rows}</Table.Tbody>
        </Table>
      </ScrollArea>
    </>
  );
};
