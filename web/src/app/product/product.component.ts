import { style } from '@angular/animations';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { product,products } from 'src/products';
import { ProductService } from '../services/product.service';
import { NgbCarousel } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.css']
})
export class ProductComponent implements OnInit {
  product!: product ;
  photoNum: number = 0;
 
  constructor(private route: ActivatedRoute, private productService: ProductService) { 
      
    
  }

  ngOnInit(): void {
    const routeParams = this.route.snapshot.paramMap;
    const productIdFromRoute = (routeParams.get('productid'));
    this.productService.getProductWithId(productIdFromRoute as string)
    .subscribe((product_) =>
    {
      this.product = product_ as product;
    }
     
    );

    
    
  
  }


  switchPhoto(){
    
    let thumbnails = document.getElementsByClassName('thumbnail');
    
    for(var i=0; i< thumbnails.length; i++){
      thumbnails[i].addEventListener('onclick',function(){
        thumbnails[i].classList.add('active');
        document.getElementById('featured')?.setAttribute('src',thumbnails[i].getAttribute('src') as string);
      })
    }

  }




}
