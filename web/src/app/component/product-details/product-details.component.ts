import { Component, OnInit } from '@angular/core';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';
import {product} from "src/products";
import { ActivatedRoute } from '@angular/router';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';
import { Customer } from 'src/app/models/customer';



@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.css']
})
export class ProductDetailsComponent implements OnInit {

  product: product ;
  photoNum: number = 0;
  discountedPrice: number= 0;
  sizesMap:  Map<string,number> = new Map<string,number>();
  selectedsize:string;
  quanti: number = 1;
  customer: Customer;
  
  constructor(private route: ActivatedRoute, private apiService: ApiService, private cartService: CartService) { 
      
  }

  ngOnInit(): void {
    const routeParams = this.route.snapshot.queryParams;
    const productIdFromRoute = (routeParams.productid);

    this.apiService.getProductWithId(productIdFromRoute as string)
    .subscribe((product_) =>
    {
      this.product = product_ as product;
      this.discountedPrice= this.product.price - (this.product.price * (this.product.discount_rate / 100));
      Object.keys(this.product.sizesMap).forEach((key) => {
        this.sizesMap.set(key, this.product.sizesMap[key]);
      })
      
    }
      
    );
   
    

}

    addtocart(item: any){
      this.apiService.getCustomerWithId().subscribe((res )=>{
        this.customer = res as Customer;
        if(this.customer.fullname)
            console.log(this.customer.fullname as string);
      });
      Object.assign(item,{quantity: this.quanti, size: this.selectedsize, total: this.quanti *item.price});
      this.cartService.addtoCart(item);
     

      
    }
      
  
    isSizeAvailable(size: string){
       let stock = this.sizesMap.get(size);
       return stock === 0;
    }

    isinStock(){
      let total = 0;
      for(let size of this.sizesMap.keys()){
       
           total = total + (this.sizesMap.get(size) || 0);       
      }
      return total;
    }


    plus(){
      if(this.sizesMap.get(this.selectedsize)){
        if(this.quanti !==this.sizesMap.get(this.selectedsize) ){
          this.quanti++;
        }     
        else{
          window.alert("No more items left in the size you have selected");

        }
      }
      
    }

    minus(){
      if(this.quanti !== 1)
        this.quanti--;
    }
    
}
