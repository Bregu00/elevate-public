import { Group, Paper, Grid, Text } from '@mantine/core';
import { useRecoilValue } from 'recoil';
import { Permissions, RestData, Lang } from "../../../../reducers/atoms";
import {
  IconPigMoney,
  IconUsersGroup,
  IconReceipt2,
  IconCoin,
} from '@tabler/icons-react';
import classes from './StatsGrid.module.css';
import { useViewportWidth } from '../../../../hooks/windowResize';

const icons:any = {
  funds: IconPigMoney,
  employees: IconUsersGroup,
  receipt: IconReceipt2,
  coin: IconCoin,
};

export const StatsGrid = () => {
  const permissions = useRecoilValue(Permissions)
  const restData:any = useRecoilValue(RestData)
  const { overview: lang }:any = useRecoilValue(Lang);
  const width = useViewportWidth()
  const data = [
    { title: lang.todayOrders, icon: 'receipt', value: restData?.todayOrders ? restData.todayOrders : 0, type: "number", compare: true, permission: 'isRestaurant'},
    { title: lang.todayIncome, icon: 'coin', value: restData?.todayIncome ? restData.todayIncome : 0, type: "money", compare: false, permission: "bank" },
    { title: lang.totalEmployees, icon: 'employees', value: restData?.employees ? restData.employees : 1, type: "number", compare: false, permission: "employees"},
    { title: lang.availableFunds, icon: 'funds', value: restData?.funds ? restData.funds : 0, type:  "money", compare: false, permission: "bank" },
  ];
  const filteredData = data.filter((stat: any) => stat.permission && permissions[stat.permission]);
  const stats = filteredData.map((stat: any) => {
    const Icon = icons[stat.icon];
    return (
      <Grid.Col span={3} w={"100%"} key={stat.title}>
        <Paper p="sm" bg={"rgba(39, 43, 54, 0.3)"} style={{ border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px" }}>
          <Group justify="space-between">
            <Text size="xs" c="dimmed" className={classes.title} truncate>
              {stat.title}
            </Text>
            {width > 1290 && <Icon className={classes.icon} size="1.4rem" stroke={1.5} />}

          </Group>
          {stat.compare ?
            <Group align="flex-end" gap="xs" mt={5}>
              <Text className={classes.value} truncate>{stat.type == "number" ? stat.value : `$${(stat.value).toLocaleString('en-US')}`}</Text>
            </Group>
            :
            <Group align="flex-end" gap="xs" mt={5}>
              <Text className={classes.value} truncate>{stat.type == "number" ? stat.value : `$${(stat.value).toLocaleString('en-US')}`}</Text>
            </Group>
          }

        </Paper>
      </Grid.Col>
    );
  });
  return (
    <Grid w={"100%"}>{stats}</Grid>
  );
}