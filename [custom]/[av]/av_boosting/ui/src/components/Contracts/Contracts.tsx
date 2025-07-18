import { useEffect, useState } from "react";
import {
  Box,
  Group,
  Text,
  Avatar,
  Flex,
  ActionIcon,
  Tooltip,
  Stack,
} from "@mantine/core";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { ContractType } from "../../types/types";
import { IconFlame, IconSend, IconGavel, IconTrash, IconChecks } from "@tabler/icons-react";
import { Timer } from "../../hooks/Timer";
import { Confirmation } from "./Confirmation";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./contracts.module.css";

const Contracts = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [currentContract, setCurrentContract] = useState<ContractType>();
  const [confirmType, setConfirmType] = useState<string>("contract");
  const [contracts, setContracts] = useState([]);
  const iconStyle = { width: 16, height: 16 };
  useNuiEvent("refreshContracts", (data: any) => {
    setContracts(data);
  });
  const handleButton = (type: string, contract: ContractType) => {
    setConfirmType(type);
    setCurrentContract(contract);
    setShowConfirm(true);
  };
  const handleDelete = (serial: string) => {
    fetchNui("av_boosting", "delete", serial);
    const newContracts = contracts.filter(
      (item: ContractType) => item.serial !== serial
    );
    setContracts(newContracts);
  };
  const handleDelivery = (contract: ContractType) => {
    fetchNui('av_boosting', 'delivered', contract)
  }
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_boosting", "getContracts");
      if (resp) setContracts(resp);
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  return (
    <>
      {loaded ? (
        <>
          {currentContract && showConfirm && (
            <Confirmation
              confirmType={confirmType}
              contract={currentContract}
              show={setShowConfirm}
            />
          )}
          {contracts[0] ? (
            <Stack className={classes.container} gap="xs" p="xs">
              {contracts.map((contract: ContractType) => (
                <Box className={classes.contract} key={contract.serial}>
                  <Group w={"100%"} ml="md" mr="md" grow>
                    <Group>
                      <Avatar className={classes.avatarClass}>
                        {contract.class}
                      </Avatar>
                      <Flex
                        justify="flex-start"
                        align="flex-start"
                        direction="column"
                        wrap="wrap"
                      >
                        <Text fz="sm">
                          <strong>{lang.vehicle}: </strong>
                          {contract.vehLabel}
                        </Text>
                        <Text fz="sm">
                          <strong>{lang.plates}: </strong>
                          {contract.plates}
                        </Text>
                      </Flex>
                    </Group>
                    <Flex
                      justify="center"
                      direction="column"
                      wrap="nowrap"
                      ml="xl"
                    >
                      {contract.started ? (
                        <Text fz="sm">
                          <strong>{lang.expires}: </strong>
                          {lang.started}
                        </Text>
                      ) : (
                        <Text fz="sm">
                          <strong>{lang.expires}: </strong>
                          <Timer deadline={contract.seconds} expired={"N/A"} />
                        </Text>
                      )}
                      <Text fz="sm">
                        <strong>{lang.price}: </strong>
                        {`${contract.price} ${lang.crypto}`}
                      </Text>
                    </Flex>
                    <Group justify="flex-end" gap={6}>
                      {!contract.started ?
                        <>
                          <Tooltip
                            label={lang.contracts.start_button}
                            color="dark.4"
                          >
                            <ActionIcon
                              variant="subtle"
                              onClick={() => {
                                handleButton("start", contract);
                              }}
                            >
                              <IconFlame style={iconStyle} stroke={1.5} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip
                            label={lang.contracts.transfer_button}
                            color="dark.4"
                          >
                            <ActionIcon
                              variant="subtle"
                              onClick={() => {
                                handleButton("transfer", contract);
                              }}
                            >
                              <IconSend style={iconStyle} stroke={1.5} />
                            </ActionIcon>
                          </Tooltip>
                          <Tooltip
                            label={lang.contracts.auction_button}
                            color="dark.4"
                          >
                            <ActionIcon
                              variant="subtle"
                              onClick={() => {
                                handleButton("auction", contract);
                              }}
                            >
                              <IconGavel style={iconStyle} stroke={1.5} />
                            </ActionIcon>
                          </Tooltip>
                        </>
                        : <>
                          {contract.deliveryType == "normal" && <>
                            <Tooltip
                              label={lang.contracts.mark_delivered}
                              color="dark.4"
                            >
                              <ActionIcon
                                variant="subtle"
                                onClick={() => {
                                  handleDelivery(contract);
                                }}
                              >
                                <IconChecks style={iconStyle} stroke={1.5} />
                              </ActionIcon>
                            </Tooltip>
                          </>}
                        </>}
                      <Tooltip
                        label={lang.contracts.delete_button}
                        color="dark.4"
                      >
                        <ActionIcon
                          variant="subtle"
                          color="red.5"
                          onClick={() => {
                            handleDelete(contract.serial);
                          }}
                        >
                          <IconTrash style={iconStyle} stroke={1.5} />
                        </ActionIcon>
                      </Tooltip>
                    </Group>
                  </Group>
                </Box>
              ))}
            </Stack>
          ) : (
            <Box
              h={"100%"}
              w={"100%"}
              style={{
                position: "absolute",
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                textAlign: "center",
              }}
              c="gray.6"
              fw={400}
            >
              {lang.contracts.empty}
            </Box>
          )}
        </>
      ) : (
        <Loading />
      )}
    </>
  );
};

export default Contracts;
