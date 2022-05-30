import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DesignInfoComponent } from './design-info.component';

describe('DesignInfoComponent', () => {
  let component: DesignInfoComponent;
  let fixture: ComponentFixture<DesignInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DesignInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DesignInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
