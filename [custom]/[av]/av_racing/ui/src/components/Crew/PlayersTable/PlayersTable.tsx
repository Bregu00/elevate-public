import { useState, useEffect } from "react";
import cx from "clsx";
import {
  Table,
  TextInput,
  rem,
  Avatar,
  ScrollArea,
  Group,
  Button,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import {
  IconSearch,
  IconTrash,
  IconCrown,
  IconCrownOff,
} from "@tabler/icons-react";
import Th from "./Th";
import { sortData } from "./utils";
import { ProfileProperties } from "../../../types/types";
import { useViewportHeight } from "../../../hooks/windowResize";
import { useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../reducers/atoms";
import classes from "./style.module.css";

export const PlayersTable = ({
  members,
  currentPage,
  setCurrentPage,
  setTotal,
  handleInvite,
  handleEdit,
  handleFire,
}: any) => {
  const lang: any = useRecoilValue(Lang);
  const height = useViewportHeight();
  const { crew } = useRecoilValue(Profile);
  const [scrolled, setScrolled] = useState(false);
  const [search, setSearch] = useState("");
  const [sortedData, setSortedData] = useState(members);
  const [sortBy, setSortBy] = useState<keyof ProfileProperties | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [PAGE_SIZE, setPAGE_SIZE] = useState(9);

  const setSorting = (field: keyof ProfileProperties) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(sortData(members, { sortBy: field, reversed, search }));
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.currentTarget;
    setSearch(value);
    setSortedData(
      sortData(members, {
        sortBy,
        reversed: reverseSortDirection,
        search: value,
      })
    );
    setCurrentPage(1);
  };

  const currentData = sortedData.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE
  );

  const rows = currentData.map((row: ProfileProperties) => (
    <Table.Tr key={row.identifier} classNames={classes}>
      <Table.Td
        classNames={classes}
        style={{ borderLeft: "1px solid rgba(255, 255, 255, 0.12)" }}
      >
        {<Avatar size={32} src={row.photo} radius={0} />}
      </Table.Td>
      <Table.Td classNames={classes}>{row.name}</Table.Td>
      <Table.Td classNames={classes}>{row.races}</Table.Td>
      <Table.Td classNames={classes}>{row.wins}</Table.Td>
      <Table.Td
        classNames={classes}
        style={{ borderRight: "1px solid rgba(255, 255, 255, 0.12)" }}
      >
        <>
          {crew && crew.isBoss ? (
            <>
              <Group gap={4} justify="center">
                {!row.isBoss ? (
                  <Tooltip label={lang.set_boss} color="dark.5">
                    <ActionIcon
                      variant="transparent"
                      color="rgb(237,237,237)"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleEdit(row.identifier, 1);
                      }}
                    >
                      <IconCrown size={16} />
                    </ActionIcon>
                  </Tooltip>
                ) : (
                  <Tooltip label={lang.remove_boss} color="dark.5">
                    <ActionIcon
                      variant="transparent"
                      color="rgb(237,237,237)"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleEdit(row.identifier, 0);
                      }}
                    >
                      <IconCrownOff size={16} />
                    </ActionIcon>
                  </Tooltip>
                )}
                <Tooltip label={lang.remove_member} color="dark.5">
                  <ActionIcon
                    variant="transparent"
                    color="rgb(237,237,237)"
                    onClick={(e) => {
                      e.stopPropagation();
                      handleFire(row.identifier);
                    }}
                  >
                    <IconTrash size={16} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            </>
          ) : null}
        </>
      </Table.Td>
    </Table.Tr>
  ));
  useEffect(() => {
    setSortedData(members);
  }, [members]);

  useEffect(() => {
    let size = 1;
    if (height > 500) {
      size = 2;
      setPAGE_SIZE(size);
    }
    if (height > 750) {
      size = 6;
      setPAGE_SIZE(size);
    }
    if (height > 800) {
      size = 7;
      setPAGE_SIZE(size);
    }
    if (height > 900) {
      size = 9;
      setPAGE_SIZE(size);
    }
    setTotal(Math.ceil(sortedData.length / size));
  }, [sortedData.length]);

  return (
    <>
      <Group w="100%" grow mb="sm">
        <TextInput
          classNames={classes}
          placeholder={lang.search}
          maw="100%"
          mr={6}
          radius={0}
          leftSection={
            <IconSearch
              style={{ width: rem(16), height: rem(16) }}
              stroke={1.5}
            />
          }
          value={search}
          onChange={handleSearchChange}
        />
        <Button
          className={classes.Invite}
          maw="fit-content"
          color="#262626"
          c="rgba(237, 237, 237, 1)"
          onClick={handleInvite}
        >
          {lang.invite}
        </Button>
      </Group>
      <ScrollArea
        className={classes.positions}
        classNames={classes}
        onScrollPositionChange={({ y }) => setScrolled(y !== 0)}
      >
        <Table layout="fixed" classNames={classes}>
          <Table.Thead
            className={cx(classes.header, { [classes.scrolled]: scrolled })}
            bg="#262626"
          >
            <Table.Tr className={classes.tr}>
              <Table.Th
                w={70}
                style={{ borderLeft: "1px solid rgba(255, 255, 255, 0.12)" }}
              ></Table.Th>
              <Th
                type="name"
                sorted={sortBy === "name"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("name")}
              >
                {lang.username}
              </Th>
              <Th
                type="races"
                sorted={sortBy === "races"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("races")}
              >
                {lang.total_races}
              </Th>
              <Th
                type="wins"
                sorted={sortBy === "wins"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("wins")}
              >
                {lang.races_won}
              </Th>
              <Table.Th
                style={{ borderRight: "1px solid rgba(255, 255, 255, 0.12)" }}
              >
                {lang.actions}
              </Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody className={classes.body}>
            {rows.length > 0 ? rows : null}
          </Table.Tbody>
        </Table>
      </ScrollArea>
    </>
  );
};
