import { Component, OnInit } from '@angular/core';
import { CartService } from 'src/app/service/cart.service';
import { AngularFireAuth } from '@angular/fire/compat/auth';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

  public totalItem: number = 0;
  public searchTerm: string ='';
  constructor(private cartService: CartService, public afAuth: AngularFireAuth) { }

  ngOnInit(): void {
    this.cartService.getProducts().subscribe(res=>{
        this.totalItem = res.length;

      }
    )
  }
  search(event:any){
    this.searchTerm=(event.target as HTMLInputElement).value;
    console.log(this.searchTerm);
    this.cartService.search.next(this.searchTerm);
    
  }

  logout(): void {
    this.afAuth.signOut();
  }
}


