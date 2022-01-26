const hre = require("hardhat");
const address = require("../airdrop.json");
const axios = require("axios");
const { create, urlSource } = require("ipfs-http-client");

async function main() {
  const MetaSupporters = await hre.ethers.getContractFactory("MetaSupporters");
  const metaSupportersContract = await MetaSupporters.deploy();

  const ipfs = create({
    host: "ipfs.infura.io",
    port: 5001,
    protocol: "https",
  });

  await metaSupportersContract.deployed();

  console.log("Contract deployed to:", metaSupportersContract.address);

  for (let i = 0; i < address.length; i++) {
    let image = await axios.get(
      `http://radiant-caverns-43873.herokuapp.com/voter/person=${
        address[i].userName
      }&ticket_no=${i + 1}`
    );

    const file = await ipfs.add(urlSource(image.data[0]));

    let cid = file.cid.toString();

    let metadata = {
      name: "Early supporter NFT for " + address[i].userName,
      description: `${address[i].userName}, thank you for being a early supporter for Metapass. Here is a token of our appreciation.`,
      image: `https://ipfs.io/ipfs/${cid}`,
      properties: {
        "Ticket Number": i + 1,
      },
    };

    try {
      let txn = await metaSupportersContract.mintNFT(
        address[i].walletAddress,
        JSON.stringify(metadata)
      );

      await txn.wait();
    } catch (e) {
      console.log(e);
    } finally {
      console.log(address[i].walletAddress);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
