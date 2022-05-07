import { Injectable } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { doc, setDoc } from "firebase/firestore";

@Injectable({
  providedIn: 'root'
})
export class CustomerService {

  userid: string;
  name: string;
  email: string;

  constructor(private auth: AuthService) { 
    
    if (this.auth.getUserInfo())  {
      this.auth.getUserInfo()?.forEach ((profile) => {
        this.userid = profile.uid;
        this.name = profile.displayName as string;
        this.email = profile.email as string;

        console.log("  Provider-specific UID: " + profile.uid);
        console.log("  Name: " + profile.displayName);
        console.log("  Email: " + profile.email);
        
      });
  }
}


  
}
