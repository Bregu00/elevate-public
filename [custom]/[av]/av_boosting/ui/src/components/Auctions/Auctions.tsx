import { useEffect, useState } from "react";
import { Box, Stack, Group, Avatar, Flex, Text, Button } from "@mantine/core";
import { fetchNui, useNuiEvent } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { Timer } from "../../hooks/Timer";
import { Input } from "../Input/Input";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import classes from "./auctions.module.css";

interface AuctionType {
  ownerIdentifier: string;
  serial: string;
  class: string;
  name: string;
  vehLabel: string;
  owner: string;
  bid: number;
  highestBid?: string;
  auctionSeconds: number;
  deadline: number;
  auctionTime: number;
}

const Auctions = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [availableAuctions, setAvailableAuctions] = useState([]);
  const [showInput, setShowInput] = useState(false);
  const [inputOptions, setInputOptions] = useState<Options>({
    title: "",
    event: "",
    extraData: undefined,
    fields: [],
  });
  useNuiEvent("updateAuctions", (auctions: any) => {
    setAvailableAuctions(auctions);
  });
  const handleBid = (auction: AuctionType) => {
    setInputOptions({
      title: lang.auctions.bid_header,
      event: "placeBid",
      extraData: auction,
      fields: [
        { name: "bid", type: "numberInput", label: lang.auctions.bid_amount },
      ],
    });
    setShowInput(true);
  };
  const callback = (data: any, event: string, extraData: any) => {
    fetchNui("av_boosting", event, { data, extraData });
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_boosting", "getAuctions");
      if (resp) setAvailableAuctions(resp);
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
          {showInput && (
            <Input
              show={setShowInput}
              options={inputOptions}
              callback={callback}
            />
          )}
          {availableAuctions[0] ? (
            <Stack className={classes.container} gap="xs" p="xs">
              {availableAuctions.map((auction: AuctionType) => (
                <Box className={classes.auction} key={auction.serial}>
                  <Group w={"100%"} ml="md" mr="md">
                    <Group mr="auto">
                      <Avatar className={classes.avatarClass}>
                        {auction.class}
                      </Avatar>
                      <Flex
                        justify="flex-start"
                        align="flex-start"
                        direction="column"
                        wrap="wrap"
                      >
                        <Text fz="sm">
                          <strong>{lang.vehicle}: </strong>
                          {auction.vehLabel}
                        </Text>
                        <Text fz="sm">
                          <strong>{lang.owner}: </strong>
                          {auction.owner}
                        </Text>
                      </Flex>
                    </Group>
                    <Flex
                      justify="flex-start"
                      align="flex-start"
                      direction="column"
                      wrap="nowrap"
                    >
                      <Text fz="sm">
                        <strong>{lang.expires}: </strong>
                        <Timer
                          deadline={auction.auctionSeconds}
                          expired={"N/A"}
                        />
                      </Text>
                      <Text fz="sm">
                        <strong>{lang.price}: </strong>
                        {`${auction.bid} ${lang.crypto}`}
                      </Text>
                    </Flex>
                    <Button
                      ml="auto"
                      mr="md"
                      size="xs"
                      variant="light"
                      color="cyan"
                      onClick={() => {
                        handleBid(auction);
                      }}
                    >
                      Place Bid
                    </Button>
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
              {lang.auctions.empty}
            </Box>
          )}
        </>
      ) : (
        <Loading />
      )}
    </>
  );
};

export default Auctions;
