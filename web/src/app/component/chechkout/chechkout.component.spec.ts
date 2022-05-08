import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ChechkoutComponent } from './chechkout.component';

describe('ChechkoutComponent', () => {
  let component: ChechkoutComponent;
  let fixture: ComponentFixture<ChechkoutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ChechkoutComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ChechkoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
