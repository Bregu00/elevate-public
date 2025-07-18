import { Paper, Text, Group } from '@mantine/core';
import { useRecoilValue } from "recoil";
import { RestData, Permissions, Lang } from "../../../../reducers/atoms";
import { IconStarFilled } from '@tabler/icons-react'
import { formatString } from '../../../../hooks/formatString';
import classes from './Footer.module.css';

function calculateSalesDifference(currentMonthSales: number, previousMonthSales: number): number {
    if (previousMonthSales === 0 && currentMonthSales === 0) {
      return 0;
    }
    if (previousMonthSales === 0) {
      return 100;
    }

    const difference = currentMonthSales - previousMonthSales;
    const percentageDifference = (difference / previousMonthSales) * 100;
    return Math.floor(percentageDifference);
}

export function Footer() {
  const restData:any = useRecoilValue(RestData)
  const permissions:any = useRecoilValue(Permissions)
  const diff = calculateSalesDifference(restData.monthOrders, restData.lastMonthOrders)
  const { overview: lang }:any = useRecoilValue(Lang);
  const getRatingComment = (stars: number): string => {
    if (stars >= 4.5) {
      return lang.ratedByCustomers["5"];
    } else if (stars >= 4.0) {
      return lang.ratedByCustomers["4"];
    } else if (stars >= 3.0) {
      return lang.ratedByCustomers["3"];
    } else if (stars >= 2.0) {
      return lang.ratedByCustomers["2"];
    } else if (stars >= 1.0) {
      return lang.ratedByCustomers["1"];
    } else {
      return lang.ratedByCustomers["0"];
    }
  };
  const data = [
    {
      title: lang.employeeOfMonth.title,
      stats: restData.topEmployee.name,
      description: formatString(lang.employeeOfMonth.description,restData.topEmployee.hours),
      show: true
    },
    {
      title: lang.ratedByCustomers.title,
      stats: restData.stars ? restData.stars : 0,
      description: getRatingComment(restData.stars),
      type: "stars",
      show: true
    },
    {
      title: lang.completedOrders.title,
      stats: restData.monthOrders ? restData.monthOrders : 0,
      description: restData.monthOrders >= restData.lastMonthOrders ? `${Math.abs(diff)}% ${lang.completedOrders.more}` : `${Math.abs(diff)}% ${lang.completedOrders.less}`,
      show: permissions.isRestaurant
    },
  ];
  const stats = data.map((stat) => (
    <>
      {stat.show &&
        <div key={stat.title} className={classes.stat}>
            <Text fz={"xl"} fw={500} c="gray.2">
                {stat.type == "stars" ? 
                    <Group gap={"xs"}>
                        <Text fz={"xl"} fw={500} c="gray.2">{stat.stats}</Text>
                        <IconStarFilled style={{width: "3%", height: "3%", color: "gold"}}/>
                    </Group> 
                :
                    stat.stats
                }
            </Text>
          <Text fz={"md"} fw={400} c="gray.4">{stat.title}</Text>
          <Text fz={"sm"} fw={300} c="dimmed">{stat.description}</Text>
        </div>
      }
    </>
  ));
  return <Paper bg={"rgba(39, 43, 54, 0.3)"} style={{border: "solid 1px rgba(200,200,200,0.15)", borderRadius: "6px"}} mt={"sm"} className={classes.root}>{stats}</Paper>;
}