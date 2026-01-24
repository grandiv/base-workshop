// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Test, console } from "forge-std/Test.sol";
import { IChainLink } from "../src/interfaces/IChainLink.sol";

// forge test --match-contract ChainlinkTest
contract ChainlinkTest is Test { 
    function setUp() public {
        // Mainnet
        // vm.createSelectFork(vm.rpcUrl("base_mainnet"));
        // Testnet 
        vm.createSelectFork(vm.rpcUrl("base_sepolia"));
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testChainlink -vvv
    function testChainId() public view {
        console.log("chainid: ", block.chainid);
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testChainlinkPricefeed -vvv
    function testChainlinkPricefeed() public view {
        address pricefeed = 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22; // LINK/USD Sepolia

        (uint80 roundId, int256 price, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = IChainLink(pricefeed).latestRoundData();
        console.log("roundId: ", roundId);
        console.log("price: ", price);
        console.log("startedAt: ", startedAt);
        console.log("updatedAt: ", updatedAt);
        console.log("answeredInRound: ", answeredInRound);
    }
}