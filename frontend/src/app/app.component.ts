import {Component, OnInit} from '@angular/core';
import {ContractService} from "./services/contract.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Weight Manager';

  constructor(private contractService: ContractService,
              private router: Router) {
  }
  async ngOnInit(): Promise<void> {
    await this.contractService.loadWeb3()
    await this.contractService.loadBlockChainData()
    let isParticipating = await this.contractService.isParticipate()
    console.log(isParticipating)
    let isManager = await this.contractService.isManager()
    if (isManager){
      this.router.navigateByUrl('app/manager').then(r => console.log('check profile'));
      return;
    }
    if (isParticipating){
      this.router.navigateByUrl('app/profile').then(r => console.log('check profile'));
      return;
    }else{
      this.router.navigateByUrl('app/participate').then(r => console.log('participate please'));
      return;
    }

  }
}
