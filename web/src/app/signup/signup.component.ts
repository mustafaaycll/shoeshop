import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service'
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AngularFireAuth } from '@angular/fire/compat/auth';
//import { Customer } from 'src/app/models/customer';
import { ItemService } from 'src/app/services/item.service';
import { AngularFirestore } from '@angular/fire/compat/firestore';

@Component({
    selector: 'app-signup',
    templateUrl: './signup.component.html',
    styleUrls: ['./signup.component.css'],
})
export class SignupComponent implements OnInit {
    
    signupForm: FormGroup;
    firebaseErrorMessage: string;
    check: boolean;

    constructor(private authService: AuthService, private router: Router, private afAuth: AngularFireAuth, private itemService: ItemService,public afs: AngularFirestore) {
        this.firebaseErrorMessage = '';
    }

    ngOnInit(): void {
        this.signupForm = new FormGroup({
            'displayName': new FormControl('', Validators.required),
            'email': new FormControl('', [Validators.required, Validators.email]),
            'password': new FormControl('', Validators.required)
        });
    }

    signup() {
        if (this.signupForm.invalid)                            // if there's an error in the form, don't submit it
            return;
        let userId=this.authService.userid;
        if(userId!=''){
            this.afs.collection('/customers/').doc(userId).snapshotChanges().forEach((res:any)=>{
                
                
                   this.authService.signupUserwithId(this.signupForm.value,userId).then((result) => {
                       if (result == null)                                 // null is success, false means there was an error
                           this.router.navigate(['/dashboard']);
                       else if (result.isValid == false)
                           this.firebaseErrorMessage = result.message;
                   }).catch(() => {
           
                   });
      
              });
        }
        else{
            this.authService.signupUser(this.signupForm.value).then((result) => {
                if (result == null)                                 // null is success, false means there was an error
                    this.router.navigate(['/dashboard']);
                else if (result.isValid == false)
                    this.firebaseErrorMessage = result.message;
            }).catch(() => {
    
            });
        }
    
            
        
    }
  
}

