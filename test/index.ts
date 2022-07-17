import { ethers } from "hardhat";

describe("lkjklj", function () {
  it("Slkjlkjanged", async function () {
    const fac = await ethers.getContractFactory("RandV3");
    const randv1 = await fac.deploy();
    await randv1.deployed();
    console.log("seeded:", await randv1.seeded([]));
    console.log("rand:", await randv1.rand([]));
  });
});
