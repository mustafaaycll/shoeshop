export interface product{
    id: string;
    name: string;
    model: string;
    category: string;
    color: string;
    description: string;
    price: number;
    discount_rate: number;
    sizesMap: any;
    sex: string;
    photos : string[];
    comments: string[];
}


export const products = [
    {
        id: "1",
        name : "Nike",
        model: "Air",
        category: "Sport",
        color: "white",
        description: "A nice shoe",
        price: 300,
        discountRate: 0,
        quantity: 10,
        sex: "man"
    },
    {
        id: "2",
        name : "Puma",
        model: "xxx",
        category: "Sport",
        color: "white",
        description: "A wonderffkgvfkfsdfogkfo",
        price: 200,
        discountRate: 0,
        quantity: 12,
        sex: "man"
    },
    {
        id: "3",
        name : "Adidas",
        model: "5ss",
        category: "casual",
        color: "white",
        description: "Dont buy iy",
        price: 300,
        discountRate: 0,
        quantity: 10,
        sex: "woman"
    }
  ];