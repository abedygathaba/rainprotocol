const USH = artifacts.require('USH')
const ReignCoin = artifacts.require('ReignCoin')
const ReignProtocol = artifacts.require('ReignProtocol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

contract('ReignProtocol', (accounts) => {
  
//Before tests, we deploy the USH, ReignCoin, and ReignProtocol contracts
//We then transfer all the Roman Coins to the ReignProtocol smart contract
//We then transfer 1000000 each of the rUSDC Tokens to 6 addresses
  let USHInstance, ReignCoinInstance, ReignProtocolInstance;

  before(async () => {

   //Get all the deployed contracts
    USHInstance = await USH.new();
    ReignCoinInstance = await ReignCoin.new();
    ReignProtocolInstance = await ReignProtocol.new(USHInstance.address, ReignCoinInstance.address);

    //Transfer 350 million Roman Coins to the ReignProtocol smart contract
    await ReignCoinInstance.transfer(ReignProtocolInstance.address, tokens('350000000'))

    //Transfer 1000000 rUSDC Tokens to 1 addresses
    await USHInstance.transfer(accounts[1], tokens('350000000'), {from: accounts[0]})
    



    

    
  })


//Test Case 1: Test the name of the contract
  describe('Test the name of the ReignProtocol contract', async () => {
   
    it('Check the name of the contract', async () => {
      const name = await ReignProtocolInstance.name();
      assert.equal(name, 'ReignProtocol');
    });
  }); //End of Test Case 1

 

//Test Case 2: Test the name of USH contract
describe('Test the name of the USH contract', async () => {
   
  it('Check the name of the contract', async () => {
    const name = await USHInstance.name();
    assert.equal(name, 'HARMONY US');
  });

})




//Test Case 3: Test the name of ReignCoin contract
describe('Test the name of the ReignCoin contract', async () => {
  it('Check the name of the contract', async () => {  
    const name = await ReignCoinInstance.name();
    assert.equal(name, 'REIGN COIN');
  });
})




//Test Case 4: Test whether the ReignProtocol contract has all the Roman Coins
describe('Test whether the ReignProtocol contract has all the Roman Coins', async () => {
  it('Check whether the ReignProtocol contract has all the Roman Coins', async () => {
    const balance = await ReignCoinInstance.balanceOf(ReignProtocolInstance.address);
    assert.equal(balance, tokens('350000000'));
  });
})



//Test Case 5: Test whether the ReignProtocol contract rewards the users
describe('Test whether the ReignProtocol contract rewards the users', async () => {
  
  
  it('Check whether the ReignProtocol contract rewards the users', async () => {
    //Test Case 5.1: Test whether the balance is correct before staking
    const balance = await USHInstance.balanceOf(accounts[1]);
    assert.equal(balance.toString(), tokens('350000000'), 'The rUSDC token balance should be correct before staking');

    //Test Case 5.2: Approve the ReignProtocol contract to spend the rUSDC tokens and then stake
    await USHInstance.approve(ReignProtocolInstance.address, tokens('1000000'), {from: accounts[1]});
    await ReignProtocolInstance.stake(tokens('1000000'), {from: accounts[1]});

    //Test Case 5.3: Test whether the balance is correct after staking
    const balanceAfterStaking = await USHInstance.balanceOf(accounts[1]);
    assert.equal(balanceAfterStaking.toString(), tokens('349000000'), 'The rUSDC token balance should be correct after staking');

    //Test Case 5.4: Test whether the balance of the ReignProtocol contract is correct
    const balanceOfReignProtocol = await USHInstance.balanceOf(ReignProtocolInstance.address);
    assert.equal(balanceOfReignProtocol.toString(), tokens('1000000'), 'The rUSDC token balance of the ReignProtocol contract should be correct');

    //Test Case 5.5: Test the staking balance of the staking address
    const stakingBalance = await ReignProtocolInstance.stakedAmount(accounts[1]);
    assert.equal(stakingBalance.toString(), tokens('1000000'), 'The staking balance of the staking address should be correct');

    //Test Case 5.6: Test the staking status of the staking address
    const stakingStatus = await ReignProtocolInstance.isStaker(accounts[1]);
    assert.equal(stakingStatus, true, 'The staking status of the staking address should be correct');


    //THE FOLLOWING TEST CASES ARE FOR THE REWARDING PART OF THE CONTRACT

    //The owner calls the reward function
    await ReignProtocolInstance.reward({from: accounts[0]});
    
    /*Test Case 5.7: Test the balance of Roman coins in the ReignProtocol contract after rewarding
    const balanceOfReignProtocolAfterRewarding = await ReignCoinInstance.balanceOf(ReignProtocolInstance.address);
    assert.equal(balanceOfReignProtocolAfterRewarding.toString(), tokens('349f000000'), 'The Roman coin balance of the ReignProtocol contract should be correct after rewarding');
    */


    //Test Case 5.8: Test the balance of the staking address after rewarding
    const balanceOfStakingAddressAfterRewarding = await ReignCoinInstance.balanceOf(accounts[1]);
    assert.equal(balanceOfStakingAddressAfterRewarding.toString(), tokens('1000000'), 'The Roman coin balance of the staking address should be correct after rewarding');

    //Test Case 5.9: Test the staking status of the staking address after rewarding
    const stakingStatusAfterRewarding = await ReignProtocolInstance.isStaker(accounts[1]);
    assert.equal(stakingStatusAfterRewarding, true, 'The staking status of the staking address should be correct after rewarding');

    //Test Case 5.10: Test that only the owner can call the reward function
    await ReignProtocolInstance.reward({from: accounts[1]}).should.be.rejected;

    //THE FOLLOWING TEST CASES ARE FOR THE REDEEMING PART OF THE CONTRACT

    //Test Case 5.11: Test the balance of the staking address AFTER redeeming USH
    const balanceOfStakingAddressAfterRedeeming = await USHInstance.balanceOf(accounts[1]);
    assert.equal(balanceOfStakingAddressAfterRedeeming.toString(), tokens('349000000'), 'The rUSDC token balance of the staking address should be correct after redeeming');

    //Test Case 5.12: Test the staking balance of the staking address AFTER redeeming USH
    const stakingBalanceAfterRedeeming = await ReignProtocolInstance.stakedAmount(accounts[1]);
    assert.equal(stakingBalanceAfterRedeeming.toString(), tokens('1000000'), 'The staking balance of the staking address should be correct after redeeming');

    //Test Case 5.13: Test the staking status of the staking address AFTER redeeming USH
    const stakingStatusAfterRedeeming = await ReignProtocolInstance.isStaker(accounts[1]);
    assert.equal(stakingStatusAfterRedeeming, true, 'The staking status of the staking address should be correct after redeeming');



  });



})
})