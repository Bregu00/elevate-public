import { Box } from "@mantine/core";
import { Events } from "./Events/Events";
import { Results } from "./Results/Results";
import { useState } from "react";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import classes from "./style.module.css";

const Home = () => {
  const [showModal, setShowModal] = useState(false);
  const [modalOptions, setModalOptions] = useState({});
  return (
    <>
      {showModal && <ModalMenu data={modalOptions} />}
      <Box className={classes.container} p="md">
        <Events setShowModal={setShowModal} setModalOptions={setModalOptions} />
        <Results />
      </Box>
    </>
  );
};

export default Home;
