import { HttpClient } from '@angular/common/http';
import { AngularFirestore, AngularFirestoreCollection} from '@angular/fire/compat/firestore';
import { AngularFireDatabase } from '@angular/fire/compat/database';
import { map, Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { product, customer } from 'src/products';
import { AuthService } from '../services/auth.service';
import { doc, setDoc, updateDoc } from "firebase/firestore"; 




@Injectable({
  providedIn: 'root'
})
export class ApiService {

  constructor(private firestore: AngularFirestore, private db: AngularFireDatabase, private auth: AuthService) { }

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

  
  getCustomerWithId(){
    let id = this.auth.userid;
    return this.firestore.doc(`customers/${id}`).valueChanges();
   
  }

  UpdateBasketofUser(bsketmap: any){
    let id = this.auth.userid;
    console.log(id);
    this.firestore.collection("customers").doc(id).update(
      {
        "basketMap": bsketmap
      
     })


  }


  getComments(){
    return this.firestore.collection("comments").valueChanges();
  }

  
}
