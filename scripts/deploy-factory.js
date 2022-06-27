const hre = require("hardhat");

async function main() {
	const MetapassFactory = await hre.ethers.getContractFactory(
		"MetapassFactory"
	);
	const factoryContract = await MetapassFactory.deploy(
		"0xEA24e80e4B7A22C2226F9730465Ca07Bc6d5Ab81"
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
