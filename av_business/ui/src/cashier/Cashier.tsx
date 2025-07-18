import { lazy, Suspense, useEffect, useState } from "react";
import { MantineProvider, Box, LoadingOverlay } from "@mantine/core"
import '@mantine/core/styles.css';
import '@mantine/charts/styles.css';
import { fetchNui } from "../hooks/useNuiEvents";
import { getLang } from "../hooks/getLang";
import { useSetRecoilState } from "recoil";
import { Lang } from "../reducers/atoms";

const Customer = lazy(() => import("./components/Customer/Customer"));
const Employee = lazy(() => import("./components/Employee/Employee"));
const Orders = lazy(() => import("./components/Orders/Orders"));
const ActiveOrders = lazy(() => import("./components/ActiveOrders/ActiveOrders"));

interface Properties {
    serial: string,
    type: string,
    orders?: any,
    order?: number,
}

const Cashier = ({serial, type, orders, order}:Properties) => {
  const [loaded, setLoaded] = useState(false)
  const setLang = useSetRecoilState(Lang)
  const onPressKey = (e:any) => {
    switch (e.code) {
      case "Escape":
        fetchNui('av_business','close')
        break;
      default:
        break;
    }
  }
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
  }, []);
  useEffect(() => {
    const fetchLang = async () => {
    const resp = await getLang()
      setLang(resp)
      setTimeout(() => {
        setLoaded(true)
      }, 100);
    }
    fetchLang()
  }, [])
  
  return (
    <MantineProvider defaultColorScheme='dark'>
        <Suspense
            fallback={
              <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
                  <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
              </Box>
            }
        >
          {type == "employee" && loaded && <Employee serial={serial}/>}
          {type == "customer" && loaded && <Customer serial={serial}/>}
          {type == "orders" && loaded && <Orders serial={serial}/>}
          {type == "activeOrders" && loaded && <ActiveOrders orders={orders} order={order}/>}
        </Suspense>
    </MantineProvider>
  )
}
export default Cashier