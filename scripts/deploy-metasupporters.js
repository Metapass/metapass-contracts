const hre = require("hardhat");

async function main() {
  const MetaSupporters = await hre.ethers.getContractFactory("MetaSupporters");
  const metaSupportersContract = await MetaSupporters.deploy();

  await metaSupportersContract.deployed();

  console.log("Contract deployed to:", metaSupportersContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
