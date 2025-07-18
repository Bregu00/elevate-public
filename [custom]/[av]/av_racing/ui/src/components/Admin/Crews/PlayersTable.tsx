import {
  Box,
  Table,
  Group,
  Avatar,
  Text,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import { IconTrash, IconCrown, IconCrownOff } from "@tabler/icons-react";
import { Member } from "../../../types/types";

interface Properties {
  lang: any;
  allMembers: Member[];
  removeMember: (option: string) => void;
  handleEdit: (identifier: string, value: number) => void;
}

export const PlayersTable = ({
  lang,
  allMembers,
  removeMember,
  handleEdit,
}: Properties) => {
  const rows = allMembers.map((item) => {
    return (
      <Table.Tr key={item.identifier}>
        <Table.Td>
          <Group gap="sm">
            <Avatar size={26} src={item.photo} radius={26} />
            <Text size="sm" fw={500}>
              {item.name}
            </Text>
          </Group>
        </Table.Td>
        <Table.Td style={{ userSelect: "text" }}>{item.identifier}</Table.Td>
        <Table.Td>{item.isBoss ? lang.yes : lang.no}</Table.Td>
        <Table.Td>
          <Group>
            <ActionIcon
              size="xs"
              variant="transparent"
              color="gray"
              onClick={() => {
                removeMember(item.identifier);
              }}
            >
              <IconTrash />
            </ActionIcon>
            {item.isBoss ? (
              <Tooltip label={lang.remove_boss} color="dark.5">
                <ActionIcon
                  variant="transparent"
                  color="rgb(237,237,237)"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleEdit(item.identifier, 0);
                  }}
                >
                  <IconCrownOff size={16} />
                </ActionIcon>
              </Tooltip>
            ) : (
              <Tooltip label={lang.set_boss} color="dark.5">
                <ActionIcon
                  variant="transparent"
                  color="rgb(237,237,237)"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleEdit(item.identifier, 1);
                  }}
                >
                  <IconCrown size={16} />
                </ActionIcon>
              </Tooltip>
            )}
          </Group>
        </Table.Td>
      </Table.Tr>
    );
  });
  return (
    <Box mt="sm">
      <Table miw={800} verticalSpacing="sm">
        <Table.Thead>
          <Table.Tr>
            <Table.Th>{lang.username}</Table.Th>
            <Table.Th>{lang.identifier}</Table.Th>
            <Table.Th>{lang.boss}</Table.Th>
            <Table.Th>{lang.actions}</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>{rows}</Table.Tbody>
      </Table>
    </Box>
  );
};
