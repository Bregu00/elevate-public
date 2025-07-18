import React from "react";
import { Table, UnstyledButton, Group, Text, Center, rem } from "@mantine/core";
import {
  IconSelector,
  IconChevronDown,
  IconChevronUp,
} from "@tabler/icons-react";
import classes from "./style.module.css";

interface ThProps {
  type: string;
  children: React.ReactNode;
  reversed: boolean;
  sorted: boolean;
  onSort(): void;
}

const Th: React.FC<ThProps> = ({
  type,
  children,
  reversed,
  sorted,
  onSort,
}) => {
  const Icon = sorted
    ? reversed
      ? IconChevronUp
      : IconChevronDown
    : IconSelector;
  return (
    <Table.Th
      className={classes.th}
      style={{
        borderRight:
          type == "crew" ? `1px solid rgba(255, 255, 255, 0.12)` : `unset`,
      }}
    >
      <UnstyledButton onClick={onSort} className={classes.control}>
        <Group justify="space-between">
          <Text fw={500} fz="sm">
            {children}
          </Text>
          <Center className={classes.icon}>
            <Icon style={{ width: rem(16), height: rem(16) }} stroke={1.5} />
          </Center>
        </Group>
      </UnstyledButton>
    </Table.Th>
  );
};

export default Th;
