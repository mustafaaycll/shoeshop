import { Component, OnInit } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore, AngularFirestoreCollection, AngularFirestoreDocument } from '@angular/fire/compat/firestore';
import { Observable } from 'rxjs';
import { Customer } from '../../models/customer';
import { AuthService } from '../../services/auth.service';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { ItemService } from '../../services/item.service';
import { Router } from '@angular/router';
import { user } from '@angular/fire/auth';
import { arrayUnion, FieldValue } from '@angular/fire/firestore';
import { isAdmin } from '@firebase/util';

@Component({
  selector: 'app-payment',
  templateUrl: './payment.component.html',
})
export class Credit_CardComponent implements OnInit {
  customerRef: AngularFirestoreCollection<Customer>;
  customer$: Observable<Customer[]>;
  itemDoc: AngularFirestoreDocument;
  credit_cardForm: FormGroup;
  firebaseErrorMessage: string;
  getAddress: [];
  namee: string;

  constructor(private afs: AngularFirestore, public afAuth: AngularFireAuth, private authService: AuthService, private itemService: ItemService, private router: Router ) {
    this.customerRef = this.afs.collection('customers');
    this.customer$ = this.customerRef.valueChanges();
    this.firebaseErrorMessage = '';
    
    
   }

  ngOnInit(): void {
    this.credit_cardForm = new FormGroup({
      'credit_card': new FormControl('', Validators.required),
  });
  }

  updateItem(credit_cards: string){
    this.afAuth.onAuthStateChanged(user => {if(user){
      this.afs.doc('/customers/' + user.uid).valueChanges().subscribe(items => {
        console.log(items);
        
      })
      this.afs.doc('/customers/' + user.uid).update({
        credit_cards: [credit_cards],
      })
    }})
  }

  
}