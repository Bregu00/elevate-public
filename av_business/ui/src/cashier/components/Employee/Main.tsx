import { Box, Flex, Group, Text, Paper, ActionIcon} from "@mantine/core"
import {IconCheck, IconPlus, IconX } from '@tabler/icons-react';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import classes from './Employee.module.css'

type Product = {
  ingredients: string[];
  label: string;
  name: string;
  price: number;
};

const aggregateProducts = (products: Product[]): Product[] => {
  const productMap: { [key: string]: { count: number, totalPrice: number, product: Product } } = {};

  products.forEach(product => {
    const key = `${product.label}|${product.ingredients.sort().join(",")}`;
    if (!productMap[key]) {
      productMap[key] = { count: 0, totalPrice: 0, product: product };
    }
    productMap[key].count += 1;
    productMap[key].totalPrice += product.price;
  });

  const aggregatedProducts: Product[] = Object.keys(productMap).map(key => {
    const { count, totalPrice, product } = productMap[key];
    return { ...product, label: `${count} ${product.label}`, price: totalPrice };
  });

  return aggregatedProducts;
};

export const Main = ({cart, removeItem, setMenu, complete}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { cashier: lang } = daLang
  const formated = aggregateProducts(cart)
  return (
    <Box className={classes.products}>
        <Paper
            className={classes.panel}
            mt="xs"
            onClick={()=>{setMenu("new")}}
        >
            <Group p="xs">
            <ActionIcon radius={2} size={25} variant='light' color='gray.3'>
                <IconPlus style={{display: 'flex', height: "60%", width: "60%", alignItems: 'center', alignContent: 'center'}}/>
            </ActionIcon>
            <Text className={classes.glow}>{lang.add}</Text>
            </Group>
        </Paper>
        {
            cart.length > 0 &&
            <Paper
                className={classes.panel}
                mt="xs"
                mb="xs"
                onClick={()=>{complete()}}
            >
                <Group p="xs">
                <ActionIcon radius={2} size={25} variant='light' color='gray.3'>
                    <IconCheck style={{display: 'flex', height: "60%", width: "60%", alignItems: 'center', alignContent: 'center'}}/>
                </ActionIcon>
                <Text className={classes.glow}>{lang.complete}</Text>
                </Group>
            </Paper>
        }
        {formated.map((item:any, index:number) => (
            <Paper
                className={classes.product}
                display="block"
                mb={5}
                key={index}
                p="xs"
                maw={"99%"}
            >
                <Group >
                    <ActionIcon radius={2} size={25} variant='transparent' color='red' onClick={()=>{removeItem(item.name, item.ingredients)}}>
                    <IconX style={{display: 'flex', height: "60%", width: "60%", alignItems: 'center', alignContent: 'center'}}/>
                    </ActionIcon>
                    <Text fz="md" truncate c={"rgba(225,225,225,1)"}>{item.label}</Text>
                </Group>
                <Flex 
                    ml={40}
                    gap={0}
                    justify="flex-start"
                    align="flex-start"
                    direction="column"
                    wrap="wrap"
                >
                    <Text fz="xs"><a style={{fontWeight: 500, color: "rgba(225,225,225,1)"}}>{daLang.price}: </a> {`$${item.price}`}</Text>
                    <Text fz="xs" ta="left" tt="capitalize"><a style={{fontWeight: 500, color: "rgba(225,225,225,1)"}}>{daLang.ingredients}: </a>{`${(item.ingredients).join(", ")}`}</Text>
                </Flex>
            </Paper>
        ))}
    </Box>
  )
}