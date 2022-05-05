import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { ItemService } from 'src/app/services/item.service';
import { Customer } from '../models/customer';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  customers: Customer[];
  addressForm: FormGroup;
  constructor(private itemService: ItemService) { 
  }

  ngOnInit(): void {
    this.addressForm = new FormGroup({
      'address': new FormControl('', Validators.required),
  });
  }

  updateItem(customer: Customer){
    this.itemService.updateItem(customer);
    //this.clearState();
  }






}
