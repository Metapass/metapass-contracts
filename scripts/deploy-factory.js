const hre = require("hardhat");

async function main() {
  const MetapassFactory = await hre.ethers.getContractFactory(
    "MetapassFactory"
  );
  const factoryContract = await MetapassFactory.deploy();

  await factoryContract.deployed();

  console.log("Factory contract deployed to:", factoryContract.address);

  let txn = await factoryContract.createEvent();
  await txn.wait();
  txn = await factoryContract.getEventChildren();
  console.log(txn);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
