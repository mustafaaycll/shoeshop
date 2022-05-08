import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { BehaviorSubject } from 'rxjs';
import { AuthService } from '../services/auth.service';
import { Customer } from '../models/customer';
import { product } from 'src/products';
import { ApiService } from './api.service';

interface basketMap{
  id: Array<any>;
};


@Injectable({
  providedIn: 'root'
})

export class CartService {

  currentCustomer: Customer;
  
 
  public cartItemList: any = [] 
  public productList = new BehaviorSubject<any>([]);
  public search = new BehaviorSubject<string>("");
  
  constructor(private apiService: ApiService, private auth: AuthService) {
    if(this.auth.userLoggedIn){
      this.generateCartItemList();
      this.productList.next(this.cartItemList);
    }
    else{
      this.generateCartAnon();
      this.productList.next(this.cartItemList);
    }
    

  }


  getProducts(){
    
    return this.productList.asObservable();
    
  }



  setProduct(product: any){
    this.cartItemList.push(...product);
    this.productList.next(product);

  }

  addtoCart(product: any){
    this.cartItemList.push(product);
    this.productList.next(this.cartItemList);
    this.getTotalPrice();
    this.UpdateBasketMap(this.cartItemList);
    
  }

   UpdateBasketMap(cartItemList: Array<any>) {

    var obj = {}
    cartItemList.forEach(item => {
      console.log(item.id);
      let id = item.id;
      if(id !== undefined){
        Object.assign(obj, { [item.id]: [item.quantity, item.size]});
      }
          
    });
    console.log(obj);
    this.apiService.UpdateBasketofUser(obj);  
  }

  getTotalPrice(): number {
    let grandTotal= 0;
    this.cartItemList.map((a: any) =>{
      grandTotal+= a.total;
    })
    return grandTotal;
  }


  removeCartItem(product: any){
    this.cartItemList.map((a: any, index: any)=>{
      if(product.id === a.id){
        this.cartItemList.splice(index,1)
      }
    })

    this.productList.next(this.cartItemList);
    this.UpdateBasketMap(this.cartItemList);
  }

  removeAllCart(){
    this.cartItemList = [];
    this.productList.next(this.cartItemList);
    this.UpdateBasketMap(this.cartItemList);
  }

  generateCartAnon(){
    console.log("here");
    this.auth.signInAnon();
    
    this.apiService.getCustomerWithId().subscribe((customer)=>{     
      this.currentCustomer = customer as Customer;
      let basketMap = this.currentCustomer.basketMap as basketMap;
      console.log(basketMap);
      Object.keys(basketMap).forEach((key) => {
        console.log(key)
        this.apiService.getProductWithId(key).subscribe((product )=>{
          var product_ = product as product;
          Object.assign(product_, {quantity: basketMap[key as keyof basketMap][0], size: basketMap[key as keyof basketMap][1], total:  basketMap[key as keyof basketMap][0] * product_.price} )
          console.log(product_);
          this.cartItemList.push(product_);
        });
              
      })
      
    })

  }
  generateCartItemList(){
    
    console.log("here");
    this.apiService.getCustomerWithId().subscribe((customer)=>{     
      this.currentCustomer = customer as Customer;
      let basketMap = this.currentCustomer.basketMap as basketMap;
      console.log(basketMap);
      Object.keys(basketMap).forEach((key) => {
        console.log(key)
        this.apiService.getProductWithId(key).subscribe((product )=>{
          var product_ = product as product;
          Object.assign(product_, {quantity: basketMap[key as keyof basketMap][0], size: basketMap[key as keyof basketMap][1], total:  basketMap[key as keyof basketMap][0] * product_.price} )
          console.log(product_);
          this.cartItemList.push(product_);
        });
              
      })
      
    })
  }
  
}

