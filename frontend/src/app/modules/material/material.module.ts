
export class MaterialModule {
  name: string
  description: string
  type: string
  sustainability: boolean
  harvest:string
  companies:string[]
  extraInfo:string


  constructor(name: string, description: string, type: string, sustainability: boolean, harvest: string, companies: string[], extraInfo: string) {
    this.name = name;
    this.description = description;
    this.type = type;
    this.sustainability = sustainability;
    this.harvest = harvest;
    this.companies = companies;
    this.extraInfo = extraInfo;
  }
}
