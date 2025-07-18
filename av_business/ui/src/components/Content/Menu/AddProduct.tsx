import { useEffect, useState } from "react";
import {
  Box,
  Text,
  TextInput,
  MultiSelect,
  NumberInput,
  Button,
  Group,
  Select,
} from "@mantine/core";
import { ComboBox } from "./ComboBox";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { checkIfImageExists } from "../../../hooks/imageExists";
import classes from "./Editor.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

export const AddProduct = ({ types, show }: any) => {
  const daLang: any = useRecoilValue(Lang);
  const { menu: lang } = daLang;
  const [defaultItems, setDefaultItems] = useState([]);
  const [allAnimations, setAllAnimations] = useState([]);
  const [allIngredients, setAllIngredients] = useState([]);
  const [animations, setAnimations] = useState([]);
  const [ingredients, setIngredients] = useState<string[]>([]);
  const [isNew, setIsNew] = useState(false);
  const [name, setName] = useState<null | string>(null);
  const [description, setDescription] = useState("");
  const [image, setImage] = useState<string>("");
  const [invalid, setInvalid] = useState(false);
  const [type, setType] = useState<string | null>(null);
  const [price, setPrice] = useState<number | string>(0);
  const [itemIngredients, setItemIngredients] = useState<null | string[]>(null);
  const [itemAnimation, setItemAnimation] = useState<null | string>(null);
  const [maxIngredients, setMaxIngredients] = useState(5);

  const handleDescription = (text: string) => {
    if (text.length < 40) {
      setDescription(text);
    }
  };
  const handleSave = () => {
    show(false);
    fetchNui("av_business", "addItem", {
      name,
      description,
      image,
      type,
      ingredients: itemIngredients,
      price,
      isNew,
      prop: itemAnimation,
    });
  };

  const handleImage = async (url: string) => {
    setInvalid(false);
    const exists = await checkIfImageExists(url);
    if (exists) {
      setImage(url);
    } else {
      setImage("");
      setInvalid(true);
    }
  };
  const handleIngredients = (value: any) => {
    setType(value);
    const filteredIngredients = allIngredients.filter(
      (item: any) => item.type?.includes(value) ?? false
    );
    const filteredAnimations = allAnimations.filter(
      (item: any) => item.type?.includes(value) ?? false
    );
    setIngredients(filteredIngredients);
    setAnimations(filteredAnimations);
  };
  useEffect(() => {
    const getData = async () => {
      const resp = await fetchNui("av_business", "getNewItem");
      if (resp) {
        setDefaultItems(resp.items);
        setAllAnimations(resp.animations);
        setAllIngredients(resp.ingredients);
        setMaxIngredients(resp.maxIngredients);
      } else {
        console.log(
          "[ERROR] We couldn't fetch the info from getNewItem, verify it with your server admin."
        );
        console.log(
          "[ERROR] We couldn't fetch the info from getNewItem, verify it with your server admin."
        );
        console.log(
          "[ERROR] We couldn't fetch the info from getNewItem, verify it with your server admin."
        );
        show(false);
      }
    };
    getData();
  }, []);

  return (
    <Box className={classes.mainContainer}>
      <Box className={classes.menuContainer}>
        <Text ta="center" fw={500} size="lg">
          {lang.add}
        </Text>
        <Box p={"xs"}>
          <ComboBox isNew={setIsNew} setName={setName} items={defaultItems} />
          <TextInput
            label={lang.productDescription}
            placeholder={lang.descriptionPlaceholder}
            value={description}
            size="xs"
            mt={"xs"}
            classNames={{
              input: classes.input,
            }}
            onChange={(e) => {
              handleDescription(e.target.value);
            }}
          />
          {isNew && (
            <>
              <TextInput
                label={lang.productImage}
                value={image}
                placeholder={lang.imagePlaceholder}
                size="xs"
                mt={"xs"}
                classNames={{
                  input: classes.input,
                }}
                error={invalid}
                onError={() => {
                  setImage("");
                }}
                onChange={(e) => {
                  handleImage(e.target.value);
                }}
              />
            </>
          )}
          <Select
            label={lang.productType}
            data={types}
            size="xs"
            mt={"xs"}
            classNames={{
              input: classes.input,
              dropdown: classes.dropdown,
              option: classes.option,
            }}
            onChange={(e) => {
              handleIngredients(e);
            }}
          />
          {type && (
            <>
              <Select
                label={lang.animation}
                data={animations}
                size="xs"
                mt={"xs"}
                classNames={{
                  input: classes.input,
                  dropdown: classes.dropdown,
                  option: classes.option,
                }}
                onChange={setItemAnimation}
              />
              <MultiSelect
                label={daLang.ingredients}
                data={ingredients}
                size="xs"
                mt={"xs"}
                classNames={{
                  input: classes.input,
                  dropdown: classes.dropdown,
                  option: classes.option,
                  pill: classes.pill,
                }}
                onChange={setItemIngredients}
                maxValues={maxIngredients}
              />
            </>
          )}
          <NumberInput
            label={lang.suggestedPrice}
            mt={"xs"}
            size="xs"
            classNames={{
              input: classes.input,
            }}
            onChange={setPrice}
            required
          />
          <Group mt={"md"} grow>
            <Button
              size="xs"
              variant="light"
              color="cyan"
              onClick={() => {
                handleSave();
              }}
              disabled={!type && !name}
            >
              {daLang.confirm}
            </Button>
            <Button
              size="xs"
              variant="light"
              color="red"
              onClick={() => {
                show(false);
              }}
            >
              {daLang.cancel}
            </Button>
          </Group>
        </Box>
      </Box>
    </Box>
  );
};
