const hre = require("hardhat");

async function main() {
  const ZoAfterParty = await hre.ethers.getContractFactory("ZoAfterParty");
  const zoAfterPartyContract = await ZoAfterParty.deploy();

  await zoAfterPartyContract.deployed();

  console.log("Contract deployed to:", zoAfterPartyContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
