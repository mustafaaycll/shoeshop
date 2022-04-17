import { Component, OnInit } from '@angular/core';
import { Comment, Comments } from "src/comments";
import { ProductService } from '../services/product.service';
import { Input } from '@angular/core';
import { product } from 'src/products';

@Component({
  selector: 'app-comment-list',
  templateUrl: './comment-list.component.html',
  styleUrls: ['./comment-list.component.css']

})
export class CommentListComponent implements OnInit {


  comments: Comment[] = Comments;
 
  constructor(private productService: ProductService) {

  }
  
  ngOnInit(): void {
      
  }

}
