import { useEffect, useState } from "react";
import { ActionIcon, Box, TextInput } from "@mantine/core";
import { IconSearch, IconX } from "@tabler/icons-react";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { clearSearch, Lang } from "../../../reducers/atoms";

interface Properties {
  search: (value: string) => void;
}

export const SearchBar = ({ search }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const clearMe = useRecoilValue(clearSearch);
  const [value, setValue] = useState("");
  useEffect(() => {
    setValue("");
  }, [clearMe]);

  return (
    <Box className={classes.header}>
      <TextInput
        classNames={classes}
        placeholder={lang.main_search}
        value={value}
        onKeyDown={(e) => {
          if (e.key == "Enter") {
            search(value);
          }
        }}
        onChange={(e) => {
          setValue(e.target.value);
        }}
        size="xs"
        fz="xs"
        maxLength={30}
        leftSection={
          <IconSearch
            style={{ width: "12px", height: "12px", color: "gray" }}
            stroke={2.5}
          />
        }
        rightSection={
          <>
            {search.length > 0 && (
              <ActionIcon
                size="xs"
                variant="transparent"
                color="dark.2"
                onClick={() => {
                  setValue("");
                  search("");
                }}
              >
                <IconX stroke={1.5} style={{ width: "12px", height: "12px" }} />
              </ActionIcon>
            )}
          </>
        }
      />
    </Box>
  );
};
