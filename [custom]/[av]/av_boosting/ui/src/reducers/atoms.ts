import { atom } from 'recoil'
import { UserProfile } from "../types/types";

export const Height = atom({
    key: "height",
    default: 0
})

export const Lang = atom<Object>({
  key: "lang",
  default: {
  },
});

export const Profile = atom<UserProfile>({
  key: "profile",
  default: {
      identifier: "avilchiis123",
      name: "Avilchiis",
      photo: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/p0oT829.png",
      crypto: 0,
      queue: false,
      level: 0,
      hacks: 0,
      deliveries: 0,
      time: 0,
      currentClass: "",
      nextClass: "",
      busy: false,
  }
})