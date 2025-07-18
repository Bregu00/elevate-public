import { ScrollArea, Button, Group, Title } from '@mantine/core';
import { LinksGroup } from './NavbarLinksGroup';
import classes from './Navbar.module.css';
import { fetchNui } from '../../../hooks/useNuiEvents';
import { useRecoilValue } from "recoil";
import { Lang } from '../../../reducers/atoms';

export const NavbarNested = ({action, options}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { admin: lang } = daLang
  const links = options.map((item:any) => <LinksGroup {...item} action={action} key={item.label} />);
  const newZone = () => {
    fetchNui("av_business", "newZone")
  }
  return (
    <nav className={classes.navbar}>
      <Title className={classes.header} order={4} c="teal.3">
        {lang.header}
      </Title>
      <ScrollArea className={classes.links}>
        <div className={classes.linksInner}>{links}</div>
      </ScrollArea>

      <Group className={classes.footer} grow>
        <Button size='xs' color='teal.6' onClick={()=>{newZone()}}>{lang.newZone}</Button>
      </Group>
    </nav>
  );
}