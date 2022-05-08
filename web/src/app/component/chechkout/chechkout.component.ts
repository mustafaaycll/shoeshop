import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Customer } from 'src/app/models/customer';
import { ApiService } from 'src/app/service/api.service';
import { CartService } from 'src/app/service/cart.service';
import { AuthService } from 'src/app/services/auth.service';
import { product} from "src/products";

interface basketMap{
  id: Array<any>;
};

@Component({
  selector: 'app-chechkout',
  templateUrl: './chechkout.component.html',
  styleUrls: ['./chechkout.component.css']
})
export class ChechkoutComponent implements OnInit {

  checkoutFormGroup: FormGroup;
  products: any = [];
  currentCustomer: Customer;
  totalPrice: number= 0;
  totalQuantity: number=0;
  basketMap: basketMap;
  cardId: string;
  constructor(private cartService: CartService, private apiService: ApiService, private fb: FormBuilder, private auth: AuthService) { }

  ngOnInit(): void {


    this.checkoutFormGroup= this.fb.group({
      creditCard: this.fb.group({
      
        cardHolderName: [''],
        cardNumber: [''],
        cvvCode: [''],
        expiryDate: [''],
        
      })
      
      
      
    })

    
    this.apiService.getCustomerWithId().subscribe((customer)=>{     
      this.currentCustomer = customer as Customer;
      this.basketMap = this.currentCustomer.basketMap as basketMap;
      console.log(this.basketMap);
      Object.keys(this.basketMap).forEach((key) => {
        console.log(key)
        this.apiService.getProductWithId(key).subscribe((product )=>{
          var product_ = product as product;
          Object.assign(product_, {quantity: this.basketMap[key as keyof basketMap][0], size: this.basketMap[key as keyof basketMap][1], total:  this.basketMap[key as keyof basketMap][0] * product_.price} )
          console.log(product_);
          this.products.push(product);
          
     
        });
              
      })
      
      
    });

  }


  onSubmit(data: any){
    console.log(data);
    let obj = data.creditCard;
    
    obj["holderID"] = this.auth.userid;
    this.apiService.addCart(obj);
    
  }
}
