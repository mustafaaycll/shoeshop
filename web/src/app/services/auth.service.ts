import { Injectable } from '@angular/core';
import { authState } from '@angular/fire/auth';

import { AngularFireAuth } from '@angular/fire/compat/auth';
import { getAuth, onAuthStateChanged } from "firebase/auth";


import { Router } from '@angular/router';


@Injectable({

    providedIn: 'root'
})
export class AuthService {

    
    userLoggedIn: boolean; 
    userid: string;     // other components can check on this variable for the login status of the user

    constructor(private router: Router, private afAuth: AngularFireAuth) {
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

    signupUser(user: any): Promise<any> {
        return this.afAuth.createUserWithEmailAndPassword(user.email, user.password)
            .then((result: { user: any; }) => {
                let emailLower = user.email.toLowerCase();
                result.user!.sendEmailVerification();                    // immediately send the user a verification email
            })
            .catch((error: { code: any; message: any; }) => {
                console.log('Auth Service: signup error', error);
                if (error.code)
                    return { isValid: false, message: error.message };
            });
    }

    getUserInfo(){   
        
        const auth = getAuth();
        const user = auth.currentUser;
        if(user !== null){
            return user.providerData;
        }
    }
   
}
