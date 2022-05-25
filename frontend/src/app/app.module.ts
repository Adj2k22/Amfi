import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import {RouterModule, Routes} from "@angular/router";
import {FormsModule} from "@angular/forms";
import {HttpClientModule} from "@angular/common/http";
import { ContractService } from'./services/contract.service';
import { HomeComponent } from './componentes/home/home.component'

const appRoutes: Routes = [
  {path: 'app/', pathMatch: "full", component: AppComponent},
  {path: 'app/home', pathMatch: "full", component: HomeComponent},
];


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
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
