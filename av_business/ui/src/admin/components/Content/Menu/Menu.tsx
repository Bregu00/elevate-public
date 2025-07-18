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
} from "@mantine/core";
import { IconEraser } from "@tabler/icons-react";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import classes from "./StatsGrid.module.css";

function joinIngredients(ingredients: string[]): string {
  if (ingredients.length === 0) {
    return "N/A";
  }
  return ingredients.join(" ");
}

interface Property {
  job: string;
}

const createData = (
  info: any,
  deleteItem: any,
  inventory: string,
  daLang: any
) => {
  const { menu: lang } = daLang;
  const data = info.map((item: any, index: number) => {
    return (
      <Paper className={classes.item} key={index} mb={1} p={"xs"}>
        <Group grow justify="space-between" w={"100%"}>
          <Image
            src={
              item.image
                ? item.image
                : `${`https://cfx-nui-${inventory}${item?.name}.png`}`
            }
            w={40}
            h={40}
            fallbackSrc="https://i.imgur.com/mLaSNmh.png"
          />
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
            w={100}
            style={{ overflow: "hidden", textOverflow: "ellipsis" }}
          >
            <Text fz="sm" c="dimmed">
              {lang.product}
            </Text>
            <Text fz="sm" truncate maw={"65%"}>
              {item.label}
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
              {lang.description}
            </Text>
            <Text fz="sm" truncate w={"100%"}>
              {item.description}
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
              {daLang.ingredients}
            </Text>
            <Text fz="sm" truncate w={"100%"}>
              {item.ingredients ? joinIngredients(item.ingredients) : "N/A"}
            </Text>
          </Flex>
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
            w={100}
          >
            <Text fz="sm" c="dimmed" truncate w={"100%"}>
              {lang.suggestedPrice}
            </Text>
            <Text fz="sm">
              {item.price ? `$${item?.price?.toLocaleString("en-US")}` : "N/A"}
            </Text>
          </Flex>
          <Flex
            justify="center"
            align="flex-start"
            direction="column"
            wrap="wrap"
          >
            <Text fz="sm" c="dimmed">
              {daLang.type}
            </Text>
            <Text fz="sm" tt={"capitalize"}>
              {item.type}
            </Text>
          </Flex>
          <Group justify="center">
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
          </Group>
        </Group>
      </Paper>
    );
  });
  return data;
};

export const Menu = ({ job }: Property) => {
  const daLang: any = useRecoilValue(Lang);
  const { menu: lang } = daLang;
  const [stats, setStats] = useState([]);
  const [loaded, setLoaded] = useState(false);

  const deleteItem = async (item: any) => {
    const name = item.name;
    const resp = await fetchNui("av_business", "deleteItemAdmin", {
      name,
      job,
    });
    if (resp) {
      const items = resp.items;
      const inventory = resp.inventory;
      const newData = createData(items, deleteItem, inventory, daLang);
      setStats(newData);
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "admin", {
        job,
        type: "menu",
      });
      if (resp) {
        const items = resp.items;
        const inventory = resp.inventory;
        const data = createData(items, deleteItem, inventory, daLang);
        setStats(data);
        setTimeout(() => {
          setLoaded(true);
        }, 250);
      } else {
        console.log(
          "[ERROR] Something went wrong while fetching this business menu panel!"
        );
      }
    };
    fetchData();
  }, []);

  return (
    <div className={classes.root}>
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
  );
};
