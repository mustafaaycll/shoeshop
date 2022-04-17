import { Component, OnInit } from '@angular/core';
import { ProductService } from '../services/product.service';
import {product} from "src/products";
import { Input } from '@angular/core';


@Component({

  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.css']
})
export class ProductListComponent implements OnInit {

  products: product[] = [];
  @Input() category = "sport";
  constructor(private productService: ProductService) { }

  ngOnInit(): void {
    this.productService.getProducts().
    subscribe(items => this.ProductsofCategory(items) );

   
    
  }

  ProductsofCategory(items: product[])
  {
    for (let index = 0; index < items.length; index++) {
      if(items[index].category !== this.category )
         items.splice(index,1);
    }
    this.products = items;

  }

}
