// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

/**
 * @title GoArtCampaign
 * @dev Distribute MATIC tokens in exchange for GoArt Colletible Items collected within in the GoArt game.
 */
contract GoArtCampaign {
	// using SafeMath to prevent underflow & overflow bugs
	using SafeMath for uint256;

	// contract's states are defined here.
	enum State {Active,Closed}

	State public state = State.Closed;

	uint256 public maxRewardTotal = 200000 ether;
	uint256 public totalDistributedReward;

	// funding wallet of the contract
	address payable public fundingWallet;

	// service cost set by us
	uint256 fee = 0.1 ether;

	// min amount
	uint256 minimumAmountToWithdraw = 1 ether;

	// point to reward ratio
	uint ratio = 20;

	// Participant structure for players
	struct Participant {
		string userId;
		address payable walletAddress;
		uint256 claimed;
		uint256 claimable;
	}

	// Store the participants in an array
	Participant[] public participants;

	// Listing all admins
	address[] public admins;

	// mappings to store registered wallet addresses
	mapping(address => bool) walletsRegistered;

	// mappings to store registered userIds to prevent same user joining the campaign multiple times.
	mapping(string => bool) userIdsRegistered;

	// Modifier for easier checking if user is admin
	mapping(address => bool) public isAdmin;

	// event for EVM logging
	event ParticipantRegistered(address walletAddress, string userId, uint256 participantIndex);
	event CollectibleItemSwapped(uint256 totalAmount, uint256 participantIndex);
	event MaticWithdrawn(uint256 amount, uint256 participantIndex);

	// Modifier restricting access to only admin
	modifier onlyAdmin() {
		require(isAdmin[msg.sender], 'Only admin can call.');
		_;
	}

	// Constructor to set initial admins during deployment
	constructor() {
		fundingWallet = payable(msg.sender);
		admins.push(msg.sender);
		isAdmin[msg.sender] = true;
		totalDistributedReward = 0;
	}

	// register a new admin with the given wallet address
	function addAdmin(address _adminAddress) external onlyAdmin {
		// Can't add 0x address as an admin
		require(_adminAddress != address(0x0), '[RBAC] : Admin must be != than 0x0 address');
		// Can't add existing admin
		require(!isAdmin[_adminAddress], '[RBAC] : Admin already exists.');
		// Add admin to array of admins
		admins.push(_adminAddress);
		// Set mapping
		isAdmin[_adminAddress] = true;
	}

	// remove an existing admin address
	function removeAdmin(address _adminAddress) external onlyAdmin {
		// Admin has to exist
		require(isAdmin[_adminAddress]);
		require(admins.length > 1, 'Can not remove all admins since contract becomes unusable.');
		uint256 i = 0;

		while (admins[i] != _adminAddress) {
			if (i == admins.length) {
				revert('Passed admin address does not exist');
			}
			i++;
		}

		// Copy the last admin position to the current index
		admins[i] = admins[admins.length - 1];

		isAdmin[_adminAddress] = false;

		// Remove the last admin, since it's double present
		admins.pop();
	}

	// Fetch all admins
	function getAllAdmins() external view returns (address[] memory) {
		return admins;
	}

	// Set contract State as Active
	function setStateActive() external onlyAdmin {
		state = State.Active;
	}

	// Set contract State as Closed
	function setStateClosed() external onlyAdmin {
		state = State.Closed;
	}

	// Change the contract's max reward amount
	function changeMaxReward(uint256 _maxReward) external onlyAdmin {
		maxRewardTotal = _maxReward;
	}

	// register a user's wallet address if the contract is in Active state.
	function registerWallet(address payable walletAddress, string memory userId) external onlyAdmin {
		require(state == State.Active, "Contract is not in active state at the moment!");
		require(
			!walletsRegistered[walletAddress],
			'This wallet has been used to register earlier.'
		);
		require(!userIdsRegistered[userId], 'This user id is registered earlier.');

		walletsRegistered[walletAddress] = true;
		userIdsRegistered[userId] = true;

		Participant memory participant = Participant(userId, walletAddress, 0, 0);
		participants.push(participant);

		emit ParticipantRegistered(walletAddress, userId, participants.length - 1);
	}

	// A user's collectible items can be swapped to MATIC through this function.
	function swapCollectibleItemsToMatic(uint256 _collectibleItemAmount, uint256 _participantIndex) external onlyAdmin {
		require(state == State.Active, "Contract is not in active state at the moment!");
		require(_collectibleItemAmount > 0, '_collectibleItemAmount to be swapped has to be greater than 0.');

		Participant storage participant = participants[_participantIndex];
		uint256 maticAmount = _collectibleItemAmount.div(ratio);
		participant.claimable = participant.claimable.add(maticAmount);

		emit CollectibleItemSwapped(participant.claimable, _participantIndex);
	}

	// return all participants
	function getAllParticipants() public view returns (Participant[] memory) {
		return participants;
	}

	function sendMatic(address payable wallet, uint256 amount) internal {
		(bool success, ) = wallet.call{value: amount}('');
		require(success, 'Transfer failed during sending Matic tokens');
	}

	function withdrawMaticTokens(uint256 _participantIndex)
		external
		payable
		onlyAdmin
	{
		require(state == State.Active, "Contract is not in active state at the moment!");
		require(msg.value >= minimumAmountToWithdraw, "You can withdraw minimum 1 MATIC. Anything below is not allowed.");

		uint256 amountToBeWithdrawn = msg.value.sub(fee);

		require(totalDistributedReward + msg.value <= maxRewardTotal, "Given amount exceeds the total reward to be distributed from this contract");

		Participant storage participant = participants[_participantIndex];
		require(
			participant.claimable.sub(amountToBeWithdrawn) >= 0,
			'Withdraw amount cannot be greater than total claimable amount!'
		);

		// subtract from claimable amount
		participant.claimable = participant.claimable.sub(msg.value);

		// increase the claimed amount with _amount
		participant.claimed = participant.claimed.add(msg.value);

		// transfer the funds
		sendMatic(participant.walletAddress, amountToBeWithdrawn);
		// get the service fee
		sendMatic(fundingWallet,fee);

		totalDistributedReward = totalDistributedReward.add(msg.value);

		emit MaticWithdrawn(msg.value, _participantIndex);
	}
}
