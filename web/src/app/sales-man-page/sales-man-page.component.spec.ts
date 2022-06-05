import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalesManPageComponent } from './sales-man-page.component';

describe('SalesManPageComponent', () => {
  let component: SalesManPageComponent;
  let fixture: ComponentFixture<SalesManPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SalesManPageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SalesManPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
