import { atom } from "recoil";
import { ProfileProperties } from "../types/types";

export const Lang = atom<Object>({
  key: "lang",
  default: {},
});

export const Profile = atom<ProfileProperties>({
  key: "profile",
  default: {
    isAdmin: false,
    identifier: "abc123",
    name: "Avilchiis",
    photo: "abc123",
    isBoss: true,
    joined: "6/7/24",
    races: 4,
    wins: 8,
    isCop: false,
    alerts: true,
    underground: true,
    settings: {
      lights: 2,
      blip: 2,
      story: "A sad story",
      animation: "smoke",
      age: 24,
      nationality: "Mexican",
    },
  },
});

export const Events = atom<any>({
  key: "events",
  default: [],
});

export const showCountdownState = atom({
  key: "showCountdownState",
  default: false,
});

export const showRacingUIState = atom({
  key: "showRacingUIState",
  default: false,
});
