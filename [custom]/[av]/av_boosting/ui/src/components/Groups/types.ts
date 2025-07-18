interface Member {
  name: string;
  identifier: string;
}

interface GroupType {
    identifier:string,
    owner:string,
    label:string,
    password?:string,
    status:string,
    members: Member[];
    maxMembers: number;
}

interface Options {
  title: string;
  event: string;
  extraData?: any;
  fields: Field[];
}

interface Field {
  name: string;
  type: string;
  placeholder?: string;
  description?: string;
  label?: string;
}