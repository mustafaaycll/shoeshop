import { Component, OnDestroy, OnInit } from '@angular/core';
import { CartService } from 'src/app/service/cart.service';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AuthService } from 'src/app/services/auth.service';
import { product } from 'src/products';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { map } from 'rxjs';
import { user } from '@angular/fire/auth';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit{
  

  public products: any = [];
  public grandTotal !: number;
  public check: boolean;
  constructor(private cartService: CartService, public afAuth: AngularFireAuth, private auth: AuthService,public afs: AngularFirestore) {   
     
   }


  ngOnInit(): void {
   
   
      this.cartService.getProducts().subscribe((res: any)=>
        {
          this.products = res;
          this.grandTotal = this.cartService.getTotalPrice();
          
            
        })

    
   
  }

  removeItem(item: any){
    this.cartService.removeCartItem(item);

  }

  emptycart(){
    this.cartService.removeAllCart();
  }




}


