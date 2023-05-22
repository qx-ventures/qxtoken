// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/QToken.sol";
import "./utils/Utilities.sol";

contract QTokenTest is Test {
    uint256 constant INITIAL_SUPPLY = 10 ** 6;
    uint256 constant ROYALTY_FEE_PERCENTAGE = 10;

    Utilities internal utils;

    address[] internal users;
    address payable internal owner;
    address payable internal bob;
    address payable internal alice;

    QToken internal qtoken;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(3);
        owner = payable(users[0]);
        bob = payable(users[1]);
        alice = payable(users[2]);

        qtoken = new QToken(
            "QToken",
            "QTOK",
            18,
            INITIAL_SUPPLY,
            owner,
            ROYALTY_FEE_PERCENTAGE
        );
    }

    function testTransfer() public {
        console.log(qtoken.balanceOf(bob));

        vm.startPrank(owner);
        qtoken.transfer(bob, 100);

        console.log(qtoken.balanceOf(bob));
        assertEq(qtoken.balanceOf(bob), 100 - ROYALTY_FEE_PERCENTAGE);
    }
}
