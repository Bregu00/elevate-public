import { useEffect, useState } from 'react';
import { Box, Table, TextInput, rem, Avatar } from '@mantine/core';
import { IconSearch } from '@tabler/icons-react';
import { Th } from "./Th";
import { sortData } from './Filter';
import { UserProfile } from '../../types/types';
import { fetchNui } from '../../hooks/useNuiEvents';
import { FormatTime } from '../../hooks/formatTime'
import { useRecoilValue } from 'recoil';
import { Lang } from '../../reducers/atoms';
import classes from './Leaderboardstyle.module.css';

const Leaderboard = () => {
  const lang:any = useRecoilValue(Lang)
  const [loaded, setLoaded] = useState(true);
  const [allRecords, setAllRecords] = useState<UserProfile[]>([]);
  const [search, setSearch] = useState('');
  const [sortedData, setSortedData] = useState(allRecords);
  const [sortBy, setSortBy] = useState<keyof UserProfile | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);

  const setSorting = (field: keyof UserProfile) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(sortData(allRecords, { sortBy: field, reversed, search }));
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.currentTarget;
    setSearch(value);
    setSortedData(sortData(allRecords, { sortBy, reversed: reverseSortDirection, search: value }));
  };

  const rows = sortedData.map((row: UserProfile) => (
    <Table.Tr key={row.name}>
      <Table.Td><Avatar src={row.photo} size={30}/></Table.Td>
      <Table.Td>{row.name}</Table.Td>
      <Table.Td>{row.level}</Table.Td>
      <Table.Td>{row.hacks}</Table.Td>
      <Table.Td>{row.deliveries}</Table.Td>
      <Table.Td>{FormatTime(row.time)}</Table.Td>
    </Table.Tr>
  ));

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui('av_boosting', 'getLeaderboard');
      if (resp) {
        setAllRecords(resp);
        setSortedData(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <>
      {loaded ? (
        <Box p="xs" className={classes.container}>
          <TextInput
            placeholder={lang.leaderboard.search}
            mb="md"
            leftSection={<IconSearch style={{ width: rem(16), height: rem(16) }} stroke={1.5} />}
            value={search}
            onChange={handleSearchChange}
            classNames={{
              input: classes.input,
            }}
          />
          <Box>
            <Table horizontalSpacing="md" verticalSpacing="xs" miw={700} layout="fixed">
              <Table.Tbody>
                <Table.Tr>
                  <Table.Th w={60}/>
                  <Th
                    sorted={sortBy === 'name'}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting('name')}
                  >
                    {lang.leaderboard.name}
                  </Th>
                  <Th
                    sorted={sortBy === 'level'}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting('level')}
                  >
                    {lang.leaderboard.exp}
                  </Th>
                  <Th
                    sorted={sortBy === 'hacks'}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting('hacks')}
                  >
                    {lang.leaderboard.hacks}
                  </Th>
                  <Th
                    sorted={sortBy === 'deliveries'}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting('deliveries')}
                  >
                    {lang.leaderboard.deliveries}
                  </Th>
                  <Th
                    sorted={sortBy === 'time'}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting('time')}
                  >
                    {lang.leaderboard.best_time}
                  </Th>
                </Table.Tr>
              </Table.Tbody>
              <Table.Tbody>{rows.length > 0 ? rows : null}</Table.Tbody>
            </Table>
          </Box>
        </Box>
      ) : (
        <></>
      )}
    </>
  );
};

export default Leaderboard;