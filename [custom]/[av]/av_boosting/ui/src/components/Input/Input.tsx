import { useState, ChangeEvent } from 'react';
import { Box, Text, NumberInput, TextInput, Group, Button, PasswordInput } from "@mantine/core";
import { useRecoilValue } from 'recoil';
import { Lang } from '../../reducers/atoms';
import classes from './inputStyle.module.css';

export const Input = ({ options, callback, show }: InputProps) => {
  const lang:any = useRecoilValue(Lang)
  const [data, setData] = useState<Record<string, any>>({});

  const handleUpdate = (field: string, input: any) => {
    setData((prevData) => ({ ...prevData, [field]: input }));
  };

  const handleConfirm = () => {
    callback(data, options.event, options.extraData);
    show(false);
  };

  const renderField = (field: Field) => {
    switch (field.type) {
      case 'numberInput':
        return (
          <NumberInput
            key={field.name}
            classNames={classes}
            size='xs'
            allowDecimal={false}
            allowLeadingZeros={false}
            allowNegative={false}
            label={field.label}
            placeholder={field.placeholder}
            description={field.description}
            mt="xs"
            onChange={(value) => handleUpdate(field.name, value)}
          />
        );
      case 'text':
        return (
          <TextInput
            key={field.name}
            classNames={classes}
            label={field.label}
            size='xs'
            placeholder={field.placeholder}
            onChange={(e: ChangeEvent<HTMLInputElement>) => handleUpdate(field.name, e.target.value)}
            description={field.description}
            mt="xs"
          />
        );
      case 'password':
        return (
          <PasswordInput
            key={field.name}
            classNames={classes}
            label={field.label}
            size='xs'
            placeholder={field.placeholder}
            onChange={(e: ChangeEvent<HTMLInputElement>) => handleUpdate(field.name, e.target.value)}
            description={field.description}
            mt="xs"
          />
        );
      default:
        return null;
    }
  };

  return (
    <Box className={classes.container}>
      <Box className={classes.box}>
        <Text ta="center" fz="xl" fw={500}>{options.title}</Text>
        <Box className={classes.options}>
          {options.fields.map(renderField)}
        </Box>
        <Group w="100%">
          <Button mt="xs" size="xs" ml="auto" color="red" variant="subtle" onClick={() => show(false)}>{lang.cancel}</Button>
          <Button mt="xs" size="xs" color="cyan" variant="light" onClick={handleConfirm}>{lang.confirm}</Button>
        </Group>
      </Box>
    </Box>
  );
};
