import { Box, Button, Text, Flex, Accordion, Group} from "@mantine/core"
import classes from './Orders.module.css'
import {IconClock} from "@tabler/icons-react"
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';
import { fetchNui } from "../../../hooks/useNuiEvents";

export const formatTimestamp = (timestamp: number): string => {
    const date = new Date(timestamp * 1000);
    const hours = ('0' + date.getHours()).slice(-2);
    const minutes = ('0' + date.getMinutes()).slice(-2);
    return `${hours}:${minutes}`;
}

type Product = {
  name: string;
  label: string;
  ingredients: string[];
};

const formatProducts = (products: Product[]): Product[] => {
  const productMap: { [key: string]: { name: string, count: number, ingredients: string[] } } = {};

  products.forEach(product => {
    const key = `${product.label}|${product.ingredients.sort().join(",")}`;
    if (!productMap[key]) {
      productMap[key] = { count: 0, ingredients: product.ingredients, name: product.name };
    }
    productMap[key].count += 1;
  });

  const aggregatedProducts: Product[] = Object.keys(productMap).map(key => {
    const [label] = key.split("|");
    const { count, ingredients, name } = productMap[key];
    return { label: `${count} ${label}`, ingredients, name };
  });

  return aggregatedProducts;
};

export const Main = ({allOrders, deleteOrder}:any) => {
    const daLang:any = useRecoilValue(Lang);
    const { orders: lang } = daLang
    const handleDelete = (e:any) => {
        deleteOrder(e.order)
        fetchNui("av_business", "deleteOrder", e.order)
    }
    const handleAdd = (e:any) => {
        fetchNui("av_business", "addQueue", e)
    }
  return (
    <>
    {
        allOrders.length > 0 ?
        <>
            <Box className={classes.products}>
                {allOrders.map((item:any, index:number) => (
                    <Accordion radius="xs" key={index}>
                    <Accordion.Item 
                        key={item.order} 
                        value={String(item.order)} 
                        mt="xs"
                        >
                            <Accordion.Control 
                                classNames={{
                                    control: classes.control
                                }}
                            >
                                <Group gap="xs" justify="space-between">
                                    <Text>Order #{item.order}</Text>
                                    <>
                                        {item.queue ? <IconClock style={{width: "5%", height: "5%", marginRight: "5%"}} color="cyan"/> : <></>}
                                    </>
                                </Group>
                            </Accordion.Control>
                            <Accordion.Panel bg={"linear-gradient(0deg, rgba(0,0,0,0.0) 0%, rgba(25,25,25,0.25) 25%, rgba(40,40,40,0.8) 100%)"}>
                                <Flex
                                    mih={50}
                                    gap="xs"
                                    justify="flex-start"
                                    align="flex-start"
                                    direction="column"
                                    wrap="wrap"
                                    mt={5}
                                    
                                >
                                    {formatProducts(item.cart).map((product: any, index: number) => (
                                        <Text size="xs" key={index}>
                                            - <strong>{product.label}</strong> {product.ingredients.length > 0 ? `[${product.ingredients.join(', ')}]` : ""}
                                        </Text>
                                    ))}
                                </Flex>
                                <Box mt={"xs"} style={{display: "flex", right: "0", textAlign: "right", justifyContent: "end"}}>
                                    <Button 
                                        size="xs" 
                                        variant="subtle" 
                                        color="red" 
                                        onClick={()=>{handleDelete(item)}}
                                        mr={"xs"}
                                    >
                                        {lang.complete}
                                    </Button>
                                    <Button 
                                        size="xs" 
                                        variant="light" 
                                        color="cyan.3" 
                                        onClick={()=>{handleAdd(item)}}
                                    >
                                        {lang.queue}
                                    </Button>
                                </Box>
                            </Accordion.Panel>
                        </Accordion.Item>
                    </Accordion>
                ))}
            </Box>
        </>
        :
        <Box className={classes.empty}>
            {lang.empty}
        </Box>
    }
    
    </>
  )
}