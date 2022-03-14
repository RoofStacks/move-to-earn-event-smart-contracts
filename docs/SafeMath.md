# SafeMath.sol

View Source: [@openzeppelin/contracts/utils/math/SafeMath.sol](../@openzeppelin/contracts/utils/math/SafeMath.sol)

**SafeMath**

Wrappers over Solidity's arithmetic operations.
 NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 now has built in overflow checking.

## Functions

- [tryAdd(uint256 a, uint256 b)](#tryadd)
- [trySub(uint256 a, uint256 b)](#trysub)
- [tryMul(uint256 a, uint256 b)](#trymul)
- [tryDiv(uint256 a, uint256 b)](#trydiv)
- [tryMod(uint256 a, uint256 b)](#trymod)
- [add(uint256 a, uint256 b)](#add)
- [sub(uint256 a, uint256 b)](#sub)
- [mul(uint256 a, uint256 b)](#mul)
- [div(uint256 a, uint256 b)](#div)
- [mod(uint256 a, uint256 b)](#mod)
- [sub(uint256 a, uint256 b, string errorMessage)](#sub)
- [div(uint256 a, uint256 b, string errorMessage)](#div)
- [mod(uint256 a, uint256 b, string errorMessage)](#mod)

### tryAdd

Returns the addition of two unsigned integers, with an overflow flag.
 _Available since v3.4._

```js
function tryAdd(uint256 a, uint256 b) internal pure
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### trySub

Returns the substraction of two unsigned integers, with an overflow flag.
 _Available since v3.4._

```js
function trySub(uint256 a, uint256 b) internal pure
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### tryMul

Returns the multiplication of two unsigned integers, with an overflow flag.
 _Available since v3.4._

```js
function tryMul(uint256 a, uint256 b) internal pure
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### tryDiv

Returns the division of two unsigned integers, with a division by zero flag.
 _Available since v3.4._

```js
function tryDiv(uint256 a, uint256 b) internal pure
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### tryMod

Returns the remainder of dividing two unsigned integers, with a division by zero flag.
 _Available since v3.4._

```js
function tryMod(uint256 a, uint256 b) internal pure
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### add

Returns the addition of two unsigned integers, reverting on
 overflow.
 Counterpart to Solidity's `+` operator.
 Requirements:
 - Addition cannot overflow.

```js
function add(uint256 a, uint256 b) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### sub

Returns the subtraction of two unsigned integers, reverting on
 overflow (when the result is negative).
 Counterpart to Solidity's `-` operator.
 Requirements:
 - Subtraction cannot overflow.

```js
function sub(uint256 a, uint256 b) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### mul

Returns the multiplication of two unsigned integers, reverting on
 overflow.
 Counterpart to Solidity's `*` operator.
 Requirements:
 - Multiplication cannot overflow.

```js
function mul(uint256 a, uint256 b) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### div

Returns the integer division of two unsigned integers, reverting on
 division by zero. The result is rounded towards zero.
 Counterpart to Solidity's `/` operator.
 Requirements:
 - The divisor cannot be zero.

```js
function div(uint256 a, uint256 b) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### mod

Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
 reverting when dividing by zero.
 Counterpart to Solidity's `%` operator. This function uses a `revert`
 opcode (which leaves remaining gas untouched) while Solidity uses an
 invalid opcode to revert (consuming all remaining gas).
 Requirements:
 - The divisor cannot be zero.

```js
function mod(uint256 a, uint256 b) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 

### sub

Returns the subtraction of two unsigned integers, reverting with custom message on
 overflow (when the result is negative).
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {trySub}.
 Counterpart to Solidity's `-` operator.
 Requirements:
 - Subtraction cannot overflow.

```js
function sub(uint256 a, uint256 b, string errorMessage) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 
| errorMessage | string |  | 

### div

Returns the integer division of two unsigned integers, reverting with custom message on
 division by zero. The result is rounded towards zero.
 Counterpart to Solidity's `/` operator. Note: this function uses a
 `revert` opcode (which leaves remaining gas untouched) while Solidity
 uses an invalid opcode to revert (consuming all remaining gas).
 Requirements:
 - The divisor cannot be zero.

```js
function div(uint256 a, uint256 b, string errorMessage) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 
| errorMessage | string |  | 

### mod

Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
 reverting with custom message when dividing by zero.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryMod}.
 Counterpart to Solidity's `%` operator. This function uses a `revert`
 opcode (which leaves remaining gas untouched) while Solidity uses an
 invalid opcode to revert (consuming all remaining gas).
 Requirements:
 - The divisor cannot be zero.

```js
function mod(uint256 a, uint256 b, string errorMessage) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| a | uint256 |  | 
| b | uint256 |  | 
| errorMessage | string |  | 

## Contracts

* [GoArtCampaign](GoArtCampaign.md)
* [Migrations](Migrations.md)
* [SafeMath](SafeMath.md)
