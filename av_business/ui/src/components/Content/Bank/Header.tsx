import { Box, Grid, Text, Progress, Card, ActionIcon, Group, Tooltip } from "@mantine/core"
import { IconTransferIn, IconTransferOut, IconEdit } from '@tabler/icons-react';
import classes from './Header.module.css'
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

export const Header = ({title, text, value, event, show, funds, generated, goal}:any) => {
  const daLang:any = useRecoilValue(Lang);
  const { bank: lang } = daLang
  const handleClick = (type:string) => {
    switch (type) {
      case 'add':
        title(lang.add_button)
        text(lang.add_text)
        value(0)
        event("deposit")
        show(true)
        break;
      case 'withdraw':
        title(lang.remove_button)
        text(`${lang.remove_text} (Max: $${(funds).toLocaleString("en-US")})`)
        value(0)
        event("withdraw")
        show(true)
        break
      case 'goal':
        title(lang.monthlyGoal)
        text(lang.goal_text)
        value(goal)
        event("goal")
        show(true)
        break
      default:
        break;
    }
  }
  return (
    <Box>
      <Grid w={"100%"} justify='start'>
        <Grid.Col span={3}>
          <Card withBorder radius="md" p="sm" className={classes.card} h={85}>
            <Text fz="xs" tt="uppercase" fw={500} className={classes.title}>
              {lang.availableFunds}
            </Text>
            <Group mt="sm" justify="space-between">
              <Text fz="sm" fw={500} className={classes.stats}>
                {`$${(funds).toLocaleString("en-US")}`}
              </Text>
              <Group gap={"xs"}>
                <Tooltip label={lang.add_button} color="dark.4" fz={"xs"}>
                  <ActionIcon size="xs" variant="subtle" color="teal" onClick={()=>{handleClick("add")}}>
                    <IconTransferIn style={{height: "80%", width: "80%"}}/>
                  </ActionIcon>
                </Tooltip>
                <Tooltip label={lang.remove_button} color="dark.4" fz={"xs"}>
                  <ActionIcon size="xs" variant="subtle" color="red" onClick={()=>{handleClick("withdraw")}}>
                    <IconTransferOut style={{height: "80%", width: "80%"}}/>
                  </ActionIcon>
                </Tooltip>
              </Group>
            </Group>
          </Card>
        </Grid.Col>
        <Grid.Col span={4} w={"100%"}>
          <Card withBorder radius="md" p="sm" className={classes.card} h={85}>
            <Text fz="xs" tt="uppercase" fw={500} className={classes.title}>
              {lang.monthlyGoal}
            </Text>
            <Group justify="space-between">
              <Text fz="sm" fw={500} className={classes.stats}>
                {` $${(generated).toLocaleString("en-US")} / $${(goal).toLocaleString("en-US")}`}
              </Text>
              <Tooltip label={lang.edit_goal} color="dark.4" fz={"xs"}>
                <ActionIcon size="xs" variant="subtle" color="cyan" onClick={()=>{handleClick("goal")}}>
                  <IconEdit style={{height: "80%", width: "80%"}}/>
                </ActionIcon>
              </Tooltip>
            </Group>
            <Progress
              value={generated / goal * 100}
              mt="xs"
              size="xs"
              radius="xl"
              classNames={{
                root: classes.progressTrack,
                section: classes.progressSection,
              }}
            />
          </Card>
        </Grid.Col>
      </Grid>
    </Box>
  )
}