const hre = require("hardhat");

async function main() {
	const MetapassFactory = await hre.ethers.getContractFactory(
		"MetapassFactory"
	);
	const factoryContract = await MetapassFactory.deploy(
		"0x3e4f13d936176A1cD21757d2725e66Af6F1c12C5",
		"0x9e248FdC510E96556635dbF354605533e005337f"
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
