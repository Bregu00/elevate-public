import { Table } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

export const PositionTable = ({ data }: any) => {
  const lang: any = useRecoilValue(Lang);
  const rows = data.map((item: any, index: number) => {
    return (
      <Table.Tr key={index} c="rgba(237, 237, 237, 1)">
        <Table.Td>{`# ${item.position}`}</Table.Td>
        <Table.Td>{item.name}</Table.Td>
        <Table.Td>{item.crew ? <>{item.crew.label}</> : <>{``}</>}</Table.Td>
        <Table.Td>{item.vehicle}</Table.Td>
        <Table.Td>{item.bestTime}</Table.Td>
        <Table.Td>{item.time}</Table.Td>
      </Table.Tr>
    );
  });
  return (
    <Table verticalSpacing="sm">
      <Table.Thead>
        <Table.Tr>
          <Table.Th>{lang.position}</Table.Th>
          <Table.Th>{lang.racer}</Table.Th>
          <Table.Th>{lang.crew}</Table.Th>
          <Table.Th>{lang.vehicle}</Table.Th>
          <Table.Th>{lang.best_lap}</Table.Th>
          <Table.Th>{lang.total_time}</Table.Th>
        </Table.Tr>
      </Table.Thead>
      <Table.Tbody>{rows}</Table.Tbody>
    </Table>
  );
};
