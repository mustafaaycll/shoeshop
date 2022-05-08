import { Injectable } from '@angular/core';

import { AngularFireAuth } from '@angular/fire/compat/auth';

import { Router } from '@angular/router';

import { AngularFirestore } from '@angular/fire/compat/firestore';
//import { resourceLimits } from 'worker_threads';

@Injectable({
    providedIn: 'root'
})
export class AuthService {

    userLoggedIn: boolean;      // other components can check on this variable for the login status of the user
    userid: string;

    constructor(private router: Router, private afAuth: AngularFireAuth, private afs: AngularFirestore) {
        this.userLoggedIn = false;
        this.userid = "";

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
    


}
