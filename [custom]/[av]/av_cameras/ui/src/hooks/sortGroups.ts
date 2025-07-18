import { AllGroupsType } from "../types/types";

export const sortGroups = (groups: AllGroupsType): AllGroupsType => {
  const groupsArray = Object.values(groups);
  groupsArray.sort((a, b) =>
    a.value === "shared" ? -1 : b.value === "shared" ? 1 : 0
  );
  const sortedGroups = groupsArray.reduce((acc, group) => {
    acc[group.value] = group;
    return acc;
  }, {} as AllGroupsType);
  return sortedGroups;
};
