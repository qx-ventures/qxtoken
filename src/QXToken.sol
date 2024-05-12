// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "openzeppelin/token/ERC20/ERC20.sol";
import "openzeppelin/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin/security/Pausable.sol";
import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC20/extensions/ERC20Permit.sol";

contract QXToken is ERC20, ERC20Burnable, Pausable, Ownable, ERC20Permit {
    constructor() ERC20("QXToken", "QXT") ERC20Permit("QXToken") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
