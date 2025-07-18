interface ProfileProperties {
  identifier: string;
  name: string;
  photo: string;
  crew: string;
  crewLabel: string;
  isBoss: boolean;
  joined: string;
  races: number;
  wins: number;
  settings?: any;
}

export function filterData(
  data: ProfileProperties[],
  search: string
): ProfileProperties[] {
  const query = search.toLowerCase().trim();
  return data.filter((item) =>
    Object.values(item).some(
      (value) =>
        typeof value === "string" && value.toLowerCase().includes(query)
    )
  );
}

export function sortData(
  data: ProfileProperties[],
  payload: {
    sortBy: keyof ProfileProperties | null;
    reversed: boolean;
    search: string;
  }
): ProfileProperties[] {
  const { sortBy, reversed, search } = payload;

  const filteredData = filterData(data, search);

  if (!sortBy) {
    return filteredData;
  }

  const sortedData = [...filteredData].sort((a, b) => {
    if (typeof a[sortBy] === "string" && typeof b[sortBy] === "string") {
      return reversed
        ? (b[sortBy] as string).localeCompare(a[sortBy] as string)
        : (a[sortBy] as string).localeCompare(b[sortBy] as string);
    } else if (typeof a[sortBy] === "number" && typeof b[sortBy] === "number") {
      return reversed ? b[sortBy] - a[sortBy] : a[sortBy] - b[sortBy];
    }
    return 0;
  });

  return sortedData;
}
