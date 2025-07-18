import { useEffect, useState } from "react";
import { Box, Text, Select, Button, Group, NumberInput } from "@mantine/core";
import { ContractType, UserProfile } from "../../types/types";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Profile, Lang } from "../../reducers/atoms";
import { formatString } from "../../hooks/formatString";
import classes from "./confirmation.module.css";

interface Properties {
  confirmType: string;
  contract: ContractType;
  show: (state: boolean) => void;
}

export const Confirmation = ({ confirmType, contract, show }: Properties) => {
  const profile = useRecoilValue<UserProfile>(Profile);
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [canVin, setCanVin] = useState(false);
  const [options, setOptions] = useState([
    { value: "normal", label: lang.contracts.normal_delivery },
  ]);
  const [mode, setMode] = useState<string>("normal");
  const [playerId, setPlayerId] = useState<number | string>(1);
  const [bid, setBid] = useState<number | string>(1);
  const handleConfirm = () => {
    show(false);
    fetchNui("av_boosting", confirmType, {
      contract,
      playerId,
      bid,
      mode,
      name: profile.name,
    });
  };
  useEffect(() => {
    const fetchVin = async () => {
      const resp = await fetchNui("av_boosting", "getVin", contract.class);
      if (resp) {
        setCanVin(resp);
        setOptions([
          ...options,
          { value: "vin", label: lang.contracts.vin_delivery },
        ]);
      }
      setLoaded(true);
    };
    fetchVin();
  }, []);

  return (
    <>
      {loaded && (
        <Box className={classes.container}>
          <Box className={classes.box} p="sm">
            {confirmType == "start" && (
              <>
                <Text ta="center" fz="xl" fw={500}>
                  {lang.contracts.start_header}
                </Text>
                <Text size="sm" mt="xs">
                  <strong>{lang.contracts.normal_delivery}: </strong>
                  <a style={{ color: "rgba(200,200,200,0.9)" }}>
                    {formatString(lang.contracts.normal_description, [
                      contract.price,
                      lang.crypto,
                    ])}
                  </a>
                </Text>
                {canVin && (
                  <Text size="sm" mt="xs">
                    <strong>{lang.contracts.vin_delivery}: </strong>
                    <a style={{ color: "rgba(200,200,200,0.9)" }}>
                      {formatString(lang.contracts.vin_description, [
                        contract.priceVin,
                        lang.crypto,
                      ])}
                    </a>
                  </Text>
                )}
                <Select
                  data={options}
                  mt="xs"
                  size="xs"
                  classNames={classes}
                  onChange={(value) => {
                    value && setMode(value);
                  }}
                  allowDeselect={false}
                  defaultValue="normal"
                />
              </>
            )}
            {confirmType == "transfer" && (
              <>
                <Text ta="center" fz="xl" fw={500}>
                  {lang.contracts.transfer_header}
                </Text>
                <Text size="sm" mt="xs">
                  {lang.contracts.transfer_description}
                </Text>
                <NumberInput
                  placeholder={lang.playerId}
                  min={1}
                  classNames={classes}
                  mt="sm"
                  allowDecimal={false}
                  allowLeadingZeros={false}
                  allowNegative={false}
                  onChange={(value) => {
                    setPlayerId(value);
                  }}
                />
              </>
            )}
            {confirmType == "auction" && (
              <>
                <Text ta="center" fz="xl" fw={500}>
                  {lang.contracts.auction_header}
                </Text>
                <Text size="sm" mt="xs">
                  {lang.contracts.auction_description}
                </Text>
                <NumberInput
                  placeholder={lang.contracts.min_bid}
                  min={1}
                  classNames={classes}
                  mt="sm"
                  allowDecimal={false}
                  allowLeadingZeros={false}
                  allowNegative={false}
                  onChange={(value) => {
                    setBid(value);
                  }}
                />
              </>
            )}
            <Group w="100%">
              <Button
                mt="xs"
                size="xs"
                ml="auto"
                color="red"
                variant="subtle"
                onClick={() => {
                  show(false);
                }}
              >
                {lang.cancel}
              </Button>
              <Button
                mt="xs"
                size="xs"
                color="cyan"
                variant="light"
                disabled={!mode}
                onClick={handleConfirm}
              >
                {lang.confirm}
              </Button>
            </Group>
          </Box>
        </Box>
      )}
    </>
  );
};
