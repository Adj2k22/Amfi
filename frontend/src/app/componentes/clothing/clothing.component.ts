import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from "@angular/router";
import {ContractService} from "../../services/contract.service";
import {DesignModule} from "../../modules/design/design.module";

@Component({
  selector: 'app-clothing',
  templateUrl: './clothing.component.html',
  styleUrls: ['./clothing.component.css']
})
export class ClothingComponent implements OnInit {
  design: DesignModule | undefined
  tokenId: number
  isClothing:boolean;
  constructor(private route: ActivatedRoute,private contractService: ContractService) {
    this.tokenId = 0;
    this.isClothing = false;
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
    this.isClothing = await this.contractService.isClothing(this.tokenId);
    let uri = await this.contractService.getDesignTokenURI(this.tokenId)
    this.contractService.fetchjsonURID(uri).subscribe(value => {
      this.design = new DesignModule(value.name,value.description,value.image,value.brand,value.designers)
      this.contractService.design.next(this.design)
    })
  }

}
