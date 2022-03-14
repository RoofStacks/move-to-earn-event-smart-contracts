# GoArtCampaign (GoArtCampaign.sol)

View Source: [contracts/GoArtCampaign.sol](../contracts/GoArtCampaign.sol)

**GoArtCampaign**

Distribute MATIC tokens in exchange for GoArt MTE Points collected within in the GoArt game.

**Enums**
### State

```js
enum State {
 Active,
 Closed,
 Finalized
}
```

## Structs
### Participant

```js
struct Participant {
 string userId,
 address payable walletAddress,
 uint256 claimed,
 uint256 claimable
}
```

## Contract Members
**Constants & Variables**

```js
enum GoArtCampaign.State public state;
uint256 public maxRewardTotal;
uint256 public totalDistributedReward;
address payable public treasuryWallet;
uint256 public fee;
uint256 public minimumAmountToWithdraw;
uint256 public ratio;
struct GoArtCampaign.Participant[] public participants;
address[] public admins;
mapping(address => bool) public walletsRegistered;
mapping(string => bool) public userIdsRegistered;
mapping(address => bool) public isAdmin;

```

**Events**

```js
event ParticipantRegistered(address  walletAddress, string  userId, uint256  participantIndex);
event MTEPointSwapped(uint256  totalAmount, uint256  participantIndex);
event MaticWithdrawn(uint256  amount, uint256  participantIndex);
event StateChanged(uint8  state);
event ParticipantCollectiblesUpdated(uint256  index);
event ParticipantIdUpdated(uint256  index, string  uid);
```

## Modifiers

- [onlyAdmin](#onlyadmin)

### onlyAdmin

```js
modifier onlyAdmin() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [constructor()](#)
- [addAdmin(address _adminAddress)](#addadmin)
- [removeAdmin(address _adminAddress)](#removeadmin)
- [getAllAdmins()](#getalladmins)
- [changeState(uint8 _state)](#changestate)
- [getState()](#getstate)
- [changeMaxReward(uint256 _maxReward)](#changemaxreward)
- [changeRatio(uint256 _ratio)](#changeratio)
- [registerWallet(address payable walletAddress, string userId)](#registerwallet)
- [swapMTEPointsToMatic(uint256 _MTEPointsItemAmount, uint256 _participantIndex)](#swapmtepointstomatic)
- [getAllParticipants()](#getallparticipants)
- [sendMatic(address payable wallet, uint256 amount)](#sendmatic)
- [withdrawMaticTokens(uint256 _participantIndex)](#withdrawmatictokens)
- [setServiceFee(uint256 _fee)](#setservicefee)
- [getServiceFee()](#getservicefee)
- [getMaxRewardTotal()](#getmaxrewardtotal)
- [setMinimumAmount(uint256 _minimumAmount)](#setminimumamount)
- [getMinimumAmount()](#getminimumamount)
- [getTotalDisributedReward()](#gettotaldisributedreward)
- [walletRegistered(address _walletAddress)](#walletregistered)
- [userRegistered(string _uuid)](#userregistered)
- [changeTreasuryWallet(address _walletAddress)](#changetreasurywallet)
- [getParticipant(uint256 index)](#getparticipant)
- [getTotalParticipants()](#gettotalparticipants)
- [updateParticipantClaims(uint256 index, uint256 claimed, uint256 claimable)](#updateparticipantclaims)
- [updateParticipantId(uint256 index, string uid)](#updateparticipantid)

### 

```js
function () public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### addAdmin

```js
function addAdmin(address _adminAddress) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _adminAddress | address |  | 

### removeAdmin

```js
function removeAdmin(address _adminAddress) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _adminAddress | address |  | 

### getAllAdmins

```js
function getAllAdmins() external view
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### changeState

```js
function changeState(uint8 _state) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _state | uint8 |  | 

### getState

```js
function getState() public view
returns(enum GoArtCampaign.State)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### changeMaxReward

```js
function changeMaxReward(uint256 _maxReward) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _maxReward | uint256 |  | 

### changeRatio

```js
function changeRatio(uint256 _ratio) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _ratio | uint256 |  | 

### registerWallet

```js
function registerWallet(address payable walletAddress, string userId) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| walletAddress | address payable |  | 
| userId | string |  | 

### swapMTEPointsToMatic

```js
function swapMTEPointsToMatic(uint256 _MTEPointsItemAmount, uint256 _participantIndex) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _MTEPointsItemAmount | uint256 |  | 
| _participantIndex | uint256 |  | 

### getAllParticipants

```js
function getAllParticipants() public view
returns(struct GoArtCampaign.Participant[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### sendMatic

```js
function sendMatic(address payable wallet, uint256 amount) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| wallet | address payable |  | 
| amount | uint256 |  | 

### withdrawMaticTokens

```js
function withdrawMaticTokens(uint256 _participantIndex) external payable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _participantIndex | uint256 |  | 

### setServiceFee

```js
function setServiceFee(uint256 _fee) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _fee | uint256 |  | 

### getServiceFee

```js
function getServiceFee() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### getMaxRewardTotal

```js
function getMaxRewardTotal() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### setMinimumAmount

```js
function setMinimumAmount(uint256 _minimumAmount) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _minimumAmount | uint256 |  | 

### getMinimumAmount

```js
function getMinimumAmount() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### getTotalDisributedReward

```js
function getTotalDisributedReward() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### walletRegistered

```js
function walletRegistered(address _walletAddress) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _walletAddress | address |  | 

### userRegistered

```js
function userRegistered(string _uuid) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _uuid | string |  | 

### changeTreasuryWallet

```js
function changeTreasuryWallet(address _walletAddress) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| _walletAddress | address |  | 

### getParticipant

```js
function getParticipant(uint256 index) public view
returns(struct GoArtCampaign.Participant)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 

### getTotalParticipants

```js
function getTotalParticipants() public view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### updateParticipantClaims

```js
function updateParticipantClaims(uint256 index, uint256 claimed, uint256 claimable) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 
| claimed | uint256 |  | 
| claimable | uint256 |  | 

### updateParticipantId

```js
function updateParticipantId(uint256 index, string uid) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 |  | 
| uid | string |  | 

## Contracts

* [GoArtCampaign](GoArtCampaign.md)
* [Migrations](Migrations.md)
* [SafeMath](SafeMath.md)
