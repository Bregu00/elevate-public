import { useState } from 'react';
import { Group, Box, Collapse, ThemeIcon, Text, UnstyledButton, rem } from '@mantine/core';
import { IconEdit, IconChevronRight } from '@tabler/icons-react';
import classes from './NavbarLinksGroup.module.css';

interface LinksGroupProps {
  job: string;
  label: string;
  initiallyOpened?: boolean;
  links?: { label: string; action: string }[];
  action: (job:string, action:string) => void;
}

export function LinksGroup({ job, label, initiallyOpened, links, action }: LinksGroupProps) {
  const hasLinks = Array.isArray(links);
  const [opened, setOpened] = useState(initiallyOpened || false);
  const [activeLink, setActiveLink] = useState("")
  const items = (hasLinks ? links : []).map((link) => (
    <Text<'a'>
      component="a"
      className={classes.link}
      key={link.action}
      onClick={()=>{
        setActiveLink(`${job}-${link.action}`)
        action(job, link.action)
      }}
      truncate
      style={{
        backgroundColor: activeLink == `${job}-${link.action}` ? "rgba(255,255,255,0.15)" : "transparent",
        color: activeLink == `${job}-${link.action}` ? "white" : "unset"
      }}
    >
      {link.label}
    </Text>
  ));

  return (
    <>
      <UnstyledButton onClick={() => setOpened((o) => !o)} className={classes.control}>
        <Group justify="space-between" gap={0}>
          <Box style={{ display: 'flex', alignItems: 'center' }}>
            <ThemeIcon variant="subtle" size={16}>
              <IconEdit style={{ width: rem(18), height: rem(18) }} />
            </ThemeIcon>
            <Box ml="md" style={{overflow: "hidden", maxWidth: "100px"}}>{label}</Box>
          </Box>
          <IconChevronRight
            className={classes.chevron}
            stroke={1.5}
            style={{
              width: rem(16),
              height: rem(16),
              transform: opened ? 'rotate(-90deg)' : 'none',
            }}
          />
        </Group>
      </UnstyledButton>
      <Collapse in={opened}>{items}</Collapse>
    </>
  );
}