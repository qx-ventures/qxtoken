// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract QToken is ERC20 {
    address public royaltyAddress;
    uint256 public royaltyFeePercentage;
    
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint8 _decimals,
        uint256 _initialSupply,
        address _royaltyAddress,
        uint256 _royaltyFeePercentage
    ) ERC20(_name, _symbol, _decimals) {
        royaltyAddress = _royaltyAddress;
        royaltyFeePercentage = _royaltyFeePercentage;
        _mint(_royaltyAddress, _initialSupply);
    }

    function transferWithRoyalty(address to, uint256 amount) public returns (bool) {
        uint256 royaltyAmount = amount * royaltyFeePercentage / 100;

        transfer(royaltyAddress, royaltyAmount);
        transfer(to, amount - royaltyAmount);

        return true;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        uint256 royaltyAmount = amount * royaltyFeePercentage / 100;
        
        balanceOf[msg.sender] -= amount;

        // can't overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            // transfer to destination the subtracted amount
            balanceOf[to] += amount - royaltyAmount;
            // add to our royaltyAddress wallet the royaltyAmount
            balanceOf[royaltyAddress] += royaltyAmount;
        }

        // transfer to the destination address
        emit Transfer(msg.sender, to, amount - royaltyAmount);
        // transfer to our royalty address
        emit Transfer(msg.sender, royaltyAddress, royaltyAmount);

        return true;
    }
}
