import { Injectable } from '@angular/core';
import { authState } from '@angular/fire/auth';

import { AngularFireAuth } from '@angular/fire/compat/auth';
import { getAuth, onAuthStateChanged , signInAnonymously } from "firebase/auth";


import { Router } from '@angular/router';

import { AngularFirestore } from '@angular/fire/compat/firestore';
import { Customer } from '../models/customer';


@Injectable({

    providedIn: 'root'
})
export class AuthService {

    
    userLoggedIn: boolean; 
    userid: string;     // other components can check on this variable for the login status of the user
    
    

    constructor(private router: Router, private afAuth: AngularFireAuth, private afs: AngularFirestore) {
        this.userLoggedIn = false;
        this.afAuth.onAuthStateChanged((user: any) => {              // set up a subscription to always know the login status of the user
            if (user) {
                this.userLoggedIn = true;
                this.userid = user.uid;
                
            } else {
                this.userLoggedIn = false;
            }
        });
    }

    loginUser(email: string, password: string): Promise<any> {
        return this.afAuth.signInWithEmailAndPassword(email, password)
            .then(() => {
                console.log('Auth Service: loginUser: success');
                // this.router.navigate(['/dashboard']);
            })
            .catch((error: { code: any; message: any; }) => {
                console.log('Auth Service: login error...');
                console.log('error code', error.code);
                console.log('error', error);
                if (error.code)
                    return { isValid: false, message: error.message };
            });
    }
    signInAnon(): Promise<any>{
        const auth = getAuth();
          return signInAnonymously(auth).then((res: {user:any}) => {
            
                    
                    this.afs.doc('/customers/' + res.user.uid).set({
                        fullname: "Anonymous",
                        email: "No Email",
                        addresses: [],
                        basketMap: {},
                        credit_cards: [],
                        fav_products: [],
                        id: res.user.uid,
                        method: "anonymous",
                        prev_orders: [],
                        tax_id: ""
    
                     });
                })
                .catch((error: { code: any; message: any; }) => {
                    console.log('Auth Service: signin Anon error', error);
                    if (error.code)
                        return { isValid: false, message: error.message };
                });
      }

    signupUser(user: any): Promise<any> {
        return this.afAuth.createUserWithEmailAndPassword(user.email, user.password)
            .then((result: { user: any; }) => {
                let emailLower = user.email.toLowerCase();
                this.afs.doc('/customers/' + result.user.uid).set({
                    fullname: user.displayName,
                    email: user.email,
                    addresses: [],
                    basketMap: {},
                    credit_cards: [],
                    fav_products: [],
                    id: result.user.uid,
                    method: "emailandpassword",
                    prev_orders: [],
                    tax_id: ""

                 });
                result.user!.sendEmailVerification();                    // immediately send the user a verification email
            })
            .catch((error: { code: any; message: any; }) => {
                console.log('Auth Service: signup error', error);
                if (error.code)
                    return { isValid: false, message: error.message };
            });
    }
    signupSalesMan(user: any): Promise<any> {
        
        return this.afAuth.createUserWithEmailAndPassword(user.email, user.password)
            .then((result: { user: any; }) => {
                let emailLower = user.email.toLowerCase();
                this.afs.doc('/salesmanagers/' + result.user.uid).set({
                    fullname: user.displayName,
                    email: user.email,
                    id: result.user.uid,
                    method: "emailandpassword",
                    brand: user.brand,

                 });
                result.user!.sendEmailVerification();                    // immediately send the user a verification email
            })
            .catch((error: { code: any; message: any; }) => {
                console.log('Auth Service: signup error', error);
                if (error.code)
                    return { isValid: false, message: error.message };
            });
    }
    signupUserwithId(user:any,id:string): Promise<any> {
        return this.afAuth.createUserWithEmailAndPassword(user.email, user.password)
            .then((result: { user: any; }) => {
                let emailLower = user.email.toLowerCase();
                this.afs.doc('/customers/' + id).set({
                    fullname: user.displayName,
                    email: user.email,
                    addresses: [],
                    basketMap: {},
                    credit_cards: [],
                    fav_products: [],
                    id: id,
                    method: "emailandpassword",
                    prev_orders: [],
                    tax_id: ""

                 });
                result.user!.sendEmailVerification();                    // immediately send the user a verification email
            })
            .catch((error: { code: any; message: any; }) => {
                console.log('Auth Service: signup error', error);
                if (error.code)
                    return { isValid: false, message: error.message };
            });
    }

}
