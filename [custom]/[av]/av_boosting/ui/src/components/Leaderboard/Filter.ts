import { UserProfile } from '../../types/types';

function filterData(data: any, search: string) {
  const query = search.toLowerCase().trim();
  return data.filter((item: any) =>
    Object.keys(data[0]).some((key) => {
      if (typeof item[key] === 'string') {
        return item[key].toLowerCase().includes(query);
      }
      return false;
    })
  );
}

export function sortData(
  data: any,
  payload: { sortBy: keyof UserProfile | null; reversed: boolean; search: string }
) {
  const { sortBy } = payload;

  if (!sortBy) {
    return filterData(data, payload.search);
  }

  return filterData(
    [...data].sort((a, b) => {
      if (typeof a[sortBy] === 'number' && typeof b[sortBy] === 'number') {
        return payload.reversed ? b[sortBy] - a[sortBy] : a[sortBy] - b[sortBy];
      } else {
        if (payload.reversed) {
          return String(b[sortBy]).localeCompare(String(a[sortBy]));
        }
        return String(a[sortBy]).localeCompare(String(b[sortBy]));
      }
    }),
    payload.search
  );
}