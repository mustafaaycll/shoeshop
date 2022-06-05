import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalesManSignupComponent } from './sales-man-signup.component';

describe('SalesManSignupComponent', () => {
  let component: SalesManSignupComponent;
  let fixture: ComponentFixture<SalesManSignupComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SalesManSignupComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SalesManSignupComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
