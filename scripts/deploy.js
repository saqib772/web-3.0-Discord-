const hre = require("hardhat")

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), 'ether')
}

async function main() {
  //setup accounts & variables;
  const [deployer] = await ethers.getSigners()
  const NAME = "Dappcord";
  const SYMBOL = "DC";

  //deploy contract
  const Dappcord = await ethers.getContractFactory("Dappcord");
  const dappcord = await Dappcord.deploy(NAME, SYMBOL);
  await dappcord.deployed();

  console.log("Dappcord deployed to:", dappcord.address);

  //create channel 3 times
  const channel_nnsmes = ["General", "intro", "jobs"];
  const COSTS = [tokens(0.1), tokens(0.2), tokens(0.3)]
  for (var i = 0; i < 3; i++) {
    const transcation = await dappcord.connect(deployer).createChannel(channel_nnsmes[i], COSTS[i]);
    await transcation.wait();

    console.log("Channel created:", channel_nnsmes[i]);
  }

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});