import { Component, OnInit } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
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

  firstFormGroup: FormGroup

  secondFormGroup: FormGroup;
  checkoutFormGroup: FormGroup;
  products: any = [];
  currentCustomer: Customer;
  totalPrice: number= 0;
  totalQuantity: number=0;
  basketMap: basketMap;
  cardId: string;
  custInfo: Customer;
  adres: string[];
  radioSelected: any;
  abc: Customer;
  flag: boolean;
  getAddress?: string[];
  constructor(private cartService: CartService, private apiService: ApiService, private fb: FormBuilder, private auth: AuthService, public afAuth: AngularFireAuth, private afs: AngularFirestore) { }

  ngOnInit(): void {

    this.firstFormGroup = this.fb.group({
      firstCtrl: ['', Validators.required],
    });
    this.secondFormGroup = this.fb.group({
      secondCtrl: ['', Validators.required],
    });

    this.checkoutFormGroup= this.fb.group({
      creditCard: this.fb.group({
      
        cardHolderName: ['', Validators.required],
        cardNumber: ['', Validators.required],
        cvvCode: ['', Validators.required],
        expiryDate: ['', Validators.required],
        
      }),
      Address: this.fb.group({
      
        Address: ['', Validators.required],
        
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

          this.products.push(product);
          
     
        });
              
      })
      
      
    });

    this.afAuth.onAuthStateChanged(user => {if(user){

      this.afs.doc('/customers/' + user.uid).valueChanges().subscribe((items) => {
        this.custInfo = items as Customer;
        this.adres = this.custInfo.addresses as string[];
      })
  
    }})

  }


  onSubmit(data: any){
    console.log(data);
    let obj = data.creditCard; 
    let obj2 = data.Address;
    this.checkoutFormGroup.value.Address
    var adres = this.checkoutFormGroup.value.Address.Address;
    obj["holderID"] = this.auth.userid;
    console.log(this.currentCustomer);
    console.log(obj);
    console.log(obj2);
    if(this.currentCustomer.credit_cards)
       console.log(this.currentCustomer.credit_cards as string[]);
    this.apiService.addCart(obj, this.currentCustomer.credit_cards);
  
    this.createOrder();
    this.cartService.removeAllCart();
    
    
  }

  createOrder(){
    var adres = this.checkoutFormGroup.value.Address.Address;
    this.products.forEach((product: any)=>{
      console.log(product);
      let order = {
        address: adres,
        customerID: this.auth.userid,
        date : "05-09-2022",
        price: product.price,
        productID: product.id,
        quantity: product.quantity,
        rated: false,
        sellerId: "",
        size: product.size,
        status: "proccessing"
      }
      
      let selectedsize = product.size;
      console.log(selectedsize);
      Object.keys(product.sizesMap).map(size=>{
        if( size === selectedsize as string){
          product.sizesMap[size] = product.sizesMap[size] - product.quantity;
        }
      })
      

      console.log(product.sizesMap);
      this.apiService.createOrder(order, product.sizesMap);
      
    
    })


  }
  

  
  
}
