import {Injectable} from '@angular/core';
import {MetaMaskInpageProvider} from '@metamask/providers';

//@ts-ignore
import detectEthereumProvider from '@metamask/detect-provider'
//@ts-ignore
import Web3 from 'web3';
//@ts-ignore
import Diet from 'src/blockChain/src/abis/Diet.json'
import {Router} from "@angular/router";
import {Observable} from "rxjs";
import {HttpClient} from "@angular/common/http";

@Injectable({
  providedIn: 'any'
})
export class ContractService {
  loader: boolean = false;
  web3: any
  provider: any
  accounts: any[]
  contract: any

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
    const networkData = await Diet.networks[networkId]
    if (networkData) {
      // take contract address to make instance of this specific contract
      const contractAddress = networkData.address
      // take contract abi to call its methods
      const abi = Diet.abi
      // inject the provider to web3
      //@ts-ignore
      const web3 = new Web3(this.provider)
      // enable the provider to make transactions throw it
      await this.provider.enable();
      // make instance of the contract
      const contract = new web3.eth.Contract(abi, contractAddress);
      this.contract = contract;
      /*let test = await contract.methods.CALORIESPERSKILO().call();*/
      //let test = await contract.methods.participate(100, 50).send({from: this.accounts[0]}).then((value: any) => console.log(value));
      this.loader = true
    } else {
      throw "something is wrong with your contract abi"
    }
  }

  async participate(currentWeight: number, targetWeight: number, value: number) {
    /* const amountToSend = this.web3.utils.toWei(value, "ether");*/
    await this.contract
      .methods
      .participate(currentWeight, targetWeight)
      .send({
        from: this.accounts[0], value: Web3.utils.toWei(value.toString(), 'ether')
      })
      .then((recipe: any) => {
        console.log(recipe);
      });
  }

  async isParticipate() {
    return await this.contract.methods.participating().call({
      from: this.accounts[0]
    })
  }

  async isManager() {
    return (await this.contract
      .methods
      .ismanager()
      .call({
        from: this.accounts[0]
      }))
  }

  async changeMinValue(newValue: number) {
    await this.contract
      .methods
      .setMinParticipatingValue(newValue)
      .send({from: this.accounts[0]})
      .then((recipe: any) => {
        console.log(recipe);
      });
  }

  async addNfts(URI: string) {
    await this.contract
      .methods
      .addNftsToReward(URI)
      .send({from: this.accounts[0]})
      .then((recipe: any) => {
        console.log(recipe);
      });
  }

  async addNewWeight(addNewWeight: number) {
    await this.contract
      .methods
      .updateWeight(addNewWeight)
      .send({from: this.accounts[0]})
      .then((recipe: any) => {
        console.log(recipe);
      });
  }

  async addNewWeightTarget(addNewWeightTarget: number) {
    await this.contract
      .methods
      .setTargetWeight(addNewWeightTarget)
      .send({from: this.accounts[0]})
      .then((recipe: any) => {
        console.log(recipe);
      });
  }

  async rewardMe() {
    await this.contract
      .methods
      .rewardMe()
      .send({from: this.accounts[0]})
  }

  async getProgress() {
    return await this.contract
      .methods
      .getProgress()
      .call({
        from: this.accounts[0]
      })
  }

  async getNfts() {
    return await this.contract
      .methods
      .getOwnedURIs()
      .call({
        from: this.accounts[0]
      })
  }

  fetchjsonURI(jsonUrl: string): Observable<{
    "name": string,
    "description": string,
    "image": string
  }> {
    return this.httpClient.get<{
      "name": string,
      "description": string,
      "image": string
    }>(jsonUrl);
  }

}
