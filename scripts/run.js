const hre = require("hardhat");

async function main() {
    const Metapass = await hre.ethers.getContractFactory("Metapass");
    const metapassContract = await Metapass.deploy();

    await metapassContract.deployed();

    console.log("Contract deployed to:", metapassContract.address);

    let txn = await metapassContract._toggleMinting();
    await txn.wait();
    console.log("Minting is on now")
}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });