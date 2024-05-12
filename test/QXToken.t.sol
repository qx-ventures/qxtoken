// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/QXToken.sol";
import "./utils/Utilities.sol";

contract QXTokenTest is Test {
    Utilities internal utils;

    address[] internal users;
    address payable internal owner;
    address payable internal bob;
    address payable internal alice;

    QXToken internal qxtoken;

    function setUp() public {
        utils = new Utilities();

        users = utils.createUsers(3);
        owner = payable(users[0]);
        bob = payable(users[1]);
        alice = payable(users[2]);

        vm.prank(owner);
        qxtoken = new QXToken();
    }

    function test_owner_owns_qxtoken() public {
        vm.prank(owner);
        assertEq(qxtoken.owner(), owner);
    }

    function test_owner_can_pause() public {
        vm.prank(owner);
        qxtoken.pause();

        assertTrue(qxtoken.paused());
    }

    function test_owner_can_unpause() public {
        vm.prank(owner);
        qxtoken.pause();
        assertTrue(qxtoken.paused());

        vm.prank(owner);
        qxtoken.unpause();
        assertFalse(qxtoken.paused());
    }

    function test_paused_cant_mint() public {
        vm.prank(owner);
        qxtoken.pause();
        assertTrue(qxtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qxtoken.mint(bob, 100);
    }

    function test_paused_cant_transfer() public {
        vm.prank(owner);
        qxtoken.mint(owner, 100);
        assertEq(qxtoken.balanceOf(owner), 100);

        vm.prank(owner);
        qxtoken.pause();
        assertTrue(qxtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qxtoken.transfer(bob, 100);
    }

    function test_paused_cant_burn() public {
        vm.prank(owner);
        qxtoken.mint(owner, 100);
        assertEq(qxtoken.balanceOf(owner), 100);

        vm.prank(owner);
        qxtoken.pause();
        assertTrue(qxtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qxtoken.burn(100);
    }

    function test_user_cant_mint() public {
        vm.prank(bob);
        vm.expectRevert();
        qxtoken.mint(bob, 100);
    }

    function test_mint_to_owner() public {
        vm.prank(owner);
        qxtoken.mint(owner, 100);
        assertEq(qxtoken.balanceOf(owner), 100);
    }

    function test_mint_to_bob() public {
        vm.prank(owner);
        qxtoken.mint(bob, 100);
        assertEq(qxtoken.balanceOf(bob), 100);
    }

    function test_user_can_transfer_to_user() public {
        vm.prank(owner);
        qxtoken.mint(bob, 100);
        assertEq(qxtoken.balanceOf(bob), 100);

        vm.prank(bob);
        qxtoken.transfer(alice, 100);
        assertEq(qxtoken.balanceOf(bob), 0);
        assertEq(qxtoken.balanceOf(alice), 100);
    }
}
