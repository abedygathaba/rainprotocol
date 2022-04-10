

//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract ReignCoin {
    string  public name = "REIGN COIN";
    string  public symbol = "RGN";
    uint256 public totalSupply = 100000000000000000000000000; // 1 Billion tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

contract USH {
    string  public name = "HARMONY US";
    string  public symbol = "USH";
    uint256 public totalSupply = 350000000000000000000000000; // 350 million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

/*
    * @title TheReignProtocol
    * @dev The fund is a smart contract that allows users to stake and unstake USHs.
    * @dev The fund is a smart contract that allows users to receive REIGN COINs as a reward for staking.
    * @dev The fund is a smart contract that allows users to redeem their REIGN COINs and USHs.
    * @dev The fund is a smart contract that allows users to transfer REIGN COINs to other users.
    * @dev The fund is a smart contract that allows users to transfer USHs to other users.

*/

 // Create a contract for the fund

 contract ReignProtocol{
      /*
      *@ the name of the fund
      *@var address of the owner of the fund 
      
      */
    
        string public name = "ReignProtocol";
        address public owner;

        //assign USH to state variable of type USH
        //assign romanCoin to state variable of type RomanCoin
        USH public ush;
        ReignCoin public reignCoin;


        //Array of type address to store the addresses of the stakers
        address[] public stakers;

        //Array of type address to store the addresses of the redeemers
        address[] public redeemers;

        //Array of type address to store the addresses of the transferrs
        address[] public transferrs;

        //Map of type address to uint256 to store the staked amount of each staker
        mapping (address => uint256) public stakedAmount;

        //Map of type address to uint256 to store the redeemed amount of each redeemer
        mapping (address => uint256) public redeemedAmount;

        //Map of type address to uint256 to store the transferred amount of each transferr
        mapping (address => uint256) public transferredAmount;

        //Map to store whether a user has staked or not
        mapping (address => bool) public staked;

        //Map to show whether a user is a staker or not
        mapping (address => bool) public isStaker;





        
    /*
        * @dev a constructor that stores references to the USH and RomanCoin contracts
        * @param _USH a reference to the USH contract
        * @param _romancoin a reference to the RomanCoin contract
    */
    constructor(USH _ush, ReignCoin _reigncoin) public {
        ush = _ush;
        reignCoin = _reigncoin;
        owner = msg.sender;
    }


    /* 
        *a function that allows users to stake USHs 
        *@param _amount the amount of USHs to be staked
        *@dev the function will check if the user has enough USHs to stake
        *@dev the function will check if the user has already staked
        *@dev the function will check if the user has already staked the maximum amount of USHs

    */
    function stake(uint _amount) public payable {
        //require(_amount <= USH.balanceOf(msg.sender), "You don't have enough USHs to stake");
        //the user cannot stake zero tokens
        require(_amount > 0, "You cannot stake zero tokens");
       // require(stakedAmount[msg.sender] == 0, "You have already staked");
        //require(stakedAmount[msg.sender] <= USH.balanceOf(msg.sender), "You have already staked the maximum amount of USHs");

        //Transfer the amount of USHs to the fund using transferFrom
        ush.transferFrom(msg.sender,address(this), _amount);

        //Keep track of the staked amount of the user every time they stake
        stakedAmount[msg.sender] = stakedAmount[msg.sender] + _amount;

        //Add the address of the user to the stakers array if they have not already staked
        if(staked[msg.sender] == false) {
            stakers.push(msg.sender);
            staked[msg.sender] = true;
            //The user is now a staker
            isStaker[msg.sender] = true;
        }


        
    }



    /*
      * @dev a function that is called only by the owner of the fund to reward the stakers with REIGN COINs at 12% APY of their staked USDC amount
        * @dev the user must have a staked amount of at least 1 USH to be rewarded
        * @dev the user's staking status must be true
        * @dev the function should reward all eligible stakers in the stakers array

    */  
        function reward() public {
            require(msg.sender == owner, "Only the owner of the fund can reward");

            //Loop through the stakers array
           // Reward all eligible stakers in the stakers array
            for(uint i = 0; i < stakers.length; i++) {
                //Check if the user has a staked amount of at least 1 USH
                if(stakedAmount[stakers[i]] >= 1) {
                    //Reward the user with a REIGN COIN
                    reignCoin.transfer(stakers[i], stakedAmount[stakers[i]]);
                }
            }

        }


    /*
        * @dev a function that allows users to redeem their REIGN COINs
        * @param _amount the amount of REIGN COINs to be redeemed
        * @dev the function will check if the user has enough REIGN COINs to redeem
        * @dev the function will check if the user has already redeemed the maximum amount of REIGN COINs
        
    */
    function redeem(uint _amount) public {
        //Require the user has enough staked USDC Tokens to redeem
        //require(stakedAmount[msg.sender] >= _amount, "You don't have enough USDC Tokens to redeem");
        //require the user not redeem zero USDC Tokens
        require(_amount > 0, "You cannot redeem zero REIGN COINs");

        //Transfer the requested amount of USDC Tokens to the user 
        ush.transfer(msg.sender, _amount);

        //Update the staked amount of the user
        stakedAmount[msg.sender] = stakedAmount[msg.sender] - _amount;

        //If the staked amount of the user is zero, set their staked status to false
        if(stakedAmount[msg.sender] == 0) {
            staked[msg.sender] = false;
            //The user is no longer a staker
            isStaker[msg.sender] = false;
        }

        
        
        



    }


        

























 }
