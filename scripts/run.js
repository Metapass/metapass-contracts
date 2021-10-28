const hre = require("hardhat");

async function main() {
  const Polytix = await hre.ethers.getContractFactory("Poltix");
  const polytixContract = await Polytix.deploy();

  await greeter.deployed();

  console.log("Greeter deployed to:", greeter.address);

  let txn;

  txn = await polytixContract.getTix("0xDaksh", "{'metadata': 'test'}", {
    value: 100,
  });
  await txn.wait();

  txn = await polytixContract._claims();
  await txn.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
