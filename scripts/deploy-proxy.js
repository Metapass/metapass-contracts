const hre = require("hardhat");

async function main() {
    const StorageProxy = await hre.ethers.getContractFactory(
        "StorageProxy"
    );
    const proxy = await StorageProxy.deploy(
        "0x8129fc1c",
        // Mumbai Storage on 27 July 2022, 6:35PM
        "0xA53a727f7daCE0cD62C8a2308498C4D9b51DA9e1"
    );

    await proxy.deployed();

    console.log("Factory contract deployed to:", proxy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
