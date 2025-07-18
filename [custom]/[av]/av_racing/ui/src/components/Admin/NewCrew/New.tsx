import { Button, Box, TextInput, NumberInput, Title } from "@mantine/core";
import classes from "../style.module.css";
import { useState } from "react";
import { fetchNui } from "../../../hooks/useNuiEvents";
export const New = ({ lang }: any) => {
  const [name, setName] = useState<string | null>(null);
  const [playerId, setPlayerId] = useState<number | string>(0);
  const handleRegister = async () => {
    const resp = await fetchNui("av_racing", "registerCrew", {
      name,
      playerId,
    });
    if (resp) {
      setName(null);
      setPlayerId(0);
    }
  };
  return (
    <Box
      w={"100%"}
      h="100%"
      style={{
        position: "absolute",
      }}
    >
      <Box
        w={"100%"}
        h={"25vh"}
        style={{
          position: "relative",
          alignContent: "center",
          alignItems: "center",
        }}
      >
        <Title ta="center" order={3} tt="uppercase">
          {lang.admin.register}
        </Title>
        <TextInput
          classNames={classes}
          label={lang.admin.crewName}
          size="xs"
          maw={300}
          ml="auto"
          mr="auto"
          value={name ? name : ""}
          onChange={(e) => {
            setName(e.target.value);
          }}
          withAsterisk
        />
        <NumberInput
          classNames={classes}
          label={lang.admin.playerBoss}
          value={playerId}
          size="xs"
          mt="md"
          maw={300}
          ml="auto"
          mr="auto"
          allowDecimal={false}
          allowLeadingZeros={false}
          allowNegative={false}
          withAsterisk
          onChange={(e) => {
            setPlayerId(e);
          }}
        />
        <Button
          mt="lg"
          fullWidth
          size="xs"
          variant="filled"
          color="rgb(205, 207, 102)"
          c="black"
          tt="uppercase"
          maw={300}
          ml="auto"
          mr="auto"
          disabled={!name || playerId == 0}
          onClick={handleRegister}
        >
          {lang.create}
        </Button>
      </Box>
    </Box>
  );
};
