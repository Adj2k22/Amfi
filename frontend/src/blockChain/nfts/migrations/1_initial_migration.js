/*const Composable = artifacts.require("./ComposableBottomUp.sol");*/
const DesignNFT = artifacts.require("./DesignNFT.sol");
const MaterialNFT = artifacts.require("./MaterialNFT.sol");
const IdGenerator = artifacts.require("./IdGenerator.sol");
const App= artifacts.require("./App.sol");
module.exports = function (deployer) {
  /*deployer.deploy(Composable, "ComposableBottomUp", "COMPTD", {gas: 8000000});*/
  deployer.deploy(DesignNFT);
  deployer.deploy(MaterialNFT);
  deployer.deploy(IdGenerator);
  deployer.deploy(App);
};
