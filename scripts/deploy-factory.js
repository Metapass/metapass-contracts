const hre = require("hardhat");

async function main() {
  const MetapassFactory = await hre.ethers.getContractFactory(
    "MetapassFactory"
  );
  const factoryContract = await MetapassFactory.deploy(
    "0xEd38011305ff0dBCD75B39bb07295E9E6bff5BA6"
  );

  await factoryContract.deployed();

  console.log("Factory contract deployed to:", factoryContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
