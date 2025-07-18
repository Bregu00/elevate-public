import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import { isEnvBrowser } from "./hooks/useNuiEvents.ts";
import { RecoilRoot } from "recoil";
import App from "./App.tsx";
import { RacingPanel } from "./RacingPanel.tsx";
import { Admin } from "./components/Admin/Admin.tsx";
import { Underground } from "./components/Underground/Underground.tsx";
import "./index.css";
import "./global.css";

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

const loadRacingUI = () => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <RacingPanel />
    </React.StrictMode>
  );
};

const loadAdmin = () => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <Admin />
    </React.StrictMode>
  );
};

const loadUnderground = () => {
  if (!root) initializeRoot();
  root?.render(
    <React.StrictMode>
      <Underground />
    </React.StrictMode>
  );
};

window.addEventListener("message", (event) => {
  switch (event.data.message) {
    case "loadApp":
      loadApp();
      break;
    case "loadRacingUI":
      loadRacingUI();
      break;
    case "admin":
      loadAdmin();
      break;
    case "underground":
      loadUnderground();
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
//if (isEnvBrowser()) loadCountdown(); // load countdown
//if (isEnvBrowser()) loadRacingUI(); // load racing ui
//if (isEnvBrowser()) loadUnderground(); // load underground
