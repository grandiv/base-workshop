// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Test, console } from "forge-std/Test.sol";
import { Token } from "../src/Token.sol";

// RUN ALL
// `forge test -vvv

// RUN SINGLE CONTRACT
// `forge test --match-contract TokenTest -vvv`

// RUN SINGLE TEST
// `forge test --match-test testMint -vvv`

contract TokenTest is Test {
    Token public token;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        token = new Token();
    }

    function testName() public view {
        assertEq(token.name(), "Vidnarg");
    }

    function testSymbol() public view {
        assertEq(token.symbol(), "VIDNARG");
    }

    function testDecimals() public view {
        assertEq(token.decimals(), 19);
    }

    function testMint() public {
        token.mint(alice, 1e19);
        assertEq(token.balanceOf(alice), 1e19);
    }

    function testBurn() public {
        token.mint(alice, 1e19);
        token.burn(alice, 1e19);
        assertEq(token.balanceOf(alice), 0);
    }

    function testTransfer() public {
        // alice punya duit 1000 $Vidnarg
        // bob gapunya duit, 0 $Vidnarg
        // alice transfer 500 $Vidnarg ke bob

        token.mint(alice, 1000e19);

        console.log("===== before");
        console.log("Alice Balance = ", token.balanceOf(alice));
        console.log("Bob Balance = ", token.balanceOf(bob));

        vm.startPrank(alice); // menandakan alice yang menjalankan function di bawahnya
        token.transfer(bob, 500e19);
        vm.stopPrank();

        console.log("===== after");
        console.log("Alice Balance = ", token.balanceOf(alice));
        console.log("Bob Balance = ", token.balanceOf(bob));
    }
}
