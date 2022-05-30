import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ClothingInfoComponent } from './clothing-info.component';

describe('ClothingInfoComponent', () => {
  let component: ClothingInfoComponent;
  let fixture: ComponentFixture<ClothingInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ClothingInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ClothingInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
