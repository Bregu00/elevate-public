import { useState, useEffect } from 'react';
import { Box, Group, Text, Flex, Divider, LoadingOverlay } from "@mantine/core";
import classes from './Customer.module.css';
import { Main } from "./Main";
import { fetchNui } from '../../../hooks/useNuiEvents';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../../reducers/atoms';

interface Props {
  serial: string;
}

const Customer = ({ serial }: Props) => {
  const daLang:any = useRecoilValue(Lang);
  const { cashier: lang } = daLang
  const [cart, setCart] = useState<any[]>([]);
  const [buttons, setButtons] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [order, setOrder] = useState("");
  const [loaded, setLoaded] = useState(false);

  const handlePay = async (account: string) => {
    const resp = await fetchNui("av_business", "pay", { account, serial });
    if (resp) {
      setCart([]);
    }
  };

  useEffect(() => {
    let isMounted = true;
    const getCart = async () => {
      try {
        const resp = await fetchNui("av_business", "getCart", serial);
        if (resp && isMounted) {
          if (resp.cart) {
            setCart(resp.cart);
            const res = resp.cart.reduce((total: number, product: any) => total + product.price, 0);
            setTotal(res);
          }
          setButtons(resp.buttons);
          if (resp.order) {
            setOrder(resp.order);
          }
          setTimeout(() => {
            setLoaded(true);
          }, 100);
        } else {
          console.error("[ERROR] getCart returned null, try again or report it to your server admin.");
        }
      } catch (error) {
        console.error("[ERROR] getCart encountered an error:", error);
      }
    };

    getCart();
  }, []);
  return (
    <>
      {loaded ? (
        <Box className={classes.container}>
          <Box className={classes.cashier}>
            <Box className={classes.content}>
              <Box className={classes.box}>
                <Group justify="space-between" p={"xs"}>
                  <Text fz="lg" fw={500} className={classes.glow}>{`${daLang.order} #${order}`}</Text>
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
                <Main cart={cart} buttons={buttons} handlePay={handlePay} />
              </Box>
            </Box>
          </Box>
        </Box>
      ) : (
        <Box className={classes.container}>
          <Box className={classes.cashier}>
            <Box className={classes.content}>
              <Box className={classes.box}>
                <Box style={{ display: "flex", alignContent: "center", alignItems: "center" }}>
                  <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots' }} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }} />
                </Box>
              </Box>
            </Box>
          </Box>
        </Box>
      )}
    </>
  );
};

export default Customer;
