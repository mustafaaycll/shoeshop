import { Component, OnInit } from '@angular/core';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';
import {product} from "src/products";
import { ActivatedRoute } from '@angular/router';
import { ApiService } from 'src/app/service/api.service';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.css']
})
export class ProductDetailsComponent implements OnInit {

  product!: product ;
  photoNum: number = 0;
 
  constructor(private route: ActivatedRoute, private apiService: ApiService) { 
      
    
  }

  ngOnInit(): void {
    const routeParams = this.route.snapshot.paramMap;
    const productIdFromRoute = (routeParams.get('productid'));
    this.apiService.getProductWithId(productIdFromRoute as string)
    .subscribe((product_) =>
    {
      this.product = product_ as product;
    }
     
    );



}
}
