import {Component, OnInit} from '@angular/core';
import {ContractService} from "./services/contract.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Interplanetary Textile Passport';

  constructor(private contractService: ContractService,
              private router: Router) {


  }
  async ngOnInit(): Promise<void> {
    await this.contractService.loadWeb3()
    await this.contractService.loadBlockChainData()

    this.router.navigateByUrl('app/home').then(r => console.log('check profile'));

  }
}
