import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { AngularFireModule} from '@angular/fire/compat';
import { AngularFirestoreModule} from '@angular/fire/compat/firestore';
import { AngularFireDatabaseModule} from '@angular/fire/compat/database';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { ProductService } from './services/product.service';

import { AppComponent } from './app.component';
import { ProductListComponent } from './product-list/product-list.component';
import { ProductComponent } from './product/product.component';
import { environment } from 'src/environments/environment';
import { CommentListComponent } from './comment-list/comment-list.component';
import { RatingComponent } from './rating/rating.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


@NgModule({
  declarations: [
    AppComponent,
    ProductListComponent,
    ProductComponent,
    CommentListComponent,
    RatingComponent
  ],
  imports: [
    NgbModule,
    BrowserModule,
    RouterModule.forRoot([
      { path: '', component: ProductListComponent },
      { path: 'products/:productid', component: ProductComponent},
    ]),
    AngularFireModule.initializeApp(environment.firebase),
    BrowserAnimationsModule,


    
  ],
  providers: [ProductService],
  bootstrap: [AppComponent]
})
export class AppModule { }
