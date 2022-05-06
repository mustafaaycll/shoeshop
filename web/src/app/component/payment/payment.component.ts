import { Component, OnInit } from '@angular/core';
import { CartService } from 'src/app/service/cart.service';
import { AngularFireAuth } from '@angular/fire/compat/auth';

@Component({
  selector: 'app-header',
  templateUrl: './payment.component.html',
})
export class PaymentComponent implements OnInit {

  public products: any = [];
  public grandTotal !: number;
  constructor(private cartService: CartService, public afAuth: AngularFireAuth) { }

  ngOnInit(): void {
    this.cartService.getProducts().subscribe(res=>
      {
        this.products = res;
        this.grandTotal = this.cartService.getTotalPrice();
      })
  }

}


