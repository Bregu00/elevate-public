// Profile type
export interface UserProfile {
  identifier: string;
  name: string;
  photo: string;
  crypto?: number;
  queue?: boolean;
  level: number;
  hacks: number;
  deliveries: number;
  time: number;
  currentClass: string;
  nextClass: string;
  busy: boolean;
}

export interface ContractType {
  class: string;
  name: string;
  vehLabel: string;
  plates: string;
  deadline: number;
  serial: string;
  price: number;
  priceVin: number;
  started: boolean;
  seconds: number;
  deliveryType?: string;
}
