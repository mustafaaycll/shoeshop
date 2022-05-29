import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CartService } from 'src/app/service/cart.service';
import { ApiService } from 'src/app/service/api.service';
import { Router } from '@angular/router';
import { FormBuilder } from '@angular/forms';
import { AuthService } from 'src/app/services/auth.service';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { Customer } from 'src/app/models/customer';
import { product} from "src/products";


import jsPDF from 'jspdf';
import * as pdfMake from 'pdfmake/build/pdfmake';
import * as pdfFonts from 'pdfmake/build/vfs_fonts';
(pdfMake as any).vfs = pdfFonts.pdfMake.vfs;
var htmlToPdfmake = require("html-to-pdfmake");

interface basketMap{
  id: Array<any>;
};

@Component({
  selector: 'app-invoice',
  templateUrl: './invoice.component.html',
  styleUrls: ['./invoice.component.css']
})
export class InvoiceComponent implements OnInit {
  @ViewChild('pdfTable') pdfTable: ElementRef;
  public grandTotal !: number;
  currentCustomer: Customer;
  basketMap: basketMap;
  products: any = [];
  custInfo: Customer;
  adres: string[];
  grandTotalOnce: number=0;

  constructor(private cartService: CartService, private apiService: ApiService, private router: Router, private fb: FormBuilder, private auth: AuthService, public afAuth: AngularFireAuth, private afs: AngularFirestore) { }

  public delay(ms: number) {
    return new Promise( resolve => setTimeout(resolve, ms) );
  }

  async ngOnInit(): Promise<void> {
    this.apiService.getCustomerWithId().subscribe((customer)=>{
      this.currentCustomer = customer as Customer;
      if (this.grandTotalOnce == 0){
        this.grandTotal = this.cartService.getTotalPrice();
        this.basketMap = this.currentCustomer.basketMap as basketMap;
        this.products = this.cartService.getProducts()
        this.grandTotalOnce += 1;
      }
      console.log(this.basketMap);
      Object.keys(this.basketMap).forEach((key) => {
        console.log(key)
        this.apiService.getProductWithId(key).subscribe((product )=>{
          var product_ = product as product;
          Object.assign(product_, {quantity: this.basketMap[key as keyof basketMap][0], size: this.basketMap[key as keyof basketMap][1], total:  this.basketMap[key as keyof basketMap][0] * product_.price} )

          //this.products.push(product);


        });

      })

    });

    this.afAuth.onAuthStateChanged(user => {if(user){

      this.afs.doc('/customers/' + user.uid).valueChanges().subscribe((items) => {
        this.custInfo = items as Customer;
        this.adres = this.custInfo.addresses as string[];
      })

    }})

    await this.delay(1000);
    if (this.grandTotalOnce != 0){
      this.cartService.removeAllCart();
    }
  }


  public downloadAsPDF() {
    const doc = new jsPDF();
    //get table html
    const pdfTable = this.pdfTable.nativeElement;
    //html to pdf format
    var html = htmlToPdfmake(pdfTable.innerHTML);

    const documentDefinition = { content: html };
    pdfMake.createPdf(documentDefinition).open();
  }

}
