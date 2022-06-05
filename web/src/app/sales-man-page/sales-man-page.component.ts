import { Component, OnInit } from '@angular/core';
import { ApiService } from 'src/app/service/api.service';
import { Product } from 'src/app/models/product';
import { AuthService } from '../services/auth.service'
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore, AngularFirestoreCollection} from '@angular/fire/compat/firestore';
import { AngularFireDatabase } from '@angular/fire/compat/database';
import { FormGroup, FormControl, Validators } from '@angular/forms';
@Component({
  selector: 'app-sales-man-page',
  templateUrl: './sales-man-page.component.html',
  styleUrls: ['./sales-man-page.component.css']
})
export class SalesManPageComponent implements OnInit {

  longText = `The Shiba Inu is the smallest of the six original and distinct spitz breeds of dog
  from Japan. A small, agile dog that copes very well with mountainous terrain, the Shiba Inu was
  originally bred for hunting.`;
  productList: any;
  currentProduct: Product;
  brandID: string;
  productListWithBrand: Product[] = [];
  discountForm: FormGroup;
  public salesmanagerList : any;

  constructor(private firestore: AngularFirestore, private api : ApiService, private authService: AuthService, private afAuth: AngularFireAuth) {
    this.discountForm = new FormGroup({
      'discount': new FormControl('', [Validators.required]),
  });
   }

  ngOnInit(): void {
    this.api.getSalesManagers().subscribe((res: any)=>{
      this.salesmanagerList = res;
      this.salesmanagerList.forEach((a: any)=>{
        if(a.id == this.authService.userid){
          this.brandID = a.brand;
        }
    });
    })
    this.api.getProduct().subscribe((res: any)=>{
      this.productList = res;
      this.productList.forEach((p: any)=>{
        if(p.distributor_information == this.brandID){
          this.productListWithBrand.push(p);
        }

      });
    });
  }

  changeDiscount(productID: string){
    
    this.firestore.doc('/products/' + productID).valueChanges().subscribe((items) => {
      //console.log(items);
      this.firestore.doc('/products/' + productID).update({
        discount_rate: this.discountForm.value.discount,
      })

  })
  }

}
