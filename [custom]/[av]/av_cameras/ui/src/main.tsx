import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import { isEnvBrowser } from "./hooks/useNuiEvents.ts";
import { RecoilRoot } from "recoil";
import App from "./App.tsx";
import View from "./View.tsx";
import "./index.css";
import "./global.css";
import { CameraType } from "./types/types.ts";

let root: ReactDOM.Root | null = null;

const initializeRoot = () => {
  root = ReactDOM.createRoot(document.getElementById("root")!);
};

const loadApp = () => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <App />
      </RecoilRoot>
    </React.StrictMode>
  );
};

const loadOverlay = (camera: CameraType | null) => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RecoilRoot>
        <View camera={camera} />
      </RecoilRoot>
    </React.StrictMode>
  );
};

window.addEventListener("message", (event) => {
  switch (event.data.message) {
    case "loadApp":
      loadApp();
      break;
    case "overlay":
      loadOverlay(event.data.data);
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

if (isEnvBrowser()) loadApp(); // load main app
//if (isEnvBrowser()) loadOverlay(null); // load overlay
