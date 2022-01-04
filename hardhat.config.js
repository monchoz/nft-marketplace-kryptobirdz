/**
 * Hardhat is an Ethereum development environment.
 * Easily deploy your contracts, run tests and debug
 * Solidity code without dealing with live environments.
 */
require("@nomiclabs/hardhat-waffle");

const projectId = "5c5f64ab992042249546311c52501f66";
const fs = require("fs");
// DO NOT SETUP A PRIVATE KEY LIKE THIS IN PRODUCTION
// This private key comes from a dummy wallet
const keyData = fs.readFileSync("./private-key.txt", {
  encoding: "utf8",
  flag: "r",
});

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1333, // config standard
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [keyData],
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${projectId}`,
      accounts: [keyData],
    },
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
