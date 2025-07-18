import { useEffect, useState } from "react"
import { Box, Paper, Group, Select, Text, Button, Image, Flex, ActionIcon, LoadingOverlay } from "@mantine/core"
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents"
import { Height, Lang } from "../../../reducers/atoms";
import {useRecoilValue} from 'recoil'
import { AddProduct } from "./AddProduct";
import { EditProduct } from "./EditProduct";
import { IconEdit, IconEraser} from '@tabler/icons-react';
import classes from './Menu.module.css'
import { Confirmation } from "./Confirmation";

const parseIngredients = (ingredients: string[], replacements: { value: string; label: string }[]): string => {
  try {
    if (Array.isArray(ingredients) && ingredients.length > 0) {
      const replaced = ingredients.map((ingredient) => {
        const replacement = replacements.find((r) => r.value === ingredient);
        return replacement ? replacement.label : ingredient;
      });
      return replaced.join(', ');
    } else {
      return "N/A";
    }
  } catch (error) {
    console.error(`Failed to parse ingredients: ${ingredients}`, error);
    return "N/A";
  }
};

const Menu = () => {
  const daLang:any = useRecoilValue(Lang);
  const { menu: lang } = daLang
  const height = useRecoilValue(Height)
  const [showMenu, setShowMenu] = useState(false)
  const [showEditor, setShowEditor] = useState(false)
  const [showConfirmation, setShowConfirmation] = useState(false)
  const [currentItem, setCurrentItem] = useState({})
  const [allItems, setAllItems] = useState([])
  const [currentItems, setCurrentItems] = useState([])
  const [allTypes, setAllTypes] = useState([])
  const [allIngredients, setAllIngredients] = useState([])
  const [allAnimations, setAllAnimations] = useState([])
  const [loaded, setLoaded] = useState(false)
  const [inventory, setInventory] = useState("")
  const [maxIngredients, setMaxIngredients] = useState(5)

  useNuiEvent("updateMenu", (data:any) => {
    setAllItems(data)
    setCurrentItems(data)
  })
  const editItem = (item:any) => {
    setCurrentItem(item)
    setShowEditor(true)
  }
  const deleteItem = (item:any) => {
    setCurrentItem(item)
    setShowConfirmation(true)
  }
  const filterItems = (type:any) => {
    if(!type) {
      setCurrentItems(allItems)
      return
    };
    const res = allItems.filter((data:any) => data.type === type)
    setCurrentItems(res)
  }
  const handleDelete = (name:string) => {
    setShowConfirmation(false)
    const newItems = allItems.filter((item:any) => item.name !== name)
    setCurrentItems(newItems)
    setAllItems(newItems)
    fetchNui("av_business", "deleteItem", name)
  }
  useEffect(() => {
    const fetchItems = async() => {
      const resp = await fetchNui('av_business', "getMenu")
      if(resp) {
        setAllItems(resp.items)
        setCurrentItems(resp.items)
        setAllTypes(resp.types)
        setAllIngredients(resp.ingredients)
        setAllAnimations(resp.animations)
        setInventory(resp.inventory)
        setMaxIngredients(resp.maxIngredients)
        setTimeout(() => {
          setLoaded(true)
        }, 100);
      } else {
        console.log("An error ocured while trying to fetch the menu tab, report it to an admin.")
        console.log("An error ocured while trying to fetch the menu tab, report it to an admin.")
        console.log("An error ocured while trying to fetch the menu tab, report it to an admin.")
      }
    }
    fetchItems()
  }, [])
  
  return <>
    {showMenu && <AddProduct types={allTypes} show={setShowMenu} />}
    {showEditor && <EditProduct types={allTypes} item={currentItem} show={setShowEditor} animations={allAnimations} ingredients={allIngredients} maxIngredients={maxIngredients}/>}
    {showConfirmation && <Confirmation item={currentItem} show={setShowConfirmation} handleDelete={handleDelete}/>}
    {!loaded ?
      <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
        <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
      </Box>
      :
      <Box h={height > 900 ? `calc(100%)` : `calc(95%)`}>
        <Group justify="space-between" align="center" display={"flex"}>
          <Text fz={"md"} fw={500}>{`${currentItems.length} Product(s)`}</Text>
          <Group>
            <Button size="xs" variant="light" color="teal.4" onClick={()=>{setShowMenu(true)}}>{lang.add}</Button>
            <Select
              placeholder={daLang.filter}
              data={allTypes}
              classNames={{
                  option: classes.option
              }}
              styles={{
                  input: {
                      backgroundColor: "rgba(39, 43, 54, 0.15)"
                  },
                  dropdown: {
                      backgroundColor: "rgba(39, 43, 54, 0.9)"
                  }
              }}
              onChange={(e)=>{filterItems(e)}}
              size="xs"
            />
          </Group>
        </Group>
        <Box mt={"md"} className={classes.itemContainer} h={height > 900 ? `calc(90%)` : `calc(80%)`}>
          {currentItems.map((item:any, index) => (
            <Paper className={classes.item} key={index} mb={"xs"} p={"xs"}>
              <Group grow justify='space-between' w={"100%"}>
                <Image src={item.image ? item.image : `${`https://cfx-nui-${inventory}${item?.name}.png`}`} w={40} h={40} fallbackSrc="https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/cono.png"/>
                  <Flex
                    justify="center"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                    w={100}
                    style={{overflow: "hidden", textOverflow: "ellipsis"}}
                  >
                    <Text fz="sm" c='dimmed'>{lang.product}</Text>
                    <Text fz="sm" truncate maw={'65%'}>{item.label}</Text>
                  </Flex>
                <Flex
                  justify="center"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Text fz="sm" c='dimmed'>{lang.description}</Text>
                  <Text fz="sm">{item.description}</Text>
                </Flex>
                <Flex
                  justify="center"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Text fz="sm" c='dimmed'>{daLang.ingredients}</Text>
                  <Text fz="sm" >{item.ingredients ? parseIngredients(item.ingredients, allIngredients) : `N/A`}</Text>
                </Flex>
                <Flex
                  justify="center"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Text fz="sm" c='dimmed'>{lang.suggestedPrice}</Text>
                  <Text fz="sm" >{item.price ? `$${(item.price).toLocaleString("en-US")}` : 0}</Text>
                </Flex>
                <Flex
                  justify="center"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Text fz="sm" c='dimmed'>{daLang.type}</Text>
                  <Text fz="sm"  tt={"capitalize"}>{item.type}</Text>
                </Flex>
                <Group justify="center">
                  <ActionIcon size="sm" variant="light" color="cyan.4" onClick={()=>{editItem(item)}}>
                    <IconEdit style={{width: "70%", height: "70%"}}/>
                  </ActionIcon>
                  <ActionIcon size="sm" variant="light" color="red.4" onClick={()=>{deleteItem(item)}}>
                    <IconEraser style={{width: "70%", height: "70%"}}/>
                  </ActionIcon>
                </Group>
              </Group>
            </Paper>
          ))}
        </Box>
      </Box>
    }
  </>
}

export default Menu