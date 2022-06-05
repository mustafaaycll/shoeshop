import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CartComponent } from './cart/cart.component';
import { ProductsComponent } from './component/products/products.component';

import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { SignupComponent } from './signup/signup.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { PaymentComponent } from './component/payment/payment.component';
import { AuthGuard } from './services/auth.guard';
import { ProductDetailsComponent } from './component/product-details/product-details.component';
import { AddresspageComponent } from './addresspage/addresspage.component';
import { ChechkoutComponent } from './component/chechkout/chechkout.component';
import { SalesManLoginComponent } from './sales-man-login/sales-man-login.component';
import { SalesManSignupComponent } from './sales-man-signup/sales-man-signup.component';
import { SalesManPageComponent } from './sales-man-page/sales-man-page.component';
//import * as auth0 from "auth0-js";



const routes: Routes = [
  {path:'', redirectTo:'products',pathMatch:'full'},
  {path: 'product', component: ProductDetailsComponent},
  {path:'products', component: ProductsComponent},
  {path:'cart', component: CartComponent},
  { path: 'home', component: HomeComponent },
  { path: 'login', component: LoginComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'Payment', component: PaymentComponent},
  { path: 'Checkout', component: ChechkoutComponent},
  { path: 'dashboard', component: DashboardComponent, canActivate: [AuthGuard] },
  { path: 'addresspage', component: AddresspageComponent },
  { path: 'sales-man-login', component: SalesManLoginComponent },
  { path: 'sales-man-signup', component: SalesManSignupComponent },
  { path: 'sales-man-page', component: SalesManPageComponent },
  { path: '**', component: HomeComponent },  
  

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
