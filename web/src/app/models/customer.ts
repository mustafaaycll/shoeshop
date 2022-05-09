export interface Customer {
    addresses:string[];
    basketMap: {};
    credit_cards: string[];
    email: string;
    fullname: string;
    id: string;
    method: string;
    fav_products:string[];
    prev_orders:string[];
  }



  export interface comment{
    approved: string;
    customerID: string;
    productID: string;
    comment: string;
    date: string;
    sellerID:string;
    rating: number;
  }