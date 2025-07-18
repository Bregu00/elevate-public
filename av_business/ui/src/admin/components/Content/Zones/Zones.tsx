import { useEffect, useState } from "react";
import {
  Group,
  Paper,
  SimpleGrid,
  Text,
  Image,
  Flex,
  ActionIcon,
  Box,
  LoadingOverlay,
  Tooltip,
} from "@mantine/core";
import { IconMapPinShare, IconEdit, IconEraser } from "@tabler/icons-react";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import classes from "./Zones.module.css";
import { Confirmation } from "../Confirmation/Confirmation";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";

interface Property {
  job: string;
}

const createData = (
  info: any,
  teleport: any,
  editItem: any,
  deleteItem: any,
  daLang: any
) => {
  const { admin: lang } = daLang;
  const data = info.map((item: any, index: number) => {
    return (
      <Paper className={classes.item} key={index} mb={1} p={"xs"}>
        <Group grow justify="space-between" w={"100%"}>
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
            w={100}
            style={{ overflow: "hidden", textOverflow: "ellipsis" }}
          >
            <Text fz="sm" c="dimmed">
              {lang.identifier}
            </Text>
            <Text fz="sm" truncate maw={"65%"}>
              {item.name}
            </Text>
          </Flex>
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
            w={100}
          >
            <Text fz="sm" c="dimmed">
              {lang.job}
            </Text>
            <Text fz="sm" truncate w={"100%"}>
              {item.job}
            </Text>
          </Flex>
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
          >
            <Text fz="sm" c="dimmed">
              {daLang.job}
            </Text>
            <Text fz="sm" tt={"capitalize"}>
              {item.type}
            </Text>
          </Flex>
          <Group justify="center">
            <Tooltip label={lang.teleport} color="dark.4">
              <ActionIcon
                size="sm"
                variant="light"
                color="orange.4"
                onClick={() => {
                  teleport(item);
                }}
              >
                <IconMapPinShare style={{ width: "70%", height: "70%" }} />
              </ActionIcon>
            </Tooltip>
            <Tooltip label={lang.edit} color="dark.4">
              <ActionIcon
                size="sm"
                variant="light"
                color="cyan.4"
                onClick={() => {
                  editItem(item);
                }}
              >
                <IconEdit style={{ width: "70%", height: "70%" }} />
              </ActionIcon>
            </Tooltip>
            <Tooltip label={lang.delete} color="dark.4">
              <ActionIcon
                size="sm"
                variant="light"
                color="red.4"
                onClick={() => {
                  deleteItem(item);
                }}
              >
                <IconEraser style={{ width: "70%", height: "70%" }} />
              </ActionIcon>
            </Tooltip>
          </Group>
        </Group>
      </Paper>
    );
  });
  return data;
};

export const Zones = ({ job }: Property) => {
  const daLang: any = useRecoilValue(Lang);
  const { admin: lang } = daLang;
  const [stats, setStats] = useState([]);
  const [loaded, setLoaded] = useState(false);
  const [showConfirm, setShowConfirm] = useState<boolean>(false);
  const [tempData, setTempData] = useState<any>([]);

  const editItem = (item: any) => {
    fetchNui("av_business", "editZone", item);
  };
  const deleteItem = (item: any) => {
    setTempData(item);
    setShowConfirm(true);
  };
  const teleport = (item: any) => {
    const parsedData = JSON.parse(item.data);
    const { coords } = parsedData;
    fetchNui("av_laptop", "teleport", coords);
  };
  const callback = async (res: boolean, data: any) => {
    setShowConfirm(false);
    if (!res) return;
    setLoaded(false);
    const name = data.name;
    const resp = await fetchNui("av_business", "deleteZone", { name, job });
    if (resp) {
      const data = createData(resp, teleport, editItem, deleteItem, daLang);
      setStats(data);
    }
    setTimeout(() => {
      setLoaded(true);
    }, 250);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "admin", {
        job,
        type: "zones",
      });
      if (resp) {
        const data = createData(resp, teleport, editItem, deleteItem, daLang);
        setStats(data);
        setTimeout(() => {
          setLoaded(true);
        }, 250);
      }
    };
    fetchData();
  }, []);

  return (
    <>
      {showConfirm && (
        <Confirmation
          title={lang.deleteHeader}
          message={lang.deleteText}
          cb={callback}
          data={tempData}
        />
      )}
      <div
        className={classes.root}
        style={{ overflow: showConfirm ? "hidden" : "auto" }}
      >
        {loaded ? (
          <>
            {stats.length > 0 ? (
              <SimpleGrid cols={1}>{stats}</SimpleGrid>
            ) : (
              <Box
                style={{
                  display: "flex",
                  alignContent: "center",
                  alignItems: "center",
                  height: "100%",
                  width: "100%",
                  justifyContent: "center",
                }}
              >
                {daLang.empty}
              </Box>
            )}
          </>
        ) : (
          <Box
            style={{
              display: "flex",
              alignContent: "center",
              alignItems: "center",
            }}
          >
            <LoadingOverlay
              visible
              zIndex={1000}
              loaderProps={{ color: "teal", type: "dots" }}
              overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
            />
          </Box>
        )}
      </div>
    </>
  );
};
