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
    let rating: number = 0;
    let num: number= 0;
    this.allcomments.forEach(element => {
      console.log(element);
      if(element.productID === productid){
          sum = sum +element.rating;
          num= num+1;
         
 
    }});
    
    rating = sum / num;
    console.log(rating);
    return rating;
  }
   
    
}

