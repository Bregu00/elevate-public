import { Box, Select, Group, Button, NumberInput } from "@mantine/core";
import { useState } from "react";
import { PlayersTable } from "./PlayersTable";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import { ProfileProperties, Member } from "../../../types/types";

interface CrewProperty {
  value: string;
  label: string;
}

interface Properties {
  lang: any;
  allCrews: CrewProperty[];
  setAllCrews: (list: CrewProperty[]) => void;
}

export const Crews = ({ lang, allCrews, setAllCrews }: Properties) => {
  const [currentCrew, setCurrentCrew] = useState<string | null>(null);
  const [allMembers, setAllMembers] = useState<any>([]);
  const [answer, setAnswer] = useState<string | number>("");
  const handleChange = async (name: string | null) => {
    setCurrentCrew(name);
    if (name) {
      const resp = await fetchNui("av_racing", "getMembers", name);
      if (resp) setAllMembers(resp);
    }
  };
  const deleteCrew = () => {
    setAnswer("");
    const copy = allCrews.filter((crew) => crew.value !== currentCrew);
    setAllCrews(copy);
    fetchNui("av_racing", "deleteCrew", currentCrew);
    setCurrentCrew(null);
  };
  const removeMember = (identifier: string) => {
    const updatedMembers = allMembers.filter(
      (member: Member) => member.identifier !== identifier
    );
    setAllMembers(updatedMembers);
    fetchNui("av_racing", "fireMember", identifier);
  };
  const handleEdit = (identifier: string, value: number) => {
    const updatedMembers = allMembers.map((member: Member) =>
      member.identifier === identifier ? { ...member, isBoss: value } : member
    );
    setAllMembers(updatedMembers);
    fetchNui("av_racing", "changeBoss", { identifier, value });
  };
  return (
    <Box w="100%">
      <Group w="100%">
        <Select
          classNames={classes}
          placeholder={lang.admin.selectCrew}
          size="xs"
          w={170}
          data={allCrews}
          value={currentCrew}
          onChange={(e) => {
            handleChange(e);
          }}
        />
        {currentCrew && (
          <Group ml="auto">
            <NumberInput
              placeholder="2+2 = ?"
              classNames={classes}
              w={80}
              size="xs"
              onChange={(e) => {
                setAnswer(e);
              }}
              allowDecimal={false}
              allowNegative={false}
              allowLeadingZeros={false}
            />
            <Button
              size="xs"
              variant="light"
              color="rgb(205, 207, 102)"
              onClick={deleteCrew}
              disabled={answer !== 4}
            >
              {lang.admin.deleteCrew}
            </Button>
          </Group>
        )}
      </Group>
      {currentCrew && (
        <PlayersTable
          lang={lang}
          allMembers={allMembers}
          removeMember={removeMember}
          handleEdit={handleEdit}
        />
      )}
    </Box>
  );
};
