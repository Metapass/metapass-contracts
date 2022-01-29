const hre = require("hardhat");

async function main() {
  const MetapassFactory = await hre.ethers.getContractFactory(
    "MetapassFactory"
  );
  const factoryContract = await MetapassFactory.deploy(
    "0x2bBF7B77585af7e3F2a0542944e49B92186D0c29"
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
