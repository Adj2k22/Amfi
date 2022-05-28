import { Component, OnInit } from '@angular/core';
import {ContractService} from "../../services/contract.service";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  tokenId:number
  constructor(private contractService:ContractService) {
    this.tokenId = 0;
  }

  ngOnInit(): void {
  }
  initTestNFt(){
    this.contractService.makeTestNft();
  }

}
