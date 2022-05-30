import {Injectable} from '@angular/core';
import {MetaMaskInpageProvider} from '@metamask/providers';

//@ts-ignore
import detectEthereumProvider from '@metamask/detect-provider'
//@ts-ignore
import Web3 from 'web3';
//ABIS Json files of contracts
//@ts-ignore
import ClothingC from '/src/blockChain/src/comp/abis/ClothingC.json'
//@ts-ignore
import IdGenerator from '/src/blockChain/src/nfts/abis/IdGenerator.json'
//@ts-ignore
import DesignNFT from '/src/blockChain/src/nfts/abis/DesignNFT.json'
//@ts-ignore
import MaterialNFT from '/src/blockChain/src/nfts/abis/MaterialNFT.json'

import {Router} from "@angular/router";
import {HttpClient} from "@angular/common/http";
import {BehaviorSubject, Observable, Subject} from "rxjs";
import {NftType} from "../modules/nft-type";
import {DesignModule} from "../modules/design/design.module";
import {MaterialModule} from "../modules/material/material.module";
import {TransactionModule} from "../modules/transaction/transaction.module";

@Injectable({
  providedIn: 'any'
})
export class ContractService {
  loader: boolean = false;
  web3: any
  provider: any
  accounts: any[]

  contractClothingC: any
  contractIdGenerator: any
  contractDesignNFT: any
  contractMaterialNFT: any

  contractClothingCAddress: any
  contractIdGeneratorAddress: any
  contractDesignNFTAddress: any
  contractMaterialNFTAddress: any

   materials: BehaviorSubject<Map<number, MaterialModule> > = new  BehaviorSubject( new Map<number, MaterialModule>());
   design: BehaviorSubject<DesignModule> = new  BehaviorSubject(new DesignModule('','','','',[]));

  constructor(private router: Router, private httpClient: HttpClient) {
    this.accounts = []
    /* if constructor functions not loaded in the app component(like you begin the app suddenly in the manager) it will return to the app,
    because the service functions to prepare the web3 get loaded in the app component.
    if you go suddenly to other components without loading those methods the app crashes
     */
    this.router.navigateByUrl('app/').then(r => console.log('check profile'));
  }

  async loadWeb3() {
    this.provider = window.ethereum as MetaMaskInpageProvider;
    // You need to await for user response on the metamask popup dialog
    if (this.provider) {

      // @ts-ignore
      this.accounts = await this.provider.request<string[]>({method: 'eth_requestAccounts'});
      // @ts-ignore
      /* window.ethereum.on('accountsChanged', (newAccounts)=> this.accounts = newAccounts)*/
      if (this.accounts) {
        console.log('Welcome ' + this.accounts[0])
      } else {
        console.log('log in with your metamask provider')
      }
    }

  }

  async loadBlockChainData() {
    // check if contract is deyoled to the network and has network data to grape it and work on its methods
    const networkId = await this.provider.networkVersion;
    const networkDataClothingC = await ClothingC.networks[networkId]
    const networkDataIdGenerator = await IdGenerator.networks[networkId]
    const networkDataDesignNFT = await DesignNFT.networks[networkId]
    const networkDataMaterialNFT = await MaterialNFT.networks[networkId]

    if (networkDataClothingC
      && networkDataIdGenerator
      && networkDataDesignNFT
      && networkDataMaterialNFT) {
      // take contract address to make instance of this specific contract
      const contractAddressClothingC = networkDataClothingC.address
      const contractAddressIdGenerator = networkDataIdGenerator.address
      const contractAddressDesignNFT = networkDataDesignNFT.address
      const contractAddressMaterialNFT = networkDataMaterialNFT.address

      this.contractClothingCAddress = networkDataClothingC.address
      this.contractIdGeneratorAddress = networkDataIdGenerator.address
      this.contractDesignNFTAddress = networkDataDesignNFT.address
      this.contractMaterialNFTAddress = networkDataMaterialNFT.address

      // take contract abi to call its methods
      const abiClothingC = ClothingC.abi
      const abiIdGenerator = IdGenerator.abi
      const abiDesignNFT = DesignNFT.abi
      const abiMaterialNFT = MaterialNFT.abi
      // inject the provider to web3
      //@ts-ignore
      const web3 = new Web3(this.provider)
      // enable the provider to make transactions throw it
      await this.provider.enable();
      // make instance of the contract
      const contractClothingC = new web3.eth.Contract(abiClothingC, contractAddressClothingC);
      const contractIdGenerator = new web3.eth.Contract(abiIdGenerator, contractAddressIdGenerator);
      const contractDesignNFT = new web3.eth.Contract(abiDesignNFT, contractAddressDesignNFT);
      const contractMaterialNFT = new web3.eth.Contract(abiMaterialNFT, contractAddressMaterialNFT);

      this.contractClothingC = contractClothingC;
      this.contractIdGenerator = contractIdGenerator;
      this.contractDesignNFT = contractDesignNFT;
      this.contractMaterialNFT = contractMaterialNFT;
      /*let test = await contract.methods.CALORIESPERSKILO().call();*/
      //let test = await contract.methods.participate(100, 50).send({from: this.accounts[0]}).then((value: any) => console.log(value));
      this.loader = true
    } else {
      throw "something is wrong with your contract abi"
    }
  }

  async loadClothingDetails(tokenId: number) {
    let childTokens = await this.contractClothingC
      .methods
      .getChildTokenIdsOfParent(tokenId,this.contractMaterialNFTAddress)
      .call({
        from: this.accounts[0]
      });

    if (childTokens.length > 0) {
      let tokenIdType = await this.contractIdGenerator
        .methods
        .getNftType(tokenId)
        .call({
          from: this.accounts[0]
        });
      if (tokenIdType == NftType.DESIGN) {
        return childTokens;
      }
    }
    throw new Error(tokenId + "is not a clothing NFT")
  }

  async isClothing(tokenId: number) : Promise<boolean> {
    try {
      let address = await this.contractDesignNFT
        .methods
        .ownerOf(tokenId)
        .call({
          from: this.accounts[0]
        });
      return address == this.contractClothingCAddress;
    }catch (e) {
      console.error("tokenId: "+ tokenId + " is not Design or Clothing nether")
      return false;
    }

  }

  async getDesignTokenURI(tokenId: number) : Promise<string> {
    return await this.contractDesignNFT
      .methods
      .tokenURI(tokenId)
      .call({
        from: this.accounts[0]
      });
  }

  async getMaterialTokenURI(tokenId: number) : Promise<string> {
    return await this.contractMaterialNFT
      .methods
      .tokenURI(tokenId)
      .call({
        from: this.accounts[0]
      });

  }

  async getTransactionOfMaterial(tokenId: number) : Promise<TransactionModule[]>{
    return await this.contractMaterialNFT
      .methods
      .getTransactionOfTokenId(tokenId)
      .call({
        from: this.accounts[0]
      });
  }

  async getHistoryOfMaterial(tokenId: number) : Promise<{materialType:string, amount:number }[]>{
    return await this.contractMaterialNFT
      .methods
      .getMaterialHistoryOfTokenId(tokenId)
      .call({
        from: this.accounts[0]
      });

  }

  async getTransactionOfDesign(tokenId: number) : Promise<TransactionModule[]>{
    return await this.contractDesignNFT
      .methods
      .getTransactionOfTokenId(tokenId)
      .call({
        from: this.accounts[0]
      });
  }

  async getDesign(tokenId: number) : Promise< {'designType':string,'designers':string[]}>{
    return await this.contractDesignNFT
      .methods
      .getDesign(tokenId)
      .call({
        from: this.accounts[0]
      });
  }

  fetchjsonURID(jsonUrl: string): Observable<DesignModule> {
    return this.httpClient.get<DesignModule>(jsonUrl);
  }

  fetchjsonURIM(jsonUrl: string): Observable<MaterialModule> {
    return this.httpClient.get<MaterialModule>(jsonUrl);
  }

  async makeTestNft() {
    //1
    await this.contractDesignNFT.methods.makeNFT(this.accounts[0], this.contractIdGeneratorAddress, "", [],
      "https://gateway.pinata.cloud/ipfs/QmcESLxaMjhSFbg5Vq8pJ4kpsSDdfLBnkCnFrz63PMJ524").send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //2
    await this.contractMaterialNFT.methods.makeNFT(this.accounts[0], this.contractIdGeneratorAddress, "", 55,
      "https://gateway.pinata.cloud/ipfs/QmaQzYf2CQVZJBEiYMY53A7xXLonJEAf5tnS9CJw5Sskuc").send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //3
    await this.contractClothingC.methods.mint(this.accounts[0], 1, this.contractIdGeneratorAddress).send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //4
    await this.contractClothingC.methods.mint(this.accounts[0], 2, this.contractIdGeneratorAddress).send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //5
    await this.contractDesignNFT.methods.safeTransferFrom(this.accounts[0], this.contractClothingCAddress, 1, '0x00000000000000000000000000000001').send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //6
    await this.contractMaterialNFT.methods.safeTransferFrom(this.accounts[0], this.contractClothingCAddress, 2, '0x0000000000000000000000000000000200000000000000000000000000000008').send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });
    //7
    await this.contractClothingC
      .methods
      .safeTransferChildMain(this.contractIdGeneratorAddress, 2, this.contractClothingCAddress, this.contractMaterialNFTAddress, 2, '0x00000000000000000000000000000001')
      .send({
      from: this.accounts[0]
    })
      .then((recipe: any) => {
        console.log(recipe);
      });

  }
}
