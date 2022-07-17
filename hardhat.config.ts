import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import { formatEther, parseEther } from "ethers/lib/utils";
dotenv.config();

task("faucet", "Sends ETH and tokens to an address")
  .addPositionalParam("receiver", "The address that will receive them")
  .setAction(async ({ receiver }, { ethers }) => {
    await ethers.provider.send("hardhat_setBalance", [
      receiver,
      parseEther("1000").toHexString(),
    ]);
    console.log(`Transferred 1000 ETH to ${receiver}`);
    console.log(
      `balance: ${formatEther(await ethers.provider.getBalance(receiver))}`
    );
  });
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.15",
    settings: {
      // evmVersion: "byzantium",
      optimizer: {
        enabled: true,
        runs: 800,
      },
    },
  },

  networks: {
    hardhat: {
      gas: "auto",
      chainId: 31337,
    },
    localnet: {
      chainId: 31337,
      url: "http://localhost:1248",
      httpHeaders: {
        origin: "http://localhost:3000",
      },
    },
    frame: {
      chainId: 56,
      url: "http://localhost:1248",
      httpHeaders: {
        origin: "http://localhost:3000",
      },
    },
    localnet0: {
      url: "http://localhost:8545",
      loggingEnabled: true,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      bsc: process.env.BSCSCAN_APIKEY ?? "",
    },
  },
};

export default config;
