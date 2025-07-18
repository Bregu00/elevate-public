import { Box, Flex, Group, Text, Paper, Button} from "@mantine/core"
import classes from './Customer.module.css'
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';

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

export const Main = ({cart, buttons, handlePay}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { cashier: lang } = daLang
  const formated = aggregateProducts(cart)
  return (
    <>
    {
        cart.length > 0 ?
        <>
            <Box className={classes.products}>
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
                            <Text fz="md" truncate c={"rgba(225,225,225,1)"}>{item.label}</Text>
                        </Group>
                        <Flex 
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
            <Group mt="xs" grow>
                {buttons.map((option:any, index:number) => (
                    <Button 
                        key={index} 
                        size="xs" 
                        variant="light" 
                        color={option.color}
                        onClick={()=>{handlePay(option.account)}}
                    >
                        {option.label}
                    </Button>
                ))}
            </Group>
        </>
        :
        <Box className={classes.empty}>
            {lang.empty}
        </Box>
    }
    
    </>
  )
}