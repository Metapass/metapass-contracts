const hre = require("hardhat");

async function main() {
	const MetaHuddle = await hre.ethers.getContractFactory("MetaHuddle");
	const huddleContract = await MetaHuddle.deploy(
		"0x326c977e6efc84e512bb9c30f76e30c160ed06fb"
	);

	await huddleContract.deployed();

	console.log("Huddle contract deployed to:", huddleContract.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
