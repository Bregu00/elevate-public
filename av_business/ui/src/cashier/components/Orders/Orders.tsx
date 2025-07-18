import { useState, useEffect } from "react"
import { Box, Text, Divider, LoadingOverlay } from "@mantine/core"
import { fetchNui } from "../../../hooks/useNuiEvents"
import { Main } from "./Main"
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import classes from './Orders.module.css'

type Ingredient = {
  value: string;
  label: string;
};

type CartItem = {
  name: string;
  label: string;
  ingredients: string[];
};

type Order = {
  generated: number;
  order: number;
  cart: CartItem[];
  queue: boolean;
};

const replaceIngredients = (orders: Order[], ingredients: Ingredient[]): Order[] => {
  const ingredientMap = ingredients.reduce((map, ingredient) => {
    map[ingredient.value] = ingredient.label;
    return map;
  }, {} as { [key: string]: string });

  return orders.map(order => {
    return {
      ...order,
      cart: order.cart.map(cartItem => {
        return {
          ...cartItem,
          ingredients: cartItem.ingredients.map(ingredient => ingredientMap[ingredient] || ingredient)
        };
      })
    };
  });
};

const Orders = ({serial}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { orders: lang } = daLang
  const [loaded, setLoaded] = useState(false)
  const [allOrders, setAllOrders] = useState<Order[]>([])
  
  const deleteOrder = (orderNumber:number) => {
    const updatedOrders = allOrders.filter(order => order?.order !== orderNumber);
    setAllOrders(updatedOrders);
  }
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getOrders", serial)
      if (resp) {
        const ingredients = resp.ingredients
        const orders = replaceIngredients(resp.orders, ingredients)
        setAllOrders(orders)
        setTimeout(() => {
          setLoaded(true)
        }, 100);
      }
    }
    fetchData()
    setTimeout(() => {
          setLoaded(true)
        }, 100);
  }, [])
  
  return (
    <>
      {
        loaded ?
          <Box className={classes.container}>
            <Box className={classes.cashier}>
            <Box className={classes.content}>
                <Box className={classes.box}>
                  <Text fz="lg" fw={500} className={classes.glow} ta="center">{`${allOrders.length} ${lang.header}`}</Text>
                  <Divider />
                  <Main allOrders={allOrders} deleteOrder={deleteOrder}/>
                </Box>
              </Box>
            </Box>
          </Box>
        :
        <Box className={classes.container}>
          <Box className={classes.cashier}>
            <Box className={classes.content}>
              <Box className={classes.box}>
                <Box style={{display: "flex", alignContent: "center", alignItems: "center"}}>
                  <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
                </Box>
              </Box>
            </Box>
          </Box>
        </Box>
      }
    </>
  )
}

export default Orders
