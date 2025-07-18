import { useState } from 'react';
import {useRecoilValue} from 'recoil'
import { Permissions, Lang } from "../../reducers/atoms";
import { Tooltip, UnstyledButton, Stack, rem } from '@mantine/core';
import {
  IconHome2,
  IconDeviceDesktopAnalytics,
  IconBurger,
  IconUsersGroup,
  IconSettings,
  IconClipboardList,
  IconPigMoney,
  IconPower
} from '@tabler/icons-react';
import classes from './NavbarMinimal.module.css';
import { fetchNui } from '../../hooks/useNuiEvents';

interface NavbarLinkProps {
  icon: typeof IconHome2;
  name: string;
  label: string;
  active?: boolean;
  onClick?(): void;
  color?: string
}

interface Properties {
  setCurrentTab: (option:string) => void;
  blip: boolean;
  setBlip: (arg:any) => void;
}

function NavbarLink({ icon: Icon, label, active, onClick }: NavbarLinkProps) {
  return (
    <Tooltip color="dark.6" fz="sm" label={label} position="right" transitionProps={{ duration: 0 }}>
      <UnstyledButton onClick={onClick} className={classes.link} data-active={active || undefined}>
        <Icon style={{ width: rem(20), height: rem(20) }} stroke={1.5} />
      </UnstyledButton>
    </Tooltip>
  );
}

export function NavbarMinimal({setCurrentTab, blip, setBlip}:Properties) {
  const permissions:any = useRecoilValue(Permissions)
  const lang:any = useRecoilValue(Lang)
  const [active, setActive] = useState("overview");
  const handleBlip = () => {
    setBlip(!blip)
    fetchNui("av_business", "toggleBlip", !blip)
  }
  const handleClick = (name:string) => {
    setActive(name)
    setCurrentTab(name)
  }
  const mockdata = [
    { icon: IconDeviceDesktopAnalytics, label: lang.overview_icon, name: "overview" },
    // { icon: IconPigMoney, label: lang.bank_icon, name: "bank" },
    { icon: IconBurger, label: lang.menu_icon, name: "menu" },
    { icon: IconClipboardList, label: lang.applications_icon, name: "applications" },
    { icon: IconSettings, label: lang.settings_icon, name: "settings" },
  ];
  const links = mockdata.map((link:any) => {
    if(link.name == "menu") {
      if (permissions.isRestaurant && permissions['menu']) {
        return (
          <NavbarLink
            {...link}
            key={link.name}
            active={link.name === active}
            onClick={() => handleClick(link.name)}
          />
        );
      } else {
        return null;
      }
    } else {
      if (permissions && permissions[link?.name]) {
        return (
          <NavbarLink
            {...link}
            key={link.name}
            active={link.name === active}
            onClick={() => handleClick(link.name)}
          />
        );
      } else {
        return null;
      }
    }
  });

  return (
    <nav className={classes.navbar}>
      <div className={classes.navbarMain}>
        <Stack justify="center" gap={"lg"}>
          {links}
        </Stack>
      </div>
      <Stack justify="center" gap={0} mb={"xs"}>
        <NavbarLink icon={IconPower} label={blip ? lang.blip_off : lang.blip_on} name={'blip'} active={blip} onClick={handleBlip}/>
      </Stack>
    </nav>
  );
}