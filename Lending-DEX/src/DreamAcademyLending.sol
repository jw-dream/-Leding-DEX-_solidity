// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "contracts/token/ERC20/IERC20.sol";

interface IPriceOracle {
    function getPrice(address token) external view returns (uint256);

}

contract DreamAcademyLending {
    IPriceOracle oracle;
    uint256 public reserveAmount;
    IERC20 usdc;
    address reserve;

    constructor(IPriceOracle _dreamOracle, address _usdc){
        usdc = IERC20(_usdc);
        oracle = _dreamOracle;
        
    }

    function _getPrice(address token) external view returns (uint256) {
        return oracle.getPrice(token);
        
    }
 
    function initializeLendingProtocol(address _usdc) external payable {
    
    }

}
