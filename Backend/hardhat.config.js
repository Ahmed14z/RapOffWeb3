require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();

console.log(process.env.API_URL);
//const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.18",

  networks: {
    hardhat: {
      chainId: 1337,
    },
    sepolia: {
      chainId: 11155111,
      url: `${process.env.API_URL}`,
      accounts: [`${process.env.PRIVATE_KEY}`],
    },
    mantle: {
      url: "https://rpc.testnet.mantle.xyz/",
      chainId: 5001,
      accounts: [
        "0x5e2f1327a7bd0e106c9bb265dbe362aef5144f1e5525deb07f729deae7e63b1d",
      ],
    
    },
  },
};
