import { Injectable } from '@angular/core';
import { comment } from '../models/customer';
import { ApiService } from './api.service';

@Injectable({
  providedIn: 'root'
})
export class RatingService {

  allcomments: comment[]= [];
  rating: number;
  constructor(private apiService: ApiService) {
      
    this.apiService.getComments().subscribe(comments=>{
      console.log("here");
      this.allcomments = comments as comment[];
      
      });
      
 }

   getComments(productid: string){
       let comments: comment[] = [];
       this.allcomments.forEach(element => {
         console.log(element);
         if(element.productID === productid){
            comments.push(element);
            console.log(comments);
            
    
       }});
      return comments;
    
  }
  
  getRating(productid: string){
    let sum: number = 0;
    let rating: number;
    let num: number= 0;
    let nocomment = true;
    this.allcomments.forEach(element => {
      console.log(element);
      if(element.productID === productid){
          nocomment = false;
          sum = sum +element.rating;
          num= num+1;
         
 
    }});
    
    if(nocomment){
      return 0;
    }
    else{
      rating = sum / num;
      return rating;

    }
    
  }
   
    
}

