import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import {RouterModule, Routes} from "@angular/router";
import {FormsModule} from "@angular/forms";
import {HttpClientModule} from "@angular/common/http";
import { ContractService } from'./services/contract.service';
import { HomeComponent } from './componentes/home/home.component';
import { ClothingComponent } from './componentes/clothing/clothing.component';
import { TransactionsComponent } from './componentes/transactions/transactions.component'

const appRoutes: Routes = [
  {path: 'app/', pathMatch: "full", component: AppComponent},
  {path: 'app/home', pathMatch: "full", component: HomeComponent},
  {path: 'app/clothing/:tokenId', pathMatch: "full", component: ClothingComponent},
];


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    ClothingComponent,
    TransactionsComponent,
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
