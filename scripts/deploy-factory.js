const hre = require("hardhat");

async function main() {
  const MetapassFactory = await hre.ethers.getContractFactory(
    "MetapassFactory"
  );
  const factoryContract = await MetapassFactory.deploy(
    "0x5a1E3Eee7890Ad7092Ba130d04521424f33334f0"
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
