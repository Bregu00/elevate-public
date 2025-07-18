import { Tabs } from '@mantine/core';
import { useRecoilValue } from 'recoil';
import { Lang } from '../../reducers/atoms';
import classes from './NavbarStyle.module.css'

interface NavProperties {
  currentTab: string | null,
  setCurrentTab: (option: string | null) => void;
}

export const Navbar = ({currentTab, setCurrentTab}:NavProperties) => {
  const lang:any = useRecoilValue(Lang)
  return (
    <Tabs 
      value={currentTab} 
      onChange={setCurrentTab} 
      className='navbar' 
      color='cyan.4'
      classNames={{
        tab: classes.tab
      }}
    >
      <Tabs.List>
        <Tabs.Tab value="contracts">{lang.tabs.contracts}</Tabs.Tab>
        <Tabs.Tab value="groups">{lang.tabs.groups}</Tabs.Tab>
        <Tabs.Tab value="auctions">{lang.tabs.auctions}</Tabs.Tab>
        <Tabs.Tab value="leaderboard">{lang.tabs.leaderboard}</Tabs.Tab>
      </Tabs.List>
    </Tabs>
  )
}
