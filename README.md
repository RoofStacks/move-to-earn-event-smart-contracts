## Move to Earn Campaign Smart Contract

---

_GoArt's Move To Earn Campaign Smart Contract to give away MATIC tokens to users playing the GoArt game and collecting the collectible items placed in different time portals inside the game._

### Development Instructions

- `$ npm install` - _Install all dependencies_
- `$ cp .env.example .env` - _Create .env file and fill in MNEMONIC and POLYGON_TESTNET_URL_
- `$ truffle compile` - _Compile all contracts_
- `$ truffle test` - _Run all tests_
- `$ truffle deploy --network matic` - _Deploy on the Polygon Tesnet Mumbai_
- `$ truffle run verify GoArtCampaign --network matic` - _Verify contract on the Polygonscan Tesnet Mumbai_

### GoArtCampaign Contract

- **Deployed to Polygon Testnet Mumbai**
- **Contract address:** `0x862Aaf58b6D1022a64565fB988D90fac468Ca3bf`
