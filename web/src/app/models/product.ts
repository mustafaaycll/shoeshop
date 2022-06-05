export interface Product{
    category: string;
    color: string;
    discount_rate: number;
    distributor_information: string;
    id: string;
    model: string;
    name: string;
    comments:string[];
    description: string;
    photos:string[];
    price: string;
    ratings:string[];
    sex: string;
    sizesMap:{};
    warranty: boolean;
}