import { useState, useEffect } from "react";
import cx from "clsx";
import { Table, TextInput, rem, Avatar, ScrollArea } from "@mantine/core";
import { IconSearch } from "@tabler/icons-react";
import Th from "./Th";
import { sortData } from "./utils";
import classes from "./style.module.css";
import { useViewportHeight } from "../../../hooks/windowResize";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface ProfileProperties {
  identifier: string;
  name: string;
  photo: string;
  crew: string;
  crewLabel: string;
  isBoss: boolean;
  joined: string;
  races: number;
  wins: number;
  settings?: any;
}

export const PlayersTable = ({
  currentPage,
  setCurrentPage,
  setTotal,
  loaded,
  setLoaded,
}: any) => {
  const lang: any = useRecoilValue(Lang);
  const height = useViewportHeight();
  const [scrolled, setScrolled] = useState(false);
  const [search, setSearch] = useState("");
  const [allRecords, setAllRecords] = useState<ProfileProperties[] | []>([]);
  const [sortedData, setSortedData] = useState<ProfileProperties[] | []>([]);
  const [sortBy, setSortBy] = useState<keyof ProfileProperties | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [PAGE_SIZE, setPAGE_SIZE] = useState(8);
  const setSorting = (field: keyof ProfileProperties) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(sortData(allRecords, { sortBy: field, reversed, search }));
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.currentTarget;
    setSearch(value);
    setSortedData(
      sortData(allRecords, {
        sortBy,
        reversed: reverseSortDirection,
        search: value,
      })
    );
    setCurrentPage(1); // Reset to first page on search
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
        {
          <Avatar
            size={32}
            src={
              row.photo.length > 1
                ? row.photo
                : `https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png`
            }
            radius={0}
          />
        }
      </Table.Td>
      <Table.Td classNames={classes}>{row.name}</Table.Td>
      <Table.Td classNames={classes}>{row.races}</Table.Td>
      <Table.Td classNames={classes}>{row.wins}</Table.Td>
      <Table.Td
        classNames={classes}
        style={{ borderRight: "1px solid rgba(255, 255, 255, 0.12)" }}
      >
        {row.crewLabel}
      </Table.Td>
    </Table.Tr>
  ));

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

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getPlayersLeaderboard");
      if (resp) {
        setAllRecords(resp);
        setSortedData(resp);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      <TextInput
        classNames={classes}
        placeholder={lang.search}
        mb={6}
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
      <ScrollArea
        classNames={classes}
        onScrollPositionChange={({ y }) => setScrolled(y !== 0)}
      >
        <Table layout="fixed" classNames={classes}>
          <Table.Thead
            className={cx(classes.header, { [classes.scrolled]: scrolled })}
          >
            <Table.Tr>
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
              <Th
                type="crewLabel"
                sorted={sortBy === "crewLabel"}
                reversed={reverseSortDirection}
                onSort={() => setSorting("crewLabel")}
              >
                {lang.crew}
              </Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>{rows.length > 0 ? rows : null}</Table.Tbody>
        </Table>
      </ScrollArea>
    </>
  );
};
