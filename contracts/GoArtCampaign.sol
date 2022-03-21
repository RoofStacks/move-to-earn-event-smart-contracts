// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

/**
 * @title GoArtCampaign
 * @dev Distribute MATIC tokens in exchange for GoArt MTE Points collected within in the GoArt game.
 */
contract GoArtCampaign {
	// using SafeMath to prevent underflow & overflow bugs
	using SafeMath for uint256;

	// contract's states are defined here.
	enum State {
		Active,
		Closed,
		Finalized
	}

	State public state = State.Closed;

	uint256 public maxRewardTotal = 200000 ether;
	uint256 public totalDistributedReward;

	// funding wallet of the contract
	address payable public treasuryWallet;

	// service cost set by us
	uint256 public fee = 0.1 ether;

	// min amount
	uint256 public minimumAmountToWithdraw = 1 ether;

	// point to reward ratio
	uint256 public ratio = 10;

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
	mapping(address => bool) public walletsRegistered;

	// mappings to store registered userIds to prevent same user joining the campaign multiple times.
	mapping(string => bool) public userIdsRegistered;

	// Modifier for easier checking if user is admin
	mapping(address => bool) public isAdmin;

	// event for EVM logging
	event ParticipantRegistered(address walletAddress, string userId, uint256 participantIndex);
	event MTEPointSwapped(uint256 totalAmount, uint256 participantIndex);
	event MaticWithdrawn(uint256 amount, uint256 participantIndex);
	event StateChanged(uint8 state);
	event MaxRewardUpdated(uint256 maxReward);
	event RatioUpdated(uint256 ratio);
	event ServiceFeeUpdated(uint256 fee);
	event TreasuryWalletUpdated(address walletAddress);
	event MinimumAmountUpdated(uint256 minimumAmount);
	event ParticipantCollectiblesUpdated(uint256 index);
	event ParticipantIdUpdated(uint256 index, string uid);

	// Modifier restricting access to only admin
	modifier onlyAdmin() {
		require(isAdmin[msg.sender], 'Only admin can call.');
		_;
	}

	/**
	 * @dev Constructor to set initial admins during deployment
	 *
	 */
	constructor() {
		treasuryWallet = payable(msg.sender);
		admins.push(msg.sender);
		isAdmin[msg.sender] = true;
		totalDistributedReward = 0;
	}

	/**
	 * @dev register a new admin with the given wallet address
	 *
	 * @param _adminAddress admin address to be added
	 */
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

	/**
	 * @dev remove an existing admin address
	 *
	 * @param _adminAddress admin address to be removed
	 */
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

	/**
	 * @dev Change the current state of the contractregister a new admin with the given wallet address
	 *
	 * @param _state new state to be set
	 */
	function changeState(uint8 _state) external onlyAdmin {
		require(_state <= uint8(State.Finalized), 'Given state is not a valid state');
		// change the state to given state index.
		state = State(_state);
		// emit the changed state.
		emit StateChanged(_state);
	}

	// See the current state
	function getState() public view returns (State) {
		return state;
	}

	/**
	 * @dev Change the contract's max reward amount
	 *
	 * @param _maxReward new max reward
	 */
	function changeMaxReward(uint256 _maxReward) external onlyAdmin {
		maxRewardTotal = _maxReward;
		emit MaxRewardUpdated(_maxReward);
	}

	/**
	 * @dev Change award ratio
	 *
	 * @param _ratio new award ratio
	 */
	function changeRatio(uint256 _ratio) external onlyAdmin {
		ratio = _ratio;
		emit RatioUpdated(_ratio);
	}

	/**
	 * @dev Register a user's wallet address if the contract is in Active state.
	 *
	 * @param walletAddress wallet address to be registered
	 * @param userId userId of the new user to be registered
	 */
	function registerWallet(address payable walletAddress, string memory userId)
		external
		onlyAdmin
	{
		require(state == State.Active, 'Contract is not in active state at the moment!');
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

	/**
	 * @dev A user's MTE points can be swapped to MATIC through this function.
	 *
	 * @param _MTEPointsItemAmount Amount of MTE points to be swapped
	 * @param _participantIndex Participant index
	 */
	function swapMTEPointsToMatic(uint256 _MTEPointsItemAmount, uint256 _participantIndex)
		external
		onlyAdmin
	{
		require(state != State.Finalized, 'Contract is finalized. You cannot swap!');
		require(_participantIndex < participants.length, 'Participant Index is out of bounds.');
		require(
			_MTEPointsItemAmount > 0,
			'_MTEPointsItemAmount to be swapped has to be greater than 0.'
		);

		Participant storage participant = participants[_participantIndex];
		uint256 maticAmount = _MTEPointsItemAmount.div(ratio);
		participant.claimable = participant.claimable.add(maticAmount);

		emit MTEPointSwapped(participant.claimable, _participantIndex);
	}

	// return all participants
	function getAllParticipants() public view returns (Participant[] memory) {
		return participants;
	}

	/**
	 * @dev Transfer MATIC to given address.
	 *
	 * @param wallet recepient
	 * @param amount amount to be sent
	 */
	function sendMatic(address payable wallet, uint256 amount) internal {
		(bool success, ) = wallet.call{value: amount}('');
		require(success, 'Transfer failed during sending Matic tokens');
	}

	/**
	 * @dev Withdraw MATIC tokens for the given user
	 *
	 * @param _participantIndex Participant index of the user for withdrawal
	 */
	function withdrawMaticTokens(uint256 _participantIndex) external payable onlyAdmin {
		require(state != State.Finalized, 'Contract is finalized. You cannot withdraw!');
		require(_participantIndex < participants.length, 'Participant Index is out of bounds.');

		require(
			msg.value >= minimumAmountToWithdraw,
			'You can withdraw minimum 1 MATIC. Anything below is not allowed.'
		);

		uint256 amountToBeWithdrawn = msg.value.sub(fee);

		require(
			totalDistributedReward + msg.value <= maxRewardTotal,
			'Given amount exceeds the total reward to be distributed from this contract'
		);

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
		sendMatic(treasuryWallet, fee);

		totalDistributedReward = totalDistributedReward.add(msg.value);

		emit MaticWithdrawn(msg.value, _participantIndex);
	}

	/**
	 * @dev Set new service fee
	 *
	 * @param _fee New fee
	 */
	function setServiceFee(uint256 _fee) external onlyAdmin {
		fee = _fee;
		emit ServiceFeeUpdated(_fee);
	}

	// get service fee
	function getServiceFee() public view returns (uint256) {
		return fee;
	}

	// get maximum reward total
	function getMaxRewardTotal() public view returns (uint256) {
		return maxRewardTotal;
	}

	/**
	 * @dev Set minimum amount to withdraw
	 *
	 * @param _minimumAmount New minimum amount for withdrawal
	 */
	function setMinimumAmount(uint256 _minimumAmount) external onlyAdmin {
		minimumAmountToWithdraw = _minimumAmount;
		emit MinimumAmountUpdated(_minimumAmount);
	}

	// get minimum amount
	function getMinimumAmount() public view returns (uint256) {
		return minimumAmountToWithdraw;
	}

	// get total distributed reward
	function getTotalDisributedReward() public view returns (uint256) {
		return totalDistributedReward;
	}

	/**
	 * @dev check if a wallet is registered
	 *
	 * @param _walletAddress Wallet address of the user
	 * @return bool true if _walletAddress is registered.
	 */
	function walletRegistered(address _walletAddress) public view returns (bool) {
		return walletsRegistered[_walletAddress];
	}

	/**
	 * @dev check if userId is registered
	 *
	 * @param _uuid userId of the user
	 * @return bool true if _uuid is registered.
	 */
	function userRegistered(string memory _uuid) public view returns (bool) {
		return userIdsRegistered[_uuid];
	}

	/**
	 * @dev change the treasury wallet
	 *
	 * @param _walletAddress new treasury wallet address
	 */
	function changeTreasuryWallet(address _walletAddress) external onlyAdmin {
		treasuryWallet = payable(_walletAddress);
		emit TreasuryWalletUpdated(_walletAddress);
	}

	/**
	 * @dev Get a single participany by index
	 *
	 * @param index Participant index
	 * @return Participant the corresponding participant struct
	 */
	function getParticipant(uint256 index) public view returns (Participant memory) {
		return participants[index];
	}

	// get number of participants
	function getTotalParticipants() public view returns (uint256) {
		return participants.length;
	}

	/**
	 * @dev Update the participant
	 *
	 * @param index Participant index
	 * @param claimed New claimed value
	 * @param claimable New claimable value
	 */
	function updateParticipantClaims(
		uint256 index,
		uint256 claimed,
		uint256 claimable
	) external onlyAdmin {
		require(index < participants.length, 'Participant Index is out of bounds.');
		Participant storage participant = participants[index];
		participant.claimed = claimed;
		participant.claimable = claimable;
		emit ParticipantCollectiblesUpdated(index);
	}

	/**
	 * @dev Update userId in case of an emergency
	 *
	 * @param index Participant index
	 * @param uid New userId
	 */
	function updateParticipantId(uint256 index, string memory uid) external onlyAdmin {
		require(!userIdsRegistered[uid], 'This user id is registered earlier.');
		require(index < participants.length, 'Participant Index is out of bounds.');
		Participant storage participant = participants[index];
		participant.userId = uid;
		userIdsRegistered[uid] = true;
		emit ParticipantIdUpdated(index, uid);
	}
}
