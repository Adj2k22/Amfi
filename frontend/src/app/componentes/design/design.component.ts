import { Component, OnInit } from '@angular/core';
import {DesignModule} from "../../modules/design/design.module";
import {ActivatedRoute} from "@angular/router";
import {ContractService} from "../../services/contract.service";
import {MaterialModule} from "../../modules/material/material.module";
import {TransactionModule} from "../../modules/transaction/transaction.module";

@Component({
  selector: 'app-design',
  templateUrl: './design.component.html',
  styleUrls: ['./design.component.css']
})
export class DesignComponent implements OnInit {
  design: DesignModule | undefined
  designb:{'designType':string,'designers':string[]}| undefined
  tokenId: number
  transactions:TransactionModule[]
  constructor(private route: ActivatedRoute,private contractService: ContractService) {
    this.tokenId = 0;
    this.transactions = []
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
   this.designb = await this.contractService.getDesign(this.tokenId)
    this.contractService.design.subscribe(value => this.design = value)
    this.transactions = await this.contractService.getTransactionOfDesign(this.tokenId)
  }

  unixTimeStampToDate(unixTime:number): string{
    return new Date(unixTime*1000).toDateString();
  }

}
