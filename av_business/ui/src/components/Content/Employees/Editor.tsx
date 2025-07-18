import { useState } from "react";
import {
  Box,
  Paper,
  Avatar,
  TextInput,
  MultiSelect,
  Button,
  Group,
} from "@mantine/core";
import { useRecoilValue } from "recoil";
import { RestData, Lang } from "../../../reducers/atoms";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./Editor.module.css";

export const Editor = ({ data, show }: any) => {
  const daLang: any = useRecoilValue(Lang);
  const { employees: lang } = daLang;
  const [employee, setEmployee] = useState(data);
  const restData: any = useRecoilValue(RestData);
  const defaultPermissions = restData.allPermissions
    .filter(
      (permission: any) =>
        data.permissions && data.permissions[permission.value]
    )
    .map((permission: any) => permission.value);
  const handleSave = (data: any) => {
    fetchNui("av_business", "updateEmployee", data);
    show(false);
  };
  const handleChange = (value: string, event: any) => {
    setEmployee((prevEmployee: any) => ({
      ...prevEmployee,
      [value]: event.target.value,
    }));
  };
  const handlePermissions = (value: string[]) => {
    const permissionsObject = value.reduce((acc: any, permission) => {
      acc[permission] = true;
      return acc;
    }, {});

    setEmployee((prevEmployee: any) => ({
      ...prevEmployee,
      permissions: permissionsObject,
    }));
  };
  return (
    <Box className={classes.editorContainer}>
      <Paper className={classes.editor} p={"md"}>
        <Avatar
          src={employee.image}
          w={75}
          h={75}
          style={{
            justifyContent: "center",
            textAlign: "center",
            marginLeft: "auto",
            marginRight: "auto",
            border: "solid 2px rgba(255,255,255,0.25)",
          }}
        />
        <TextInput
          label={lang.name}
          value={employee.name ? employee.name : ""}
          size="xs"
          classNames={{
            input: classes.input,
          }}
        />
        <TextInput
          label={lang.phone}
          defaultValue={employee.phone ? employee.phone : ""}
          size="xs"
          classNames={{
            input: classes.input,
          }}
          mt={"xs"}
          onChange={(e) => {
            handleChange("phone", e);
          }}
        />
        <TextInput
          label={lang.email}
          defaultValue={employee.email ? employee.email : ""}
          size="xs"
          classNames={{
            input: classes.input,
          }}
          mt={"xs"}
          onChange={(e) => {
            handleChange("email", e);
          }}
        />
        <TextInput
          label={lang.photo}
          defaultValue={employee.image ? employee.image : ""}
          size="xs"
          classNames={{
            input: classes.input,
          }}
          mt={"xs"}
          onChange={(e) => {
            handleChange("image", e);
          }}
        />
        <MultiSelect
          label={lang.permissions}
          size="xs"
          classNames={{
            input: classes.input,
            pill: classes.pill,
            options: classes.options,
            option: classes.option,
          }}
          mt={"xs"}
          defaultValue={defaultPermissions}
          data={restData.allPermissions}
          styles={{
            dropdown: {
              backgroundColor: "rgba(39, 43, 54, 0.9)",
            },
          }}
          onChange={(e) => {
            handlePermissions(e);
          }}
        />
        <Group mt={"sm"} grow>
          <Button
            size="xs"
            variant="light"
            color="cyan"
            onClick={() => {
              handleSave(employee);
            }}
          >
            {daLang.save}
          </Button>
          <Button
            size="xs"
            variant="light"
            color="red"
            onClick={() => {
              show(false);
            }}
          >
            {daLang.close}
          </Button>
        </Group>
      </Paper>
    </Box>
  );
};
