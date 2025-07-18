import { QueryResults } from "../../../../types/types";

export function filterData(
  data: QueryResults[],
  search: string
): QueryResults[] {
  const query = search.toLowerCase().trim();
  return data.filter((item) =>
    Object.keys(item).some((key) => {
      const value = item[key as keyof QueryResults];
      if (typeof value === "string") {
        return value.toLowerCase().includes(query);
      }
      return false;
    })
  );
}

export function sortData(
  data: QueryResults[],
  payload: {
    sortBy: keyof QueryResults | null;
    reversed: boolean;
    search: string;
  }
): QueryResults[] {
  const { sortBy, reversed, search } = payload;

  if (!sortBy) {
    return filterData(data, search);
  }

  const sortedData = [...filterData(data, search)].sort((a, b) => {
    const aValue = a[sortBy];
    const bValue = b[sortBy];
    if (
      typeof aValue === "object" &&
      aValue !== null &&
      "name" in aValue &&
      typeof bValue === "object" &&
      bValue !== null &&
      "name" in bValue
    ) {
      return reversed
        ? (bValue as { name: string }).name.localeCompare(
            (aValue as { name: string }).name
          )
        : (aValue as { name: string }).name.localeCompare(
            (bValue as { name: string }).name
          );
    }
    if (typeof aValue === "string" && typeof bValue === "string") {
      return reversed
        ? bValue.localeCompare(aValue)
        : aValue.localeCompare(bValue);
    }

    if (typeof aValue === "number" && typeof bValue === "number") {
      return reversed ? bValue - aValue : aValue - bValue;
    }
    return 0;
  });

  return sortedData;
}
