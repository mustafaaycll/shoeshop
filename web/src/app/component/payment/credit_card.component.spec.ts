import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Credit_CardComponent } from './credit_card.component';

describe('Credit_CardComponent', () => {
  let component: Credit_CardComponent;
  let fixture: ComponentFixture<Credit_CardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Credit_CardComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Credit_CardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
