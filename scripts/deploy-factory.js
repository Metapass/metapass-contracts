const hre = require("hardhat");

async function main() {
	const MetapassFactory = await hre.ethers.getContractFactory(
		"MetapassFactory"
	);
	const factoryContract = await MetapassFactory.deploy(
		"0x971173863a52552D25aFC726984bAb3E01F7019B"
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
