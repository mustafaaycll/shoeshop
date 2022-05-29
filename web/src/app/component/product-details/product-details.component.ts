import { Component, OnInit } from '@angular/core';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';
import {product} from "src/products";
import { ActivatedRoute } from '@angular/router';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';
import { comment, Customer } from 'src/app/models/customer';
import { RatingService } from 'src/app/service/rating.service';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { AuthService } from 'src/app/services/auth.service';



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
  comments: comment[];;
  rating: number = 0;
  commentrating: number = 5;
  
  constructor(private route: ActivatedRoute, private apiService: ApiService, private cartService: CartService
    ,private ratingService: RatingService, private afs: AngularFirestore, public auth: AuthService) { 
      
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
      this.comments= this.ratingService.getComments(this.product.id);
      this.rating = this.ratingService.getRating(this.product.id);
      
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
    addComment(comment: string){
      console.log(comment);
      let userid = this.auth.userid;
      let comments = {
        approved: true,
        comment: comment,
        customerID: userid,
        date: "09-05-2022",
        productID: this.product.id,
        rating: this.commentrating,
        sellerID: "",
      }
      this.apiService.addComment(comments);
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
