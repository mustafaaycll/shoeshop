import { Component, OnInit } from '@angular/core';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';
import {product} from "src/products";
import { ActivatedRoute } from '@angular/router';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';



@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.css']
})
export class ProductDetailsComponent implements OnInit {

  product: product ;
  photoNum: number = 0;
  discountedPrice: number= 0;
  sizesMap:  Map<string,number> = new Map<string,number>();;
  
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
      this.cartService.addtoCart(item);
      

      
    }
      
  
    isSizeAvailable(size: string): boolean{
       let stock = this.sizesMap.get(size);
       if(stock === 0){
         console.log(stock);
         return true;

       }
       else{
        return false;
       } 
    }

    isinStock(){
      let total = 0;
      for(let size of this.sizesMap.keys()){
       
           total = total + (this.sizesMap.get(size) || 0);       
      }
      return total;
    }
    
}
