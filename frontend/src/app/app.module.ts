import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import {RouterModule, Routes} from "@angular/router";
import {FormsModule} from "@angular/forms";
import {HttpClientModule} from "@angular/common/http";
import { ContractService } from'./services/contract.service';
import { HomeComponent } from './componentes/home/home.component';
import { ClothingComponent } from './componentes/clothing/clothing.component';
import { DesignComponent } from './componentes/design/design.component';
import { MaterialComponent } from './componentes/material/material.component';
import { ClothingInfoComponent } from './componentes/clothing-info/clothing-info.component';
import { MaterialInfoComponent } from './componentes/material-info/material-info.component';
import { ErrorPageComponent } from './componentes/error-page/error-page.component';

const appRoutes: Routes = [
  {path: 'app/', pathMatch: "full", component: AppComponent},
  {path: 'app/home', pathMatch: "full", component: HomeComponent},
  {path: 'app/clothing/:tokenId', pathMatch: "full", component: ClothingComponent},
  {path: 'app/clothingInfo/:tokenId', pathMatch: "full", component: ClothingInfoComponent},
  {path: 'app/design/:tokenId', pathMatch: "full", component:DesignComponent},
  {path: 'app/material/:tokenId', pathMatch: "full", component:MaterialComponent},
  {path: 'app/materialInfo/:tokenId', pathMatch: "full", component:MaterialInfoComponent},
  {path: 'app/error', pathMatch: "full", component: ErrorPageComponent},
  {path: '*', pathMatch: 'full', redirectTo: 'app/home'}
];


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    ClothingComponent,
    DesignComponent,
    MaterialComponent,
    ClothingInfoComponent,
    MaterialInfoComponent,
    ErrorPageComponent,
  ],
  imports: [
    BrowserModule,
    RouterModule,
    HttpClientModule,
    RouterModule.forRoot(appRoutes),
    FormsModule
  ],
  providers: [ContractService],
  bootstrap: [AppComponent]
})
export class AppModule { }
