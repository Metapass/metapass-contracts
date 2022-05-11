const hre = require("hardhat");

async function main() {
  const MetaStorage = await hre.ethers.getContractFactory("MetaStorage");
  const metaStorageContract = await MetaStorage.deploy();

  await metaStorageContract.deployed();

  console.log("Storage deployed to: ", metaStorageContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
