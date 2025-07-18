import { Box, Pagination } from "@mantine/core";
import classes from "../style.module.css";

export const Footer = ({ page, setCurrentPage, total }: any) => {
  return (
    <Box className={classes.footer} ml={"auto"} w={"98%"} p="xs">
      <Pagination
        value={page}
        classNames={classes}
        total={total}
        size={"xs"}
        ml="auto"
        radius={0}
        color="rgba(205, 207, 102, 1)"
        autoContrast
        mt="sm"
        onChange={setCurrentPage}
      />
    </Box>
  );
};
