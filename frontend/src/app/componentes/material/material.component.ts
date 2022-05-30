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
materialsTokenIds: number[] ;
materials: MaterialModule[];
materialsMapping:Map<number, MaterialModule> = new Map<number, MaterialModule>();
  tokenId: number
  constructor(private route: ActivatedRoute,private contractService:ContractService) {
    this.tokenId = 0;
    this.materials = [];
    this.materialsTokenIds = [];
  }

  async ngOnInit(): Promise<void> {
    this.route.params.subscribe(param => {
      this.tokenId = param['tokenId'];
    });
    this.materialsTokenIds = await this.contractService.loadClothingDetails(this.tokenId)
    this.materials = await this.loadData()
    console.log(this.materials)
  }

  async loadData():Promise<MaterialModule[]>{

    let materials: MaterialModule[] =[]
    for (let i =0; i<this.materialsTokenIds.length;i++){
      let uri = await this.contractService.getMaterialTokenURI(this.materialsTokenIds[i])
      this.contractService.fetchjsonURIM(uri).subscribe(value => {
        let material: MaterialModule = new MaterialModule(value.name, value.description, value.type, value.sustainability,
          value.harvest, value.companies, value.extraInfo);
        materials[i]=material;
        this.materialsMapping.set(this.materialsTokenIds[i],material);
      })
    }
    this.contractService.materials.next(this.materialsMapping);
    return materials;
  }
}
