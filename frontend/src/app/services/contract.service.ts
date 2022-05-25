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

  constructor(private router: Router, private httpClient: HttpClient) {
    this.accounts = []
    /* if constructor functions not loaded in the app component(like you begin the app suddenly in the manager) it will return to the app,
    because the service functions to prepare the web3 get loaded in the app component.
    if you go suddenly to other components without loading those methods the app crashes
     */
   // this.router.navigateByUrl('app/').then(r => console.log('check profile'));
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
      &&networkDataDesignNFT
      &&networkDataMaterialNFT) {
      // take contract address to make instance of this specific contract
      const contractAddressClothingC = networkDataClothingC.address
      const contractAddressIdGenerator = networkDataIdGenerator.address
      const contractAddressDesignNFT = networkDataDesignNFT.address
      const contractAddressMaterialNFT = networkDataMaterialNFT.address

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

}
