import { Tabs, rem } from "@mantine/core";
import { IconUsers, IconPencilPlus } from "@tabler/icons-react";
import classes from "./style.module.css";

interface Properties {
  activeTab: string | null;
  setTab: (option: string | null) => void;
  lang: any;
}

export const TabComponent = ({ activeTab, setTab, lang }: Properties) => {
  const iconStyle = { width: rem(12), height: rem(12) };
  return (
    <Tabs
      variant="default"
      defaultValue="crews"
      color="rgb(205, 207, 102)"
      classNames={classes}
      allowTabDeactivation={false}
      onChange={(e) => {
        setTab(e);
      }}
    >
      <Tabs.List>
        <Tabs.Tab value="crews" leftSection={<IconUsers style={iconStyle} />}>
          {lang.admin.crewTab}
        </Tabs.Tab>
        {activeTab == "crews" && (
          <Tabs.Tab
            value="newCrew"
            leftSection={<IconPencilPlus style={iconStyle} />}
            ml="auto"
            c="yellow.2"
          >
            {lang.admin.newCrew}
          </Tabs.Tab>
        )}
      </Tabs.List>
    </Tabs>
  );
};
