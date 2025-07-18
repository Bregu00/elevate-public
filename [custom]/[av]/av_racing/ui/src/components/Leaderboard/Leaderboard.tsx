import { useState } from "react";
import { Box } from "@mantine/core";
import { PlayersTable } from "./PlayersTable/PlayersTable";
import { Footer } from "./Footer/Footer";
import { isEnvBrowser } from "../../hooks/useNuiEvents";

export const Leaderboard = () => {
  const [currentPage, setCurrentPage] = useState(1);
  const [total, setTotal] = useState(0);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  return (
    <Box p="md">
      <PlayersTable
        currentPage={currentPage}
        setCurrentPage={setCurrentPage}
        setTotal={setTotal}
        loaded={loaded}
        setLoaded={setLoaded}
      />
      <Footer
        loaded={loaded}
        page={currentPage}
        setCurrentPage={setCurrentPage}
        total={total}
      />
    </Box>
  );
};
