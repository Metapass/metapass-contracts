const hre = require("hardhat");

async function main() {
    const Polytix = await hre.ethers.getContractFactory("Polytix");
    const polytixContract = await Polytix.deploy();

    await polytixContract.deployed();

    console.log("Contract deployed to:", polytixContract.address);

    let txn = await polytixContract._toggleMinting();
    await txn.wait();
    console.log("Minting is on now")
    // txn = await polytixContract.getTix("0x4006c21A130D70000f59e009E4f81DB18eb1Ef00", "{'metadata': 'test'}", {
    //     value: 100,
    // });
    // await txn.wait();

    // txn = await polytixContract._claims();
    // await txn.wait();

}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });