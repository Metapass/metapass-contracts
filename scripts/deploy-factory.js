const hre = require("hardhat");

async function main() {
  const MetapassFactory = await hre.ethers.getContractFactory(
    "MetapassFactory"
  );
  const factoryContract = await MetapassFactory.deploy(
    "0x9eBF87df7877fe3D06051ee53916Ce828cF261f6"
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
