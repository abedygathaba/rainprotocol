//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract USH {
    string  public name = "HARMONY US ";
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

contract loan {
        address payable public lender;
        address payable public borrower;
        address public ushAddress;
         struct Terms {
             uint256 UshLoanAmount;
             uint256 UshFeeAmount;
             uint256 OneCollateralAmount;
             uint256 repayByTimestamp;
         }
        Terms public terms;
        enum StateOfTheLoan {Created,
                             Funded,
                              Taken}
        StateOfTheLoan public state;
        constructor(Terms memory _terms, address _ushAddress) {
            lender == msg.sender;
            terms = _terms;
            ushAddress = _ushAddress;
            state = StateOfTheLoan.Created;
        }
        modifier stateRequired(StateOfTheLoan _stateRequired) {
            require (state == _stateRequired, "You cannot do that in this State of the loan");
            _;
        }

        function fundLoan () public stateRequired(StateOfTheLoan.Created) {
            USH(ushAddress).transferFrom(msg.sender, address(this),terms.UshLoanAmount);
            state = StateOfTheLoan.Funded;
        }

        function TakeLoan() public payable stateRequired(StateOfTheLoan.Funded) {
            require (msg.value == terms.OneCollateralAmount, "Invalid collateral amount");
            borrower == msg.sender;
            USH(ushAddress).transfer(borrower, terms.UshLoanAmount);
            state = StateOfTheLoan.Taken;
        }
         function repay () public stateRequired(StateOfTheLoan.Taken){
            require(borrower == msg.sender, "Only the borrower can repay the loan");
            USH(ushAddress).transferFrom(borrower,lender,terms.UshLoanAmount+terms.UshFeeAmount);
            selfdestruct(borrower);

         }

         function liquidate() public stateRequired(StateOfTheLoan.Taken){
             require(lender== msg.sender, "Only the lender can liquidate the loan");
             require(block.timestamp >= terms.repayByTimestamp,"Cannot liquidate before the loan is due");
             selfdestruct(lender);


         }




}
