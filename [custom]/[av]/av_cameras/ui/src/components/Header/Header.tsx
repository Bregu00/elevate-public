import { Box, Group, Text, Flex } from "@mantine/core";
import { IconPlayerPlayFilled } from "@tabler/icons-react";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

export const Header = () => {
  const lang: any = useRecoilValue(Lang);
  return (
    <>
      <Box className={classes.header}>
        <Group>
          <Box className={classes.iconHeader}>
            <IconPlayerPlayFilled style={{ height: "26px", width: "26px" }} />
          </Box>
          <Flex direction="column" className={classes.textFlex}>
            <Text className={classes.textHeader}>{lang.header}</Text>
            <Text className={classes.textSubheader}>{lang.subheader}</Text>
          </Flex>
        </Group>
      </Box>
      <Box className={classes.divider} />
    </>
  );
};
