export class DesignModule {
  name: string
  description: string
  image: string
  brand:string
  designers:string[]


  constructor(name: string, description: string, image: string, brand: string, designers: string[]) {
    this.name = name;
    this.description = description;
    this.image = image;
    this.brand = brand;
    this.designers = designers;
  }
}
