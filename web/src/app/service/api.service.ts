import { HttpClient } from '@angular/common/http';
import { AngularFirestore, AngularFirestoreCollection} from '@angular/fire/compat/firestore';
import { AngularFireDatabase } from '@angular/fire/compat/database';

import { map, Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { product } from 'src/products';


@Injectable({
  providedIn: 'root'
})
export class ApiService {

  constructor(private firestore: AngularFirestore, private db: AngularFireDatabase) { }

  getProduct(){

    
    return this.firestore.collection<product>('products').snapshotChanges().pipe(map(snaps => 
      {return snaps.map(a => {
        const data = a.payload.doc.data();
        data.id = a.payload.doc.id;
        console.log(data);
        return data;
      })
    })
    );

  
  }

  getProductWithId(id: string){

    return this.firestore.doc(`products/${id}`).valueChanges();
  }

  
}
