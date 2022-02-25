const { v4: uuidv4 } = require('uuid');
const GoArtCampaign = artifacts.require('GoArtCampaign');
const Web3 = require('web3');
const random = require('random');

let contractInstance, fundingWallet, alice, bob, cedric, web3;

contract('GoArtCampaign', async (accounts) => {
	beforeEach(async () => {
		contractInstance = await GoArtCampaign.deployed();
		await contractInstance.setStateActive();
		fundingWallet = accounts[0];
		alice = accounts[1];
		bob = accounts[2];
		cedric = accounts[3];
		web3 = new Web3();
		assert.ok(contractInstance);
	});
	//It adds administrative features to a wallet.
	it('Register an admin', async () => {
		await contractInstance.addAdmin(alice);
		const aliceAdmin = await contractInstance.isAdmin(alice);
		assert.equal(aliceAdmin, true, `${alice} is registered as admin.`);
	});
	//Updates the funding wallet address.
	it('Change funding wallet', async () => {
		const oldFundingWallet = await contractInstance.fundingWallet();
		await contractInstance.changeFundingWallet(cedric);
		const newFundingWallet = await contractInstance.fundingWallet();
		assert.equal(
			newFundingWallet,
			cedric,
			`Old funding wallet: ${oldFundingWallet} is changed to ${newFundingWallet}.`,
		);
	});
	//Updates the maximum reward amount.
	it('Change max reward', async () => {
		const oldReward = await contractInstance.maxRewardTotal();
		const newReward = random.int(100000, 500000);
		await contractInstance.changeMaxReward(await web3.utils.toWei(String(newReward), 'ether'));
		let maxReward = await contractInstance.maxRewardTotal();
		maxReward = await web3.utils.fromWei(String(maxReward));
		assert.equal(maxReward, newReward, `Old reward: ${oldReward} is changed to ${newReward}.`);
	});
	//Updates the point to reward ratio.
	it('Change ratio', async () => {
		const oldRatio = await contractInstance.ratio();
		const newRatio = random.int(1, 99);
		await contractInstance.changeRatio(newRatio);
		const ratio = await contractInstance.ratio();
		assert.equal(ratio, newRatio, `Old ratio: ${oldRatio} is changed to ${newRatio}.`);
	});
	//Defines wallet address to user.
	it('Register a wallet', async () => {
		const uid = uuidv4();
		await contractInstance.registerWallet(bob, uid);
		const bobExists = await contractInstance.walletRegistered(bob);
		assert.equal(bobExists, true, `${bob} is registered.`);
	});
	//Terminates an administrator's authorizations.
	it('Remove admin', async () => {
		await contractInstance.removeAdmin(alice);
		const aliceAdmin = await contractInstance.isAdmin(alice);
		assert.equal(aliceAdmin, false, `${alice} is removed as admin.`);
	});
	//Sets the minimum amount.
	it('Change minimum amount', async () => {
		const oldMinAmount = await contractInstance.getMinimumAmount();
		const newMinAmount = random.int(1, 99);
		await contractInstance.setMinimumAmount(newMinAmount);
		const minAmount = await contractInstance.getMinimumAmount();
		assert.equal(
			minAmount,
			newMinAmount,
			`Old minimum amount: ${oldMinAmount} is changed to ${newMinAmount}.`,
		);
	});
	//Updates the fee rate.
	it('Change service fee', async () => {
		const oldServiceFee = await contractInstance.getServiceFee();
		const newServiceFee = random.int(1, 99);
		await contractInstance.setServiceFee(newServiceFee);
		const serviceFee = await contractInstance.getServiceFee();
		assert.equal(
			serviceFee,
			newServiceFee,
			`Old service fee: ${oldServiceFee} is changed to ${newServiceFee}.`,
		);
	});
	//Defines the values of the selected State enum to the state. (0: Active, 1: Closed)
	it('Change state active', async () => {
		const oldState = await contractInstance.state();
		await contractInstance.setStateActive();
		const state = await contractInstance.getState();
		assert.equal(state, 0, `Old state status: ${oldState} is changed to ${state}.`);
	});
	//Defines the values of the selected State enum to the state. (0: Active, 1: Closed)
	it('Change state closed', async () => {
		const oldState = await contractInstance.state();
		await contractInstance.setStateClosed();
		const state = await contractInstance.getState();
		assert.equal(state, 1, `Old state status: ${oldState} is changed to ${state}.`);
	});
	//Converts items to MATIC.
	it('Swap collectible items to MATIC token', async () => {
		const participantIndex = 0;
		let participants = await contractInstance.getAllParticipants.call();
		const oldAmount = participants[participantIndex]['claimable'];
		const collectibleItemAmount = await web3.utils.toWei(String('200'), 'ether');
		await contractInstance.swapCollectibleItemsToMatic(collectibleItemAmount, participantIndex);
		participants = await contractInstance.getAllParticipants.call();
		const newAmount = participants[participantIndex]['claimable'];
		const ratio = await contractInstance.ratio();
		assert.equal(
			newAmount,
			collectibleItemAmount / ratio,
			`${oldAmount} is increased to ${newAmount} meaning 20 CollectibleItem is added`,
		);
	});
	//Performs the user's MATIC withdrawal.
	it('Withdraw MATIC to account', async () => {
		const claimAmount = await web3.utils.toWei('1', 'ether');
		let participants = await contractInstance.getAllParticipants.call();
		const participantIndex = 0;
		const wd = await contractInstance.withdrawMaticTokens(participantIndex, {
			value: claimAmount,
		});
		participants = await contractInstance.getAllParticipants.call();
		const claimed = participants[participantIndex]['claimed'];
		assert.equal(claimAmount, claimed);
	});
});
