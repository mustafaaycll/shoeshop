import { Component, OnInit } from '@angular/core';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';
import { Router } from '@angular/router';
import {MatSelectModule} from '@angular/material/select';
import { RatingService } from 'src/app/service/rating.service';

interface Option {
  value: string;
  viewValue: string;
}


@Component({
  selector: 'app-products',
  templateUrl: './products.component.html',
  styleUrls: ['./products.component.scss'],
})
export class ProductsComponent implements OnInit {
  public productList : any;
  public filterCategory : any;
  
  searchKey:string="";
  options: Option[] = [
    {value: 'price-1', viewValue: 'Sort by Price'},
    {value: 'popularity-2', viewValue: 'Sort by Popularity'},
  ];
  constructor(private api : ApiService, private cartService: CartService, private router: Router, private ratingService: RatingService) { }


  ngOnInit(): void {
    this.api.getProduct()
    .subscribe ( (res: any)=>{
      this.productList = res;
      this.filterCategory = res;
      this.productList.forEach((a: any) => {
        Object.assign(a,{quantity:1, total: a.price});

      });

      this.filterCategory.forEach((a:any)=>{
        Object.assign(a,{ rating: this.ratingService.getRating(a.id)});
      });
    })
    this.cartService.search.subscribe((val:any)=>{
      this.searchKey=val;
    })
  }

  addtocart(item: any){
    this.cartService.addtoCart(item);
  }
  filter(category:string){
    this.filterCategory = this.productList.filter((a:any)=>{
      if(a.category==category|| category==''){
        return a;
      }
    })
  }

  goToDetails(id: string){
    this.router.navigate(["/product"], {queryParams: {productid: id}})
    
  
}
}
