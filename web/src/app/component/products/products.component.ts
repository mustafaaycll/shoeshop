import { Component, OnInit } from '@angular/core';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';
import { Router } from '@angular/router';
import { FormBuilder } from "@angular/forms";

interface option {
  seo_val: string;
  text_val: string;
}


@Component({
  selector: 'app-products',
  templateUrl: './products.component.html',
  styleUrls: ['./products.component.scss'],
})
export class ProductsComponent implements OnInit {
  public productList : any;
  public filterCategory : any;
  public sortingCategory : any;
  searchKey:string="";
  selected = '';
  dropDownData: option[] = [
    {seo_val: 'aprice', text_val: 'Ascending Price'},
    {seo_val: 'dprice', text_val: 'Descending Price'},
    {seo_val: 'arating', text_val: 'Ascending Rating'},
    {seo_val: 'drating', text_val: 'Descending Rating'},
  ];

  constructor(private api : ApiService, private cartService: CartService, private router: Router, public fb: FormBuilder) { }

  sortingForm = this.fb.group({
    name: ['']
  })

  onSubmit() {

  }

  ngOnInit(): void {
    this.api.getProduct()
    .subscribe ( (res: any)=>{
      this.productList = res;
      this.filterCategory = res;
      this.productList.forEach((a: any) => {
        Object.assign(a,{quantity:1, total: a.price});

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
sortProductByPrice(event:any){
  if(event =='aprice'){
    this.productList.sort((a: { price: any; }, b: { price: any; }) => Number(a.price) - Number(b.price));
  }else if(event =='dprice'){
    this.productList.sort((a: { price: any; }, b: { price: any; }) => Number(b.price) - Number(a.price));
  }
  else if(event =='arating'){
    this.productList.sort((a: { rating: any; }, b: { rating: any; }) => Number(a.rating) - Number(b.rating));
  }else if(event =='drating'){
    this.productList.sort((a: { rating: any; }, b: { rating: any; }) => Number(b.rating) - Number(a.rating));
  }
}
}
