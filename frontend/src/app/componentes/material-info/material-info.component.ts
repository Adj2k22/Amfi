import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from "@angular/router";
import {ContractService} from "../../services/contract.service";
import {MaterialModule} from "../../modules/material/material.module";
import {DesignModule} from "../../modules/design/design.module";

@Component({
  selector: 'app-material-info',
  templateUrl: './material-info.component.html',
  styleUrls: ['./material-info.component.css']
})
export class MaterialInfoComponent implements OnInit {
  material: MaterialModule | undefined ;
  tokenId: number
  constructor(private route: ActivatedRoute,private contractService:ContractService) {
    this.tokenId = 0;
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
    let uri = await this.contractService.getDesignTokenURI(this.tokenId)
    this.contractService.fetchjsonURIM(uri).subscribe(value => {
      this.material = new MaterialModule(value.name,value.description,value.type,value.sustainability
      ,value.harvest,value.companies,value.extraInfo)
    })

  }

}
