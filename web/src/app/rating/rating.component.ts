import { Component, OnInit } from '@angular/core';
import { ProductService } from '../services/product.service';

@Component({
  selector: 'app-rating',
  templateUrl: './rating.component.html',
  styleUrls: ['./rating.component.css']
})
export class RatingComponent implements OnInit {

  constructor() { }

  starWidth: number = 0;
  rating: number = 4;
  
  ngOnInit(): void {
    
    

  }

  rateProduct(rateValue: number) {
    this.starWidth = rateValue * 75 / 5;
  }
}
