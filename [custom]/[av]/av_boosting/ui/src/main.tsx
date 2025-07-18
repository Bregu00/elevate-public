import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import { isEnvBrowser } from "./hooks/useNuiEvents.ts";
import { RecoilRoot } from "recoil";
import "./index.css";
import "./global.css";

let root: ReactDOM.Root | null = null;

const initializeRoot = () => {
  root = ReactDOM.createRoot(document.getElementById("root")!);
};

const loadApp = (height: any) => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <App height={height} />
      </RecoilRoot>
    </React.StrictMode>
  );
};

window.addEventListener("message", (event) => {
  switch (event.data.message) {
    case "loadApp":
      loadApp(event.data.height);
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

if (isEnvBrowser()) loadApp(null); // load the main app
//if(isEnvBrowser()) loadAdmin() // load the admin panel
