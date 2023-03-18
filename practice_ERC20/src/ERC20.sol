
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ERC20 {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances; 
    uint256 private _totalSupply;
    address public owner;

    uint8 private _decimals;

    event Pause();
    event Unpause();
    event NotPausable();

    bool public paused = false;
    bool public canPause = true;

    
    constructor(string memory _name,string memory _symbol) {
        _decimals = 18; 
        _totalSupply = 0;
        _mint(msg.sender,100 ether);
        owner = msg.sender;
    }

    modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

     modifier whenNotPaused() {
    require(!paused || msg.sender == owner);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

    function pause() onlyOwner whenNotPaused public {
        require(canPause == true);
        paused = true;
        emit Pause();
    }
  
    function unpause() onlyOwner whenPaused public {
    require(paused == true);
    paused = false;
    emit Unpause();
  }
  
  
    function notPausable() onlyOwner public{
        paused = false;
        canPause = false;
        emit NotPausable();
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event approval(address indexed owner, address indexed spender, uint256 value);

    
    function transfer(address _to, uint256 _value) external whenNotPaused returns (bool success) {
        require(_to != address(0), "transfer to the zero address");
        require(balances[msg.sender] >= _value, "value exceeds balance");
        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        emit Transfer(msg.sender, _to, _value);
    }
    
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        require(_spender != address(0), "approve to the zero address");

        allowances[msg.sender][_spender] = _value;
        emit approval(msg.sender, _spender, _value);
    }


    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }


    function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool success) {
        require(_from != address(0), "transfer from the zero address");
        require(_to != address(0), "transfer to the zero address");
        require(balances[_from] >= _value);
        require(allowances[_from][msg.sender] >= _value);

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value);
    }

    function _mint(address _owner, uint256 _value) internal whenNotPaused {
        require(_owner != address(0), "mint to the zero address");

        _totalSupply += _value;
        balances[_owner] += _value;
        emit Transfer(address(0), _owner, _value);
    }

    function _burn(address _owner, uint256 _value) internal whenNotPaused {
        require(_owner != address(0), "burn from the zero address");
        require(balances[_owner] >= _value, "burn amount exceeds balance");

        unchecked {
            balances[_owner] -= _value;
            _totalSupply -= _value;
        }

        emit Transfer(_owner, address(0), _value);
    }

    function Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline) external whenNotPaused {
        
    }


}