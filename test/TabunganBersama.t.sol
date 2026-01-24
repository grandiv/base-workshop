// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Test, console } from "forge-std/Test.sol";
import { TabunganBersama } from "../src/TabunganBersama.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// RUN
// forge test --match-contract TabunganBersamaTest -vvv
contract TabunganBersamaTest is Test { 
    TabunganBersama public tabunganBersama;
    address public token = 0x18Bc5bcC660cf2B9cE3cd51a404aFe1a0cBD3C22; // IDRX

    address public deployer = makeAddr("deployer");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    function setUp() public {
        // Mainnet
        // vm.createSelectFork(vm.rpcUrl("base_mainnet"));
        // Testnet 
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
        deal(token, deployer, 100_000_000_000e2);
        deal(token, alice, 100_000_000e2);
        deal(token, bob, 1_000_000e2);

        tabunganBersama = new TabunganBersama(token);
    }

    function testCheckBalance() public view {
        uint256 tokenBalance = IERC20(token).balanceOf(deployer);
        console.log("deployer balance: ", tokenBalanceBefore);

        deal(token, deployer, 100_000_000_000e2);

        uint256 tokenBalanceAfter = IERC20(token).balanceOf(deployer);
        console.log("deployer balance after deal: ", tokenBalanceAfter);

        console.log("=============");

        console.log("balance deployer before", IERC20(token).balanceOf(deployer)); 
        console.log("balance alice before", IERC20(token).balanceOf(alice));

        vm.startPrank(deployer);
        uint256 amountToTransfer = 19_000_000e2;
        // Approve digunakan untuk mindahin aset ke contract address lain, misalnya vault 
        // contoh: kita approve send 10 USDC, kita cuma ngirim 5 USDC, artinya masih sisa 5 USDC yang bisa dikirim
        // kalau ga approve -> revert (makan gas fee)
        IERC20(token).approve(alice, amountToTransfer); 
        IERC20(token).transfer(alice, amountToTransfer);
        vm.stopPrank();

        console.log("balance deployer after", IERC20(token).balanceOf(deployer));
        console.log("balance alice after", IERC20(token).balanceOf(alice));
    }

    // RUN
    // forge test --match-contract TabunganBersamaTest --match-test testDeposit -vvv
    function testDeposit() public {
        vm.startPrank(deployer);
        uint256 amountToTransfer = 1_000_000e2;

        IERC20(token).approve(address(tabunganBersama), amountToTransfer);
        tabunganBersama.deposit(amountToTransfer);
        vm.stopPrank();

        // console.log("tabunganBersama.totalSupplyShares(): ", tabunganBersama.totalSupplyShares());
        // console.log("tabunganBersama.totalSupplyAssets(): ", tabunganBersama.totalSupplyAssets());

        assertEq(tabunganBersama.totalSupplyAssets(), amountToTransfer);
        assertEq(tabunganBersama.totalSupplyShares(), amountToTransfer);
    }

    function testWithdraw() public {
        vm.startPrank(deployer);
        uint256 amountToTransfer = 1_000_000e2;

        IERC20(token).approve(address(tabunganBersama), amountToTransfer);
        tabunganBersama.deposit(amountToTransfer);

        uint256 sharesToWithdraw = tabunganBersama.totalSupplyShares();
        tabunganBersama.withdraw(sharesToWithdraw);
        vm.stopPrank();

        assertEq(tabunganBersama.totalSupplyAssets(), 0);
        assertEq(tabunganBersama.totalSupplyShares(), 0);
    }

    function testDistributeYieldWithWithdraw() public {
        
    }
}