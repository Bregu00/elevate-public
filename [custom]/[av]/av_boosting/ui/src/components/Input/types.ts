interface Field {
  name: string;
  type: string;
  placeholder?: string;
  description?: string;
  label?: string;
}

interface Options {
  title: string;
  event: string;
  extraData?: any;
  fields: Field[];
}

interface InputProps {
  options: Options;
  callback: (data: any, event: string, extraData?: any) => void;
  show: (state: boolean) => void;
}