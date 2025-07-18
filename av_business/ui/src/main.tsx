import '@mantine/core/styles.css';
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import {isEnvBrowser} from "./hooks/useNuiEvents.ts";
import {RecoilRoot} from 'recoil';
import './index.css'
import './global.css'
import Cashier from './cashier/Cashier.tsx';
import { Admin } from './admin/Admin.tsx';

let root: ReactDOM.Root | null = null;

const initializeRoot = () => {
  root = ReactDOM.createRoot(document.getElementById("root")!);
};

const loadApp = (height: any) => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <App height={height}/>
      </RecoilRoot>
    </React.StrictMode>
  );
};

const loadCashier = (serial: string, type: string, orders:any, order:number) => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <Cashier serial={serial} type={type} orders={orders} order={order}/>
      </RecoilRoot>
    </React.StrictMode>
  );
};

const loadAdmin = (zones: any) => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <Admin zones={zones}/>
      </RecoilRoot>
    </React.StrictMode>
  );
};

window.addEventListener("message", (event) => {
  switch (event.data.message) {
    case "admin":
      loadAdmin(event.data.zones);
      break;
    case "loadApp":
      loadApp(event.data.height);
      break;
    case "cashier":
      loadCashier(event.data.serial, event.data.type, event.data.orders, event.data.order);
      break;
    case "close":
      if (root) {
        root.unmount();
        root = null;
      }
      break;
    default:
      break;
  }
});


//if(isEnvBrowser()) loadApp(null) // load the business app
//if(isEnvBrowser()) loadCashier("123", "orders", [], 1) // load the cashier interface
//if(isEnvBrowser()) loadAdmin() // load the cashier interface