import { useState, useEffect } from "react";
import {
  Box,
  Button,
  NumberInput,
  TextInput,
  Image,
  Textarea,
  Select,
  Text,
  MultiSelect,
  PasswordInput,
  Grid,
} from "@mantine/core";
import { useClickOutside } from "@mantine/hooks";
import classes from "./style.module.css";

export const ModalMenu = ({ data }: any) => {
  const [isOpen, setIsOpen] = useState(false);
  const [fieldsValues, setFieldsValues] = useState({});
  const iconStyle = { fontSize: "12px" };
  const handleInput = (name: string, value: any) => {
    const newValue = { ...fieldsValues, [name]: value };
    setFieldsValues(newValue);
  };
  const ref = useClickOutside(() => {
    if (isOpen) return;
    data.callback();
  });
  useEffect(() => {
    if (data?.extraData) {
      const newValue = { ...fieldsValues, ["extraData"]: data.extraData };
      setFieldsValues(newValue);
    }
  }, [data]);

  return (
    <Box className={classes.container}>
      <Box className={classes.box} ref={ref}>
        {data.title && (
          <>
            <Text
              fz={"xl"}
              style={{ width: "100%", textAlign: "center" }}
              fw={600}
            >
              {data.title}
            </Text>
          </>
        )}

        <Grid className={classes.modalOptions} grow mt="sm">
          {data.options?.map((option: any, index: number) => (
            <Grid.Col key={index} span={option.span ? option.span : 4}>
              {option.type == "number" && (
                <NumberInput
                  classNames={classes}
                  radius={0}
                  leftSection={
                    option.icon && (
                      <i className={option.icon} style={iconStyle} />
                    )
                  }
                  placeholder={option.description}
                  label={option.title}
                  onChange={(e) => {
                    handleInput(option.name, e);
                  }}
                  disabled={option.disabled}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  defaultValue={option.default}
                  allowNegative={false}
                  allowDecimal={false}
                  size="xs"
                />
              )}
              {option.type == "text" && (
                <TextInput
                  classNames={classes}
                  radius={0}
                  leftSection={
                    option.icon && (
                      <i className={option.icon} style={iconStyle} />
                    )
                  }
                  placeholder={option.description}
                  label={option.title}
                  withAsterisk={option.asterisk}
                  onChange={(event) =>
                    handleInput(option.name, event.currentTarget.value)
                  }
                  size="xs"
                  styles={option.style}
                />
              )}
              {option.type == "image" && (
                <Image
                  src={option.image}
                  height={option.height}
                  alt={option.title}
                  style={option.style}
                  radius={4}
                />
              )}
              {option.type == "textarea" && (
                <Textarea
                  classNames={classes}
                  radius={0}
                  defaultValue={option.description}
                  label={option.label}
                  disabled={option.disabled}
                  style={option.style}
                  maxRows={3}
                  minRows={3}
                  autosize
                  onChange={(e) => {
                    handleInput(option.name, e.target.value);
                  }}
                  withAsterisk={option.asterisk}
                />
              )}
              {option.type == "info" && (
                <Text styles={option.style}>{option.description}</Text>
              )}
              {option.type == "select" && (
                <Select
                  classNames={classes}
                  radius={0}
                  size="xs"
                  label={option.title}
                  defaultValue={option.default}
                  data={option.options}
                  onChange={(value) => {
                    handleInput(option.name, value);
                  }}
                  styles={option.style}
                  withAsterisk={option.asterisk}
                  onDropdownOpen={() => {
                    setIsOpen(true);
                  }}
                  onDropdownClose={() => {
                    setIsOpen(false);
                  }}
                />
              )}
              {option.type == "multiselect" && (
                <MultiSelect
                  classNames={classes}
                  radius={0}
                  label={option.title}
                  defaultValue={option.default}
                  data={option.options}
                  onChange={(value) => {
                    handleInput(option.name, value);
                  }}
                  style={option.style}
                  withAsterisk={option.asterisk}
                  max={option.max}
                  searchable={option.searchable}
                  size="xs"
                />
              )}
              {option.type == "password" && (
                <PasswordInput
                  classNames={classes}
                  radius={0}
                  leftSection={
                    option.icon && (
                      <i className={option.icon} style={iconStyle} />
                    )
                  }
                  placeholder={option.description}
                  label={option.title}
                  withAsterisk={option.asterisk}
                  onChange={(event) =>
                    handleInput(option.name, event.currentTarget.value)
                  }
                  size="xs"
                  styles={option.style}
                />
              )}
            </Grid.Col>
          ))}
        </Grid>
        {data.button && (
          <Button
            className={classes.button}
            radius={0}
            size="sm"
            onClick={() => {
              data.callback(fieldsValues);
            }}
            color="violet"
            c="white"
            fullWidth
          >
            {data.button}
          </Button>
        )}
      </Box>
    </Box>
  );
};
