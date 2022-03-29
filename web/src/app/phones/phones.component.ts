import { Component, OnInit } from '@angular/core';
import { Phones, phones } from '../phones';
import { CartService } from '../cart.service';

@Component({
  selector: 'app-phones',
  templateUrl: './phones.component.html',
  styleUrls: ['./phones.component.css']
})
export class PhonesComponent implements OnInit {

  phones = phones;

  constructor(private cartService: CartService) { }

  addToCart(phone: Phones) {
    this.cartService.addToCart(phone);
    window.alert('Your product has been added to the cart!');
  }

  ngOnInit(): void {
  }

}
