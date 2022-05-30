import { Component, OnInit } from '@angular/core';
import {TransactionModule} from "../../modules/transaction/transaction.module";
import {ActivatedRoute} from "@angular/router";
import {ContractService} from "../../services/contract.service";

@Component({
  selector: 'app-clothing-info',
  templateUrl: './clothing-info.component.html',
  styleUrls: ['./clothing-info.component.css']
})
export class ClothingInfoComponent implements OnInit {
  transactions:TransactionModule[]
  tokenId: number
  constructor(private route: ActivatedRoute,private contractService: ContractService) {
    this.transactions =[]
    this.tokenId = 0
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
    this.transactions = await this.contractService.getTransactionOfClothing(this.tokenId);
  }

  unixTimeStampToDate(unixTime:number): string{
    return new Date(unixTime*1000).toDateString();
  }

}
