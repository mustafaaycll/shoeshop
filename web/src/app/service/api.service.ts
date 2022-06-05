import { HttpClient } from '@angular/common/http';
import { AngularFirestore, AngularFirestoreCollection} from '@angular/fire/compat/firestore';
import { AngularFireDatabase } from '@angular/fire/compat/database';
import { map, Observable, subscribeOn } from 'rxjs';
import { Injectable } from '@angular/core';
import { product } from 'src/products';
import { AuthService } from '../services/auth.service';
import { doc, setDoc, updateDoc } from "firebase/firestore"; 
import { Customer } from '../models/customer';
import { Seller } from '../models/seller';




@Injectable({
  providedIn: 'root'
})
export class ApiService {

  abc: Customer;
  getAddress: string[];
  flag: boolean;
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
  getCustomerWithIdAnon(id:string){
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

  getSellers(){
    return this.firestore.collection<Seller>('sellers').snapshotChanges().pipe(map(snaps => 
      {return snaps.map(a => {
        const data = a.payload.doc.data();
        data.id = a.payload.doc.id;
        console.log(data);
        return data;
      })
    })
    );
  }


  addCart(value: any, creditcards: any){
    var Ref = this.firestore.collection("/cards").doc().ref;
    console.log(Ref.id);
    value["id"]= Ref.id;  
    console.log(value);
    Ref.set(value);
    let id = this.auth.userid;

    creditcards.push(Ref.id);
    this.firestore.collection("/customers").doc(id).update(
      {
        "credit_cards" : creditcards
      
     })

  }

  updateAddress(address: string){

    this.flag = false;
    this.firestore.doc('/customers/' + this.auth.userid).valueChanges().subscribe((items) => {
      //console.log(items);
      if(this.flag == false && address != ""){
        this.abc = items as Customer;
        this.getAddress = this.abc.addresses;
        this.getAddress?.push(address);
        this.firestore.doc('/customers/' + this.auth.userid).update({
          addresses: this.getAddress,
        })
        this.flag = true;
      }

      else{
        
      }
  })
}
  

  createOrder(order: any, newstock:any){
    let productid = order.productID;
     
    var ref= this.firestore.collection("/orders").doc().ref;
    Object.assign(order, {id: ref.id })
    console.log(order);
    ref.set(order);
    this.firestore.doc(`products/${productid}`).update({
       "sizesMap": newstock
    })

    

  }
  addComment(comments:any){
    var ref= this.firestore.collection("/comments").doc().ref;
    Object.assign(comments, {id: ref.id });
    console.log(comments);
    ref.set(comments);
  }



}
