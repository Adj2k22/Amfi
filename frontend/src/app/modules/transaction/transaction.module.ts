import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {NftType} from "../nft-type";
import {TokenIdAction} from "../token-id-action";


@NgModule({
  declarations: [],
  imports: [
    CommonModule
  ]
})
export class TransactionModule {
  public timeStamp: Date ;
  public from: number;
  public to: number;
  public nftType: NftType;
  public tokenIdAction: TokenIdAction

  constructor() {
    this.timeStamp = new Date();
    this.from = 0;
    this.to = 0;
    this.nftType = NftType.NOTEXIST;
    this.tokenIdAction = TokenIdAction.Moved;
  }
}
