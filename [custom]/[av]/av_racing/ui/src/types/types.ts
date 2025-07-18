export interface Member {
  identifier: string;
  name: string;
  photo: string;
  crew: string;
  crewLabel: string;
  isBoss: boolean;
  joined: string;
  races: number;
  wins: number;
  settings: SettingsType;
}

export interface SettingsType {
  lights?: number;
  blip?: number;
  story?: string;
  animation?: string;
  age?: number;
  nationality?: string;
}

export interface CrewProperties {
  name: string;
  label: string;
  isBoss: boolean;
  photo: string;
}

export interface ProfileProperties {
  isAdmin: boolean;
  identifier: string;
  name: string;
  photo: string;
  crew?: CrewProperties | false;
  isBoss: true;
  joined?: string;
  races: number;
  wins: number;
  settings: SettingsType;
  underground: boolean;
  isCop?: boolean;
  alerts: boolean;
}

interface EventDetails {
  buyin: number;
  checkpoints: string;
  class: string;
  description: string;
  host: string;
  hostName: string;
  identifier: string;
  laps: number;
  moneypot: number;
  numRacers: number;
  password: string;
  phasing: boolean | number;
  racers: any[];
  seconds: number;
  started: boolean;
  startsin: number;
  title: string;
  totalFinished: number;
  track: string;
  trackIdentifier: string;
  trackid: string;
  type: string;
}

export interface AllEvents {
  [key: string]: EventDetails;
}
