const hre = require("hardhat");
const address = require("../airdrop.json");
const axios = require("axios");
const { create } = require("ipfs-http-client");

async function main() {
  const ZoAfterParty = await hre.ethers.getContractFactory("ZoAfterParty");
  const zoAfterPartyContract = await ZoAfterParty.deploy();

  const ipfs = create({
    host: "ipfs.infura.io",
    port: 5001,
    protocol: "https",
  });

  await zoAfterPartyContract.deployed();

  console.log("Contract deployed to:", zoAfterPartyContract.address);

  for (let i = 0; i < address.length; i++) {
    // let image =
    //   "https://ipfs.io/ipfs/QmdRu4N8EQWnhPR5R3PmVi8dQTiqmYv7P1SR5SxZErjfZm";

    // const file = await ipfs.add(image);

    let cid = "QmdRu4N8EQWnhPR5R3PmVi8dQTiqmYv7P1SR5SxZErjfZm";

    let metadata = {
      name: "ZoWorld After Party Ticket",
      description: `Use verify.metapasshq.xyz to check in with this NFT at the event.`,
      image: `https://ipfs.io/ipfs/${cid}`,
      properties: {
        "Ticket Number": i + 1,
      },
    };

    try {
      let txn = await zoAfterPartyContract.mintNFT(
        address[i].address,
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
