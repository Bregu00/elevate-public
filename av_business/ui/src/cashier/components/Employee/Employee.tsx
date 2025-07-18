import { useEffect, useState } from 'react'
import { Box, Group, Divider, Text, Flex, Avatar } from "@mantine/core"
import { Main } from './Main';
import { Products } from './Products';
import { IconCheck } from '@tabler/icons-react';
import { fetchNui } from '../../../hooks/useNuiEvents';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import classes from './Employee.module.css'

interface Props {
  serial: string
}

type Product = {
  ingredients: string[];
  label: string;
  name: string;
  price: number;
};

const removeProduct = (name: string, ingredients: string[], products: Product[]): Product[] => {
  const productIndex = products.findIndex(product => 
    product.name === name && arraysEqual(product.ingredients, ingredients)
  );
  
  if (productIndex !== -1) {
    products.splice(productIndex, 1);
  }
  
  return [...products];
};

const arraysEqual = (a: string[], b: string[]): boolean => {
  if (a.length !== b.length) return false;
  const sortedA = a.slice().sort();
  const sortedB = b.slice().sort();
  return sortedA.every((value, index) => value === sortedB[index]);
};

const Employee = ({serial}:Props) => {
  const daLang:any = useRecoilValue(Lang);
  const { cashier: lang } = daLang
  const [success, setSuccess] = useState(false)
  const [order, setOrder] = useState("")
  const [currentMenu, setCurrentMenu] = useState("main")
  const [allProducts, setAllProducts] = useState([])
  const [total, setTotal] = useState(0)
  const [cart, setCart] = useState<any>([])

  const removeItem = (name:string, ingredients:[]) => {
    const newCart = removeProduct(name, ingredients, cart)
    setCart(newCart)
  }

  const addItem = (item:any) => {
    const newCart = [...cart, item]
    setCart(newCart)
  }

  const handleComplete = async() => {
    const resp = await fetchNui("av_business", "sendOrder", {serial, cart, total})
    if(resp){
      setOrder(resp)
      setSuccess(true)
    }
  }
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getProducts")
      const ordered = resp.sort((a:any, b:any) => a.label.localeCompare(b.label))
      setAllProducts(ordered)
    }
    fetchData()
  }, [])
  useEffect(() => {
    const res = cart.reduce((total:any, product:any) => total + product.price, 0)
    setTotal(res)
  }, [cart])
  
  return (
    <Box className={classes.container}>
      <Box className={classes.cashier}>
       <Box className={classes.content}>
          <Box className={classes.box}>
            {!success ? 
              <>
                <Group justify='space-between' p={"xs"}>
                  <Text fz="lg" fw={500} className={classes.glow}>{lang.header}</Text>
                  <Flex
                    gap={0}
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                  >
                    <Text fz="sm" c="gray.5" className={classes.glow}>{`${lang.products}: ${cart.length}`}</Text>
                    <Text fz="sm" c="gray.5" className={classes.glow}>{`${lang.total}: $${total}`}</Text>
                    </Flex>
                </Group>
                <Divider />
                {currentMenu == "main" ?
                  <Main cart={cart} removeItem={removeItem} setMenu={setCurrentMenu} complete={handleComplete}/>
                  :
                  <Products setMenu={setCurrentMenu} allProducts={allProducts} addCart={addItem}/>
                }
              </>
              :
              <Box style={{display: "flex", justifyContent: "center", alignContent: "center", alignItems: "center", height: "60vh"}}>
                <Box display={"block"} style={{display: "flex", justifyContent: "center", textAlign: "center"}}>
                  <Avatar color="teal" radius="xl" style={{boxShadow: "0px 1px 5px rgba(56,217,169,0.15)", textAlign: "center", marginLeft: "auto", marginRight: "auto"}} size={"md"}>
                    <IconCheck size="1.25rem" />
                  </Avatar>
                  <Text mt="xs" c="gray.5" className={classes.glow}>{lang.waiting}</Text>
                  <Text fw={500} c="gray.2" className={classes.glow}>{`${daLang.order} #${order}`}</Text>
                </Box>
              </Box>
            }
          </Box>
        </Box>
      </Box>
    </Box>
  )
}
export default Employee