import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service'
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AngularFireAuth } from '@angular/fire/compat/auth';
//import { Customer } from 'src/app/models/customer';
import { ItemService } from 'src/app/services/item.service';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { ApiService } from 'src/app/service/api.service';


@Component({
  selector: 'app-sales-man-signup',
  templateUrl: './sales-man-signup.component.html',
  styleUrls: ['./sales-man-signup.component.css']
})
export class SalesManSignupComponent implements OnInit {

  signupForm: FormGroup;
  firebaseErrorMessage: string;
  check: boolean;
  sellerID: string;
  public sellerList : any;
  
  constructor(private api : ApiService, private authService: AuthService, private router: Router, private afAuth: AngularFireAuth, private itemService: ItemService,public afs: AngularFirestore) {
    this.firebaseErrorMessage = '';
  }

  ngOnInit(): void {
    this.signupForm = new FormGroup({
      'displayName': new FormControl('', Validators.required),
      'email': new FormControl('', [Validators.required, Validators.email]),
      'password': new FormControl('', Validators.required),
      'brand': new FormControl('', Validators.required),
  });
  }

  signup() {
    if (this.signupForm.invalid)                            // if there's an error in the form, don't submit it
        return;
    let userId=this.authService.userid;
    this.api.getSellers().subscribe((res: any)=>{
      this.sellerList = res;
      this.sellerList.forEach((a: any)=>{
          if(a.name == this.signupForm.value.brand){
            this.signupForm.value.brand = a.id;
          }
      });
  })
    this.authService.signupSalesMan(this.signupForm.value).then((result) => {
        if (result == null)                                 // null is success, false means there was an error
            this.router.navigate(['/sales-man-page']);
        else if (result.isValid == false)
            this.firebaseErrorMessage = result.message;
    }).catch(() => {

    });
}

}
