import { useState, useEffect } from "react";
import { Box } from "@mantine/core";
import { Header } from "./Header/Header";
import { Navbar } from "./Navbar/Navbar";
import { Content } from "./Content/Content";
import { ModalMenu } from "./ModalMenu/ModalMenu";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { AllGroupsType, CameraGroupType } from "../types/types";
import { Loading } from "./Loading";
import { sortGroups } from "../hooks/sortGroups";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";
import classes from "./appStyle.module.css";

export const MainApp = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allGroups, setAllGroups] = useState<AllGroupsType>({});
  const [tab, setTab] = useState<CameraGroupType>({
    value: "shared",
    label: "Shared",
    identifier: "shared",
    isJob: true,
  });
  const [showModal, setShowModal] = useState(false);
  const [modalOptions, setModalOptions] = useState({});
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "getGroups");
      if (resp) {
        const groupsArray = sortGroups(resp);
        setAllGroups(groupsArray);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  const handleDelete = (identifier: string) => {
    const updatedGroupsArray = Object.entries(allGroups).filter(
      ([_, group]) => group.identifier !== identifier
    );
    const updatedGroups = sortGroups(Object.fromEntries(updatedGroupsArray));
    setAllGroups(updatedGroups);
    fetchNui("av_cameras", "deleteGroup", identifier);
  };
  const handleShare = (identifier: string) => {
    setModalOptions({
      title: lang.sendGroup,
      options: [
        {
          name: "playerId",
          description: lang.playerId,
          type: "number",
          asterisk: true,
        },
      ],
      button: lang.confirm,
      callback: handleCallback,
      extraData: { identifier, event: "shareGroup" },
    });
    setShowModal(true);
  };
  const handleShareCam = (identifier: string) => {
    setModalOptions({
      title: lang.shareCamera,
      options: [
        {
          name: "playerId",
          description: lang.playerId,
          type: "number",
          asterisk: true,
        },
      ],
      button: lang.confirm,
      callback: handleCallback,
      extraData: { identifier, event: "shareCamera" },
    });
    setShowModal(true);
  };
  const newGroup = () => {
    setModalOptions({
      title: lang.createGroup,
      options: [
        {
          name: "name",
          description: lang.name,
          type: "text",
          asterisk: true,
        },
      ],
      button: lang.confirm,
      callback: handleGroup,
    });
    setShowModal(true);
  };
  const handleGroup = async (data: any) => {
    setShowModal(false);
    if (!data) return;
    const resp = await fetchNui("av_cameras", "newGroup", data);
    if (resp) {
      const groupsArray = sortGroups(resp);
      setAllGroups(groupsArray);
    }
  };
  const handleCallback = (data: any) => {
    setShowModal(false);
    if (!data) return;
    const { event } = data.extraData;
    fetchNui("av_cameras", event, data);
  };
  return (
    <Box className={classes.app}>
      <Header />
      <Box className={classes.main}>
        {!loaded ? (
          <Loading />
        ) : (
          <>
            {showModal && <ModalMenu data={modalOptions} />}
            <Navbar
              tab={tab}
              setTab={setTab}
              allGroups={allGroups}
              handleDelete={handleDelete}
              handleShare={handleShare}
              newGroup={newGroup}
            />
            <Content tab={tab} handleShare={handleShareCam} />
          </>
        )}
      </Box>
    </Box>
  );
};
