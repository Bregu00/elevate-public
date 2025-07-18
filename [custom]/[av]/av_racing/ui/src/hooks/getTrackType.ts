export const GetTrackType = (type: any, filterCategories: any) => {
  return filterCategories.find((x: any) => x.value === type);
};
