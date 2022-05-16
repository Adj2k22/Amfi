/*const Composable = artifacts.require("./ComposableBottomUp.sol");*/
const DesignNFT = artifacts.require("./DesignNFT.sol");
module.exports = function (deployer) {
  /*deployer.deploy(Composable, "ComposableBottomUp", "COMPTD", {gas: 8000000});*/
  deployer.deploy(DesignNFT);
};
