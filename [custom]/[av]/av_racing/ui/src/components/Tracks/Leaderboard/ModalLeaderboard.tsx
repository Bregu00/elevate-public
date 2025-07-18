import { useState, useEffect } from "react";
import { Box, Text, Select, Table } from "@mantine/core";
import { useClickOutside } from "@mantine/hooks";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";

type TimeRecord = {
  miliseconds: number;
  class: string;
  name: string;
  bestTime: string;
  vehicle: string;
  crew?: string;
};

interface ModalLeaderboardProps {
  data: Record<string, TimeRecord[]>;
  setShowLeaderboard: (value: boolean) => void;
}

function sortByMiliseconds(times: TimeRecord[]): TimeRecord[] {
  return times.sort((a, b) => a.miliseconds - b.miliseconds);
}

export const ModalLeaderboard = ({
  data,
  setShowLeaderboard,
}: ModalLeaderboardProps) => {
  const lang: any = useRecoilValue(Lang);
  const [currentRecords, setCurrentRecords] = useState<TimeRecord[]>([]);
  const [tableContent, setTableContent] = useState<JSX.Element[]>([]);
  const [isOpen, setIsOpen] = useState(false);

  const handleChange = (value: string | null) => {
    if (!value) return;
    const newGroup = data[value.toLowerCase()] || [];
    const filtered = sortByMiliseconds(newGroup);
    setCurrentRecords(filtered);
  };

  const ref = useClickOutside(() => {
    if (isOpen) return;
    setShowLeaderboard(false);
  });

  useEffect(() => {
    const rows: JSX.Element[] = currentRecords.map((element: TimeRecord) => (
      <tr key={element.name}>
        <td>
          <Text fz="xs" truncate maw={120}>
            {element.name}
          </Text>
        </td>
        <td>
          <Text fz="xs" truncate maw={120}>
            {element.vehicle}
          </Text>
        </td>
        <td>{element.bestTime}</td>
        <td>{element.crew ? element.crew : ` `}</td>
      </tr>
    ));
    setTableContent(rows);
  }, [currentRecords]);

  return (
    <Box className={classes.container}>
      <Box className={classes.box} ref={ref}>
        <Text
          fz={22}
          style={{ width: "100%", textAlign: "center" }}
          c="rgba(205, 207, 102, 1)"
        >
          {lang.best_times}
        </Text>
        <Select
          classNames={classes}
          mt={4}
          label={lang.vehicle_class}
          data={[
            { value: "m", label: "M" },
            { value: "d", label: "D" },
            { value: "c", label: "C" },
            { value: "b", label: "B" },
            { value: "a", label: "A" },
            { value: "a+", label: "A+" },
            { value: "s", label: "S" },
            { value: "s+", label: "S+" },
          ]}
          onChange={handleChange}
          onDropdownOpen={() => {
            setIsOpen(true);
          }}
          onDropdownClose={() => {
            setIsOpen(false);
          }}
          size="xs"
        />
        <Table mt="sm">
          <thead>
            <tr>
              <th>{lang.username}</th>
              <th>{lang.vehicle}</th>
              <th>{lang.best_lap}</th>
              <th>{lang.crew}</th>
            </tr>
          </thead>
          <tbody>{tableContent}</tbody>
        </Table>
      </Box>
    </Box>
  );
};
