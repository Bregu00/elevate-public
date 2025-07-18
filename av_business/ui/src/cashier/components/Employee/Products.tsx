import { useEffect, useState } from 'react'
import { Box, Paper, Group, Accordion, ActionIcon, Text, Checkbox, Button} from "@mantine/core"
import {IconArrowLeft} from '@tabler/icons-react';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import classes from './Products.module.css'
import { fetchNui } from '../../../hooks/useNuiEvents';

interface Properties {
    name: string,
    label: string,
    ingredients: string[],
    price: number
}

interface Ingredient {
  value: string;
  label: string;
  jobs: string[] | false;
  type: string[];
}

type GhostList = {
  [itemName: string]: string[];
};


const defItem:Properties = {
    name: "", label: "", ingredients: [], price: 0
}

function getIngredientLabel(ingredients: Ingredient[], input: string): string {
  const ingredient = ingredients.find(item => item.value === input);
  return ingredient ? ingredient.label : input;
}

export const Products = ({allProducts, setMenu, addCart}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { cashier: lang } = daLang
  const [loaded, setLoaded] = useState(false)
  const [allIngredients, setAllIngredients] = useState([])
  const [item, setItem] = useState<Properties>(defItem)
  const [ghostItems, setGhostItems] = useState<GhostList>({})

  const handleChange = (item:any) => {
    if(!item) {
        setItem(defItem)
        setGhostItems({})
        return
    }
    const product = allProducts.find((product:any) => product.name === item);
    if (!product) {
        return;
    }
    const res = { ...product, ingredients: [] }
    setItem(res)
  }

  const handleIngredients = (name:string, status:boolean) => {
    if (status) {
      if (!item.ingredients.includes(name)) {
        setItem(prevItem => ({
          ...prevItem,
          ingredients: [...prevItem.ingredients, name]
        }));
      }
    } else {
      setItem(prevItem => ({
        ...prevItem,
        ingredients: prevItem.ingredients.filter(ingredient => ingredient !== name)
      }));
    }
    const ghostList = { ...ghostItems }
    if (status) {
        const ingredients = ghostList[item.name] || [];
        if (!ingredients.includes(name)) {
          ingredients.push(name);
        }
        ghostList[item.name] = ingredients;
      } else {
        if (ghostList[item.name]) {
          ghostList[item.name] = ghostList[item.name].filter(i => i !== name);
        }
      }
    setGhostItems(ghostList)
  }
  
  const exists = (item:string, ingredient:string) => {
    if (ghostItems[item]) {
        return ghostItems[item].includes(ingredient);
    }
    return false;
  }
  useEffect(() => {
    const fetchIngredients = async () => {
      const resp = await fetchNui("av_business", "getIngredients")
      setAllIngredients(resp)
      setLoaded(true)
    }
    fetchIngredients()
  }, [])
  if(!loaded) return <></>
  return <>
    <Paper
        className={classes.panel}
        mt="xs"
        onClick={()=>{setMenu('main')}}
    >
        <Group p="xs">
            <ActionIcon radius={2} size={25} variant='light' color='gray.3'>
                <IconArrowLeft style={{display: 'flex', height: "60%", width: "60%", alignItems: 'center', alignContent: 'center'}}/>
            </ActionIcon>
            <Text className={classes.glow}>{lang.return}</Text>
        </Group>
    </Paper>
    <Accordion radius="xs" onChange={(e)=>{handleChange(e)}}>
        {allProducts?.map((product:any) => (
            <Accordion.Item 
                key={product.name} 
                value={product.name} 
                mt="xs"
            >
                <Accordion.Control 
                    classNames={{
                        control: classes.control
                    }}
                >
                    {product.label}
                </Accordion.Control>
                <Accordion.Panel className={classes.accordionPanel}>
                    <Text fz="xs"><a style={{fontWeight: 500, color: "rgba(225,225,225,1)"}}>{daLang.price}: </a> {`$${product.price ? product.price : 0}`}</Text>
                    <Text fz="xs" fw={500} c="rgba(225,225,225,1)">{daLang.ingredients}:</Text>
                    <Group mt="xs">
                        {product.ingredients?.map((ingredient:any,index:number) => (
                            <Checkbox
                                key={index}
                                label={getIngredientLabel(allIngredients, ingredient)}
                                size="xs"
                                color="cyan"
                                classNames={{input: classes.input}}
                                onChange={(event) => handleIngredients(ingredient, event.currentTarget.checked)}
                                radius="xl"
                                checked={exists(product.name, ingredient)}
                            />
                        ))}
                    </Group>
                    <Box mt={"xs"} style={{display: "flex", right: "0", textAlign: "right", justifyContent: "end"}}>
                        <Button 
                            size="xs" 
                            variant="light" 
                            color="cyan.3" 
                            onClick={()=>{addCart(item)}}
                        >
                          {lang.addCart}
                        </Button>
                    </Box>
                </Accordion.Panel>
            </Accordion.Item>
        ))}
    </Accordion>
  </>
}