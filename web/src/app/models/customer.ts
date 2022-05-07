export interface Customer {
    address?:string[];
    basketmap?:Map<string,number>;
    creditcards?:string[];
    email?: string;
    fullname?: string;
    ID?: string;
    method?: string;
    favproducts?:string[];
    prevorders?:string[];
  }