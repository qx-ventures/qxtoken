// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/Qtoken.sol";
import "./utils/Utilities.sol";

contract QtokenTest is Test {
    Utilities internal utils;

    address[] internal users;
    address payable internal owner;
    address payable internal bob;
    address payable internal alice;

    Qtoken internal qtoken;

    function setUp() public {
        utils = new Utilities();

        users = utils.createUsers(3);
        owner = payable(users[0]);
        bob = payable(users[1]);
        alice = payable(users[2]);

        vm.prank(owner);
        qtoken = new Qtoken();
    }

    function test_owner_owns_qtoken() public {
        vm.prank(owner);
        assertEq(qtoken.owner(), owner);
    }

    function test_owner_can_pause() public {
        vm.prank(owner);
        qtoken.pause();

        assertTrue(qtoken.paused());
    }

    function test_owner_can_unpause() public {
        vm.prank(owner);
        qtoken.pause();
        assertTrue(qtoken.paused());

        vm.prank(owner);
        qtoken.unpause();
        assertFalse(qtoken.paused());
    }

    function test_paused_cant_mint() public {
        vm.prank(owner);
        qtoken.pause();
        assertTrue(qtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qtoken.mint(bob, 100);
    }

    function test_paused_cant_transfer() public {
        vm.prank(owner);
        qtoken.mint(owner, 100);
        assertEq(qtoken.balanceOf(owner), 100);

        vm.prank(owner);
        qtoken.pause();
        assertTrue(qtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qtoken.transfer(bob, 100);
    }

    function test_paused_cant_burn() public {
        vm.prank(owner);
        qtoken.mint(owner, 100);
        assertEq(qtoken.balanceOf(owner), 100);

        vm.prank(owner);
        qtoken.pause();
        assertTrue(qtoken.paused());

        vm.prank(owner);
        vm.expectRevert();
        qtoken.burn(100);
    }

    function test_user_cant_mint() public {
        vm.prank(bob);
        vm.expectRevert();
        qtoken.mint(bob, 100);
    }

    function test_mint_to_owner() public {
        vm.prank(owner);
        qtoken.mint(owner, 100);
        assertEq(qtoken.balanceOf(owner), 100);
    }

    function test_mint_to_bob() public {
        vm.prank(owner);
        qtoken.mint(bob, 100);
        assertEq(qtoken.balanceOf(bob), 100);
    }

    function test_user_can_transfer_to_user() public {
        vm.prank(owner);
        qtoken.mint(bob, 100);
        assertEq(qtoken.balanceOf(bob), 100);

        vm.prank(bob);
        qtoken.transfer(alice, 100);
        assertEq(qtoken.balanceOf(bob), 0);
        assertEq(qtoken.balanceOf(alice), 100);
    }
}
