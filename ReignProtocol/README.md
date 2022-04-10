

Steps
* `npm install`
* `truffle compile`
* add your private keys to .env file (the deployment requires two private keys)
* `truffle migrate --reset --network testnet`
* `npm start` which should popup http://localhost:3000/ page
* make sure to connect metamask to harmony testnet, as the  contracts are deployed on harmony testnet 

After running the scripts the 
 * ReignCoin HRC20 token is deployed here(https://explorer.testnet.harmony.one/address/0x4372e708c30aa456b7ae4777ba064e673b71e228)
 * USH HRC20 token is deployed here (https://explorer.testnet.harmony.one/address/0xf9455e1a556bf0bfd959764e24a54c212c68d103)
 * REIGNPROTOCOL contract is deployed here (https://explorer.testnet.harmony.one/address/0x48d48ba643b876d4899b7403f91c72f89d984b42)

