import "@mantine/core/styles.css";
import React from "react";
import ReactDOM from "react-dom/client";
import { RecoilRoot } from "recoil";
import { Listeners } from "./Listeners";
import "./index.css";
import "./global.css";
import { Components } from "./Components.tsx";

const rootElement = document.getElementById("root");
const root = ReactDOM.createRoot(rootElement!);

root.render(
  <React.StrictMode>
    <RecoilRoot>
      <Listeners />
      <Components />
    </RecoilRoot>
  </React.StrictMode>
);
