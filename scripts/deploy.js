const hre = require("hardhat");

async function main() {
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy("Asing","AG");

  await myToken.deployed();

  console.log(
       "My token contract address", myToken.address
  );

  const StakingContract = await hre.ethers.getContractFactory("StakingContract");
  const sakingContract = await StakingContract.deploy(10,myToken.address);

  await sakingContract.deployed();

  console.log(
       "Staking contract address", sakingContract.address
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
