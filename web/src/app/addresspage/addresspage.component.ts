import { Component, OnInit } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore, AngularFirestoreCollection, AngularFirestoreDocument } from '@angular/fire/compat/firestore';
import { observable, Observable } from 'rxjs';
import { Customer } from '../models/customer';
import { AuthService } from '../services/auth.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { ItemService } from '../services/item.service';
import { Router } from '@angular/router';
import { user } from '@angular/fire/auth';
import { arrayUnion, FieldValue, QuerySnapshot } from '@angular/fire/firestore';
import { isAdmin } from '@firebase/util';


@Component({
  selector: 'app-addresspage',
  templateUrl: './addresspage.component.html',
  styleUrls: ['./addresspage.component.css']
})
export class AddresspageComponent implements OnInit {
  customerRef: AngularFirestoreCollection<Customer>;
  customer$: Observable<Customer[]>;
  itemDoc: AngularFirestoreDocument;
  addressForm: FormGroup;
  firebaseErrorMessage: string;
  getAddress?: string[];
  
  abc: Customer;
  flag: boolean;
  flag2: boolean;
  custInfo: Customer;
  adres: string[];

  constructor(private afs: AngularFirestore, public afAuth: AngularFireAuth, private authService: AuthService, private itemService: ItemService, private router: Router ) {
    this.customerRef = this.afs.collection('customers');
    this.customer$ = this.customerRef.valueChanges();
    this.firebaseErrorMessage = '';
   }

  ngOnInit(): void {
    this.addressForm = new FormGroup({
      'address': new FormControl('', Validators.required),
  });

    this.afAuth.onAuthStateChanged(user => {if(user){

      this.afs.doc('/customers/' + user.uid).valueChanges().subscribe((items) => {
        this.custInfo = items as Customer;
        this.adres = this.custInfo.addresses as string[];
      })

    }})

  
  }

  updateItem(address: string){
    this.afAuth.onAuthStateChanged(user => {if(user){
      this.flag = false;
      
      this.afs.doc('/customers/' + user.uid).valueChanges().subscribe((items) => {
        //console.log(items);
        if(this.flag == false && address != ""){
          this.abc = items as Customer;
          this.getAddress = this.abc.addresses;
          this.getAddress?.push(address);
          this.afs.doc('/customers/' + user.uid).update({
            addresses: this.getAddress,
          })
          this.flag = true;
        }

        else{
          
        }

        
        
      })
      

    }})
  }
  
  

  
}
