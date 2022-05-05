import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreCollection } from '@angular/fire/compat/firestore';
import { Firestore, collectionData, collection, CollectionReference } from '@angular/fire/firestore';
import { Customer } from '../models/customer';
import { Observable } from 'rxjs';
import { AngularFirestoreDocument } from '@angular/fire/compat/firestore';

@Injectable({
  providedIn: 'root'
})
export class ItemService {
  CustomerRef: AngularFirestoreCollection<Customer>;
  customers: Observable<Customer[]>;
  itemDoc: AngularFirestoreDocument<Customer>;

  constructor(public afs: AngularFirestore) {
    this.CustomerRef = this.afs.collection('customers');
    
  }
  updateItem(item: Customer){
    this.itemDoc = this.afs.doc(`items/${item.ID}`);
    this.itemDoc.update(item);
  }
}
