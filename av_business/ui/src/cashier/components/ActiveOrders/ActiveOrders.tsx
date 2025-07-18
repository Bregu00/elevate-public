import { Box, Text, Flex } from "@mantine/core"
import classes from './Orders.module.css'
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

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

const ActiveOrders = ({orders, order}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const formated = formatProducts(orders)
  return (
    <Box className={classes.container}>
        <Box className={classes.box}>
            <Box className={classes.title}>
                <Text ta="center">{`${daLang.order} #${order}`}</Text>
            </Box>
            <Flex
                className={classes.items}
                mih={50}
                gap="xs"
                justify="flex-start"
                align="flex-start"
                direction="column"
                wrap="wrap"
                mb={5}
                p="xs"
            >
                {formated.map((product: any, index: number) => (
                    <Text size="xs" key={index} mt={4}>
                        - <strong>{product.label}</strong> {product.ingredients.length > 0 ? `[${product.ingredients.join(', ')}]` : ""}
                    </Text>
                ))}
            </Flex>
        </Box>
    </Box>
  )
}

export default ActiveOrders