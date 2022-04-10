import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { ParticipateComponent } from './componentes/participate/participate.component';
import {RouterModule, Routes} from "@angular/router";
import {FormsModule} from "@angular/forms";
import { ProfileComponent } from './componentes/profile/profile.component';
import { ManagerComponent } from './componentes/manager/manager.component';
import { HistoryComponent } from './componentes/history/history.component';
import {HttpClientModule} from "@angular/common/http";
import { ContractService } from'./services/contract.service'

const appRoutes: Routes = [
  {path: 'app/', pathMatch: "full", component: AppComponent},
  {path: 'app/participate', pathMatch: "full", component: ParticipateComponent},
  {path: 'app/profile', pathMatch: "full", component: ProfileComponent},
  {path: 'app/manager', pathMatch: "full", component: ManagerComponent},
  {path: 'app/history', pathMatch: "full", component: HistoryComponent},
  {path: '*', pathMatch: 'full', redirectTo: 'app/participate'}
];


@NgModule({
  declarations: [
    AppComponent,
    ParticipateComponent,
    ProfileComponent,
    ManagerComponent,
    HistoryComponent
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
