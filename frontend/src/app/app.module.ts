import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import {RouterModule, Routes} from "@angular/router";
import {FormsModule} from "@angular/forms";
import {HttpClientModule} from "@angular/common/http";
import { ContractService } from'./services/contract.service';
import { HomeComponent } from './componentes/home/home.component';
import { ClothingComponent } from './componentes/clothing/clothing.component';
import { TransactionsComponent } from './componentes/transactions/transactions.component';
import { DesignComponent } from './componentes/design/design.component';
import { MaterialComponent } from './componentes/material/material.component';
import { ClothingInfoComponent } from './componentes/clothing-info/clothing-info.component'

const appRoutes: Routes = [
  {path: 'app/', pathMatch: "full", component: AppComponent},
  {path: 'app/home', pathMatch: "full", component: HomeComponent},
  {path: 'app/clothing/:tokenId', pathMatch: "full", component: ClothingComponent},
  {path: 'app/design/:tokenId', pathMatch: "full", component:DesignComponent, children:[
      {path:':tokenId', component: TransactionsComponent}
    ]},
  {path: 'app/material/:tokenId', pathMatch: "full", component:MaterialComponent,children:[
      {path:':tokenId',component: TransactionsComponent}
    ]},
  {path: '*', pathMatch: 'full', redirectTo: 'app/home'}
];


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    ClothingComponent,
    TransactionsComponent,
    DesignComponent,
    MaterialComponent,
    ClothingInfoComponent,
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
