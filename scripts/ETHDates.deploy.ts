import { ethers } from "hardhat";

(async () => {
  try {
    const ETHDatesFactory = await ethers.getContractFactory("ETHDates");
    const ethDates = await ETHDatesFactory.deploy();
    
    await ethDates.deployed();
    
    console.log("Contract deployed to:", ethDates.address);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
})()
