import { useState, useEffect } from "react";
import {
  Table,
  Box,
  UnstyledButton,
  Button,
  Group,
  Text,
  Center,
  TextInput,
  rem,
  ActionIcon,
  Avatar,
  Select,
  LoadingOverlay,
} from "@mantine/core";
import {
  IconSelector,
  IconChevronDown,
  IconChevronUp,
  IconSearch,
  IconEdit,
  IconBuildingBank,
  IconEraser,
} from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";
import { Editor } from "./Editor";
// import classes from "./Employees.module.css";
import { Confirmation } from "./Confirmation";
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents";

interface Employee {
  identifier: string;
  name: string;
  phone: string;
  email: string;
  gradeName: string;
  gradeLabel: string;
  avatar: string;
  permissions: string[];
  lastSeen: string;
  generated: number;
}

interface ThProps {
  children: React.ReactNode;
  reversed: boolean;
  sorted: boolean;
  onSort(): void;
}

function Th({ children, reversed, sorted, onSort }: ThProps) {
  const Icon = sorted
    ? reversed
      ? IconChevronUp
      : IconChevronDown
    : IconSelector;
  return (
    <Table.Th className={"classes.th"}>
      <UnstyledButton onClick={onSort} className={"classes.control"}>
        <Group justify="space-between">
          <Text fw={500} fz="sm">
            {children}
          </Text>
          <Center className={"classes.icon"}>
            <Icon style={{ width: rem(16), height: rem(16) }} stroke={1.5} />
          </Center>
        </Group>
      </UnstyledButton>
    </Table.Th>
  );
}

function filterData(data: Employee[], search: string) {
  const query = search.toLowerCase().trim();
  return data.filter((item) =>
    (Object.keys(item) as Array<keyof Employee>).some((key) =>
      item[key].toString().toLowerCase().includes(query)
    )
  );
}

function sortData(
  data: Employee[],
  payload: { sortBy: keyof Employee | null; reversed: boolean; search: string }
): Employee[] {
  const { sortBy, reversed } = payload;

  if (!sortBy) {
    return filterData(data, payload.search);
  }

  return filterData(
    [...data].sort((a, b) => {
      let aValue = a[sortBy];
      let bValue = b[sortBy];
      if (typeof aValue === "number" && typeof bValue === "number") {
        return reversed ? bValue - aValue : aValue - bValue;
      }
      return reversed
        ? bValue.toString().localeCompare(aValue.toString())
        : aValue.toString().localeCompare(bValue.toString());
    }),
    payload.search
  );
}

const Employees = () => {
  const { employees: lang }: any = useRecoilValue(Lang);
  const [data, setData] = useState([]);
  const [grades, setGrades] = useState([]);
  const [inputType, setInputType] = useState("delete");
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [identifier, setIdentifier] = useState("");
  const [showEditor, setShowEditor] = useState(false);
  const [currentEmployee, setCurrentEmployee] = useState([]);
  const [search, setSearch] = useState("");
  const [sortedData, setSortedData] = useState<any>(data);
  const [sortBy, setSortBy] = useState<keyof Employee | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [loaded, setLoaded] = useState(false);

  function getGradeValueByEmployee(employee: any): string | undefined {
    const grade: any = grades.find((g: any) => g.value == employee.grade.level);
    return grade ? grade.value : undefined;
  }
  const hirePlayer = async () => {
    const resp = await fetchNui("av_business", "hire");
    if (resp) {
      setData(resp);
      setSortedData(resp);
    }
  };
  const handleEdit = (data: any) => {
    setCurrentEmployee(data);
    setShowEditor(true);
  };

  const handleBonus = (data: any) => {
    setIdentifier(data.identifier);
    setInputType("money");
    setShowConfirmation(true);
  };

  const handleFire = (data: any) => {
    setIdentifier(data.identifier);
    setInputType("delete");
    setShowConfirmation(true);
  };
  const setSorting = (field: keyof Employee) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(sortData(data, { sortBy: field, reversed, search }));
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.currentTarget;
    setSearch(value);
    setSortedData(
      sortData(data, { sortBy, reversed: reverseSortDirection, search: value })
    );
  };

  const handleGrade = (employee: Employee, value: string | null) => {
    if (value) {
      fetchNui("av_business", "updateGrade", {
        identifier: employee.identifier,
        grade: value,
      });
    }
  };
  const removeEmployee = (identifier: string) => {
    const newData = data.filter((item: any) => item.identifier !== identifier);
    setData(newData);
    setSortedData(newData);
  };
  const rows = sortedData?.map((row: any) => (
    <Table.Tr key={row.name} fz="xs">
      <Table.Td>
        <Avatar src={row.image} size={30} />
      </Table.Td>
      <Table.Td>{row.name}</Table.Td>
      <Table.Td>
        {/* <Select
          defaultValue={getGradeValueByEmployee(row)}
          size={"xs"}
          data={grades}
          classNames={{
            option: classes.option,
          }}
          styles={{
            input: {
              backgroundColor: "transparent",
            },
            dropdown: {
              backgroundColor: "rgba(39, 43, 54, 0.95)",
            },
          }}
          onChange={(e) => {
            handleGrade(row, e);
          }}
        /> */}
      </Table.Td>
      <Table.Td>
        {row?.generated ? `$${row.generated.toLocaleString("en-US")}` : `$0`}
      </Table.Td>
      <Table.Td>{row.lastSeen}</Table.Td>
      <Table.Td>
        <Group gap="sm">
          <ActionIcon
            size={"sm"}
            variant="subtle"
            color="cyan.4"
            onClick={() => {
              handleEdit(row);
            }}
          >
            <IconEdit style={{ width: "70%", height: "70%" }} />
          </ActionIcon>
          <ActionIcon
            size={"sm"}
            variant="subtle"
            color="teal.4"
            onClick={() => {
              handleBonus(row);
            }}
          >
            <IconBuildingBank style={{ width: "70%", height: "70%" }} />
          </ActionIcon>
          <ActionIcon
            size={"sm"}
            variant="subtle"
            color="red.4"
            onClick={() => {
              handleFire(row);
            }}
          >
            <IconEraser style={{ width: "70%", height: "70%" }} />
          </ActionIcon>
        </Group>
      </Table.Td>
    </Table.Tr>
  ));
  useNuiEvent("updateEmployees", (data: any) => {
    setData(data);
    setSortedData(data);
  });
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getEmployees");
      if (resp) {
        console.log(JSON.stringify(resp.employees));
        setData(resp.employees);
        setSortedData(resp.employees);
        setGrades(resp.grades);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <>
      {!loaded ? (
        <Box
          style={{
            display: "flex",
            alignContent: "center",
            alignItems: "center",
            height: "100%",
          }}
        >
          <LoadingOverlay
            visible
            zIndex={1000}
            loaderProps={{ color: "teal", type: "dots" }}
            overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
          />
        </Box>
      ) : (
        <>
          {showEditor && <Editor data={currentEmployee} show={setShowEditor} />}
          {showConfirmation && (
            <Confirmation
              identifier={identifier}
              type={inputType}
              show={setShowConfirmation}
              handleFire={removeEmployee}
            />
          )}
          <Group gap="sm" mb="md" preventGrowOverflow={false} grow>
            <TextInput
              placeholder={lang.search}
              leftSection={
                <IconSearch
                  style={{ width: rem(16), height: rem(16) }}
                  stroke={1.5}
                />
              }
              value={search}
              onChange={handleSearchChange}
              styles={{
                input: {
                  backgroundColor: "rgba(39, 43, 54, 0.25)",
                },
              }}
              opacity={showEditor || showConfirmation ? 0.1 : 1.0}
            />
            <Button
              variant="light"
              color="teal"
              maw={"15%"}
              onClick={() => {
                hirePlayer();
              }}
              opacity={showEditor || showConfirmation ? 0.1 : 1.0}
            >
              {lang.hire}
            </Button>
          </Group>
          <Box h={"90%"} style={{ overflow: "auto" }}>
            <Table horizontalSpacing="md" verticalSpacing="xs" layout="fixed">
              <Table.Tbody>
                <Table.Tr>
                  <Table.Th w={60}></Table.Th>
                  <Th
                    sorted={sortBy === "name"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("name")}
                  >
                    {lang.name}
                  </Th>
                  <Table.Th>{lang.grade}</Table.Th>
                  <Th
                    sorted={sortBy === "generated"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("generated")}
                  >
                    {lang.generated}
                  </Th>
                  <Th
                    sorted={sortBy === "lastSeen"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("lastSeen")}
                  >
                    {lang.lastSeen}
                  </Th>
                  <Table.Th>{lang.actions}</Table.Th>
                </Table.Tr>
              </Table.Tbody>
              <Table.Tbody>{rows.length > 0 ? rows : null}</Table.Tbody>
            </Table>
          </Box>
        </>
      )}
    </>
  );
};

export default Employees;
