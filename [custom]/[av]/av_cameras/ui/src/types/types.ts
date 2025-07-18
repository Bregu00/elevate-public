export type AllGroupsType = {
  [key: string]: CameraGroupType;
};

export interface CameraGroupType {
  value: string;
  label: string;
  identifier: string;
  isJob: boolean;
}

export type CameraStatus = "broken" | "working" | "unknown";

export interface CameraType {
  thumbnail: string;
  id: number;
  label: string;
  coords: {
    h: number;
    y: number;
    z: number;
    rotZ: number;
    rotY: number;
    rotX: number;
    x: number;
  };
  type: string;
  battery: number;
  status: string;
  owner: string;
  location: string;
  group: string;
  settings: {
    vehicle: boolean;
    canDestroy: boolean;
    nightvision: boolean;
    rotation: boolean;
    thermal: boolean;
    hackeable: boolean;
    prop: number;
    battery: number;
  };
  identifier: string;
  connected: boolean;
  isShared: boolean;
  isJob: boolean;
  isOwner: boolean;
}
