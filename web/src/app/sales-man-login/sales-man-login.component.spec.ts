import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalesManLoginComponent } from './sales-man-login.component';

describe('SalesManLoginComponent', () => {
  let component: SalesManLoginComponent;
  let fixture: ComponentFixture<SalesManLoginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SalesManLoginComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SalesManLoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
