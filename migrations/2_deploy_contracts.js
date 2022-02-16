const GoArtCampaign = artifacts.require("GoArtCampaign");

module.exports = async function (deployer) {
  await deployer.deploy(GoArtCampaign);
};
