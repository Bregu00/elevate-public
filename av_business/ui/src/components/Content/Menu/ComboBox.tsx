import { useState, useEffect } from 'react';
import { Combobox, TextInput, useCombobox } from '@mantine/core';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import classes from './Editor.module.css'

interface Properties {
    isNew: (state:boolean) => void;
    setName: (name:string) => void;
    items: any
}

export const ComboBox = ({isNew, setName, items}:Properties) => {
  const daLang:any = useRecoilValue(Lang);
  const { menu: lang } = daLang
  const combobox = useCombobox();
  const [value, setValue] = useState('');
  const shouldFilterOptions = !items.some((item:string) => item === value);
  const filteredOptions = shouldFilterOptions
    ? items.filter((item:string) => item.toLowerCase().includes(value.toLowerCase().trim()))
    : items;

  const options = filteredOptions.map((item:string) => (
    <Combobox.Option value={item} key={item}>
      {item}
    </Combobox.Option>
  ));
    useEffect(() => {
      if(options.length == 0) {
        isNew(true)
      }
    }, [options])
    
  return (
    <Combobox
      onOptionSubmit={(optionValue) => {
        setValue(optionValue);
        setName(optionValue);
        isNew(false)
        combobox.closeDropdown();
      }}
      store={combobox}
      classNames={{
        dropdown: classes.dropdown,
        option: classes.option
      }}
    >
      <Combobox.Target>
        <TextInput
          label={lang.name}
          placeholder={lang.namePlaceholder}
          value={value}
          onChange={(event) => {
            setValue(event.currentTarget.value);
            setName(event.currentTarget.value);
            combobox.openDropdown();
            combobox.updateSelectedOptionIndex();
          }}
          onClick={() => combobox.openDropdown()}
          onFocus={() => combobox.openDropdown()}
          onBlur={() => combobox.closeDropdown()}
          size='xs'
          classNames={{
                input: classes.input
            }}
        />
      </Combobox.Target>

      <Combobox.Dropdown>
        <Combobox.Options>
          {options.length === 0 ? <Combobox.Empty>{lang.isNew}</Combobox.Empty> : options}
        </Combobox.Options>
      </Combobox.Dropdown>
    </Combobox>
  );
}