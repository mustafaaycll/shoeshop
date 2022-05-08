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
<<<<<<< HEAD:web/src/app/cart/cart.component.ts
  public check: boolean;
  constructor(private cartService: CartService, public afAuth: AngularFireAuth, private auth: AuthService,public afs: AngularFirestore) {   
     
   }
=======
  constructor(private cartService: CartService, public afAuth: AngularFireAuth, private auth: AuthService) {
    this.cartService.generateCartItemList();
     
  }
>>>>>>> 34f77a6cc5cd97702d59285e39b1a49e291ff55f:web/src/app/component/cart/cart.component.ts


  ngOnInit(): void {
   
<<<<<<< HEAD:web/src/app/cart/cart.component.ts
    if(this.auth.userLoggedIn){
      this.cartService.getProducts().subscribe(res=>
        {
          this.products = res;
          this.grandTotal = this.cartService.getTotalPrice();
          this.check=true;
            
        })

    }

    else{
      
      this.check=false;
      this.auth.signInAnon();
      this.cartService.getProducts().subscribe(res=>
=======
   
      this.cartService.getProducts().subscribe((res: any)=>
>>>>>>> 34f77a6cc5cd97702d59285e39b1a49e291ff55f:web/src/app/component/cart/cart.component.ts
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


