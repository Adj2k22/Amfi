import { Component, OnInit } from '@angular/core';
import {MaterialModule} from "../../modules/material/material.module";
import {ContractService} from "../../services/contract.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-material',
  templateUrl: './material.component.html',
  styleUrls: ['./material.component.css']
})
export class MaterialComponent implements OnInit {
//materials: MaterialModule[] | undefined;
materialsTokenIds: number[] | undefined;
  tokenId: number
  constructor(private route: ActivatedRoute,private contractService:ContractService) {
    this.tokenId = 0;
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
    this.materialsTokenIds = await this.contractService.loadClothingDetails(this.tokenId)
  }

}
