import { Component, OnDestroy, OnInit } from '@angular/core';
import { CartService } from 'src/app/service/cart.service';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit{
  

  public products: any = [];
  public grandTotal !: number;
  constructor(private cartService: CartService, public afAuth: AngularFireAuth, private auth: AuthService) { }


  ngOnInit(): void {
   
    if(this.auth.userLoggedIn){
      

    }

    else{
      this.cartService.getProducts().subscribe(res=>
        {
          this.products = res;
          this.grandTotal = this.cartService.getTotalPrice();
          
            
        })

    }
   
  }

  removeItem(item: any){
    this.cartService.removeCartItem(item);

  }

  emptycart(){
    this.cartService.removeAllCart();
  }




}
