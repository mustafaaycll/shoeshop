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

  product!: product ;
  photoNum: number = 0;
  discountedPrice!: number;
  constructor(private route: ActivatedRoute, private apiService: ApiService, private cartService: CartService) { 
      
    
  }

  ngOnInit(): void {
    const routeParams = this.route.snapshot.queryParams;
    const productIdFromRoute = (routeParams.productid);

    this.apiService.getProductWithId(productIdFromRoute as string)
    .subscribe((product_) =>
    {
      this.product = product_ as product;
      this.getDiscount();
    }
  
    );
   
    

}

    addtocart(item: any){
      this.cartService.addtoCart(item);
      console.log(this.product);
      console.log(this.product.discount_rate);
      console.log(this.discountedPrice);
      console.log(this.product.price - (this.product.price * (this.product.discount_rate / 100)));
    }

    getDiscount(){
      if(this.product.discount_rate === 0){
        this.discountedPrice = this.product.price;
      }
      else{
        this.discountedPrice =this.product.price - (this.product.price * (this.product.discount_rate / 100));
      }
    
    }

    getStockInfo(size: number){
      let sizes= this.product.sizesMap as Map<number,number>;
      let stock =sizes.get(size);
      console.log(stock);
    }
}
