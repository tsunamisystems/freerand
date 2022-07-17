import { ethers } from "hardhat";
async function run(address: string) {
  const contract = (await ethers.getContractFactory("RandV3")).attach(address);
  console.log("seeded:", await contract.seeded([0]));
  console.log("rand", await contract.rand([0]));
}
async function main() {
  run("0x57794b9C51C879DA6470dD0F6865b2ACF933C7FE");
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
