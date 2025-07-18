import { atom } from "recoil";

export const Height = atom({
  key: "height",
  default: 0,
});

export const Lang = atom<Object>({
  key: "lang",
  default: {
    test: "holi",
  },
});

export const Permissions = atom({
  key: "permissions",
  default: [],
});

export const RestData = atom<any>({
  key: "restaurant",
  default: [],
});
