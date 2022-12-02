require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.4",
  networks: {
    // mumbai: {
    //   url: process.env.ALCHEMY_URL,
    //   accounts: [process.env.PRIVATE_KEY],
    // },
    mainnet: {
      url: process.env.ALCHEMY_MAINNET,
      accounts: [process.env.MAINNET_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY,
  },
};
