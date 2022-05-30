import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from "@angular/router";
import {ContractService} from "../../services/contract.service";
import {MaterialModule} from "../../modules/material/material.module";
import {DesignModule} from "../../modules/design/design.module";
import {TransactionModule} from "../../modules/transaction/transaction.module";

@Component({
  selector: 'app-material-info',
  templateUrl: './material-info.component.html',
  styleUrls: ['./material-info.component.css']
})
export class MaterialInfoComponent implements OnInit {
  material: MaterialModule | undefined;
  transactions:TransactionModule[]
  materialHistory: {
     materialType:string,
     amount:number
  }[]
  tokenId: number
  constructor(private route: ActivatedRoute,private contractService:ContractService) {
    this.tokenId = 0;
    this.transactions =[]
    this.materialHistory = []
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });

    this.contractService.materials.subscribe(value => {
      this.material = value.get(this.tokenId);
    })

    this.materialHistory = await this.contractService.getHistoryOfMaterial(this.tokenId)
    this.transactions = await this.contractService.getTransactionOfMaterial(this.tokenId)
  }
  unixTimeStampToDate(unixTime:number): string{
    return new Date(unixTime*1000).toDateString();
  }

}
