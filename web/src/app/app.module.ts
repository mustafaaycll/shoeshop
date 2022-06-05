import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule} from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HeaderComponent } from './component/header/header.component';
import { CartComponent } from './cart/cart.component';
import { ProductsComponent } from './component/products/products.component';
import { HttpClientModule } from '@angular/common/http';
import { FilterPipe } from './shared/filter.pipe';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HomeComponent } from './home/home.component';
import { SignupComponent } from './signup/signup.component';
import { LoginComponent } from './login/login.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import {NgbRatingModule} from '@ng-bootstrap/ng-bootstrap';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';


import { MatButtonModule } from "@angular/material/button";
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import {MatStepperModule} from '@angular/material/stepper';

import {MatButtonToggleModule} from '@angular/material/button-toggle';


import { AngularFireModule } from '@angular/fire/compat';
import { environment } from '../environments/environment';
import { initializeApp,provideFirebaseApp } from '@angular/fire/app';

import { provideAuth,getAuth } from '@angular/fire/auth';

import { provideFirestore,getFirestore } from '@angular/fire/firestore';
import { ProductDetailsComponent } from './component/product-details/product-details.component';

import { ItemService } from './services/item.service';
import { AddresspageComponent } from './addresspage/addresspage.component';
import { ChechkoutComponent } from './component/chechkout/chechkout.component';
import { PaymentComponent } from './component/payment/payment.component';
import { SalesManLoginComponent } from './sales-man-login/sales-man-login.component';
import { SalesManSignupComponent } from './sales-man-signup/sales-man-signup.component';
import { SalesManPageComponent } from './sales-man-page/sales-man-page.component';



@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    CartComponent,
    ProductsComponent,
    FilterPipe,
    HomeComponent,
    SignupComponent,
    LoginComponent,
    DashboardComponent,
    ProductDetailsComponent,
    AddresspageComponent,
    ChechkoutComponent,
    PaymentComponent,
    SalesManLoginComponent,
    SalesManSignupComponent,
    SalesManPageComponent
    
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    AngularFireModule.initializeApp(environment.firebase),   // imports firebase/app needed for everything

    MatButtonModule,
    MatCardModule,
    MatInputModule,
    NgbRatingModule,
    NgbModule,
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    provideAuth(() => getAuth()),
    provideFirestore(() => getFirestore()),
    MatSelectModule,
    MatButtonToggleModule,
    MatStepperModule,
  ],
  providers: [ItemService],
  bootstrap: [AppComponent]
})
export class AppModule { }
