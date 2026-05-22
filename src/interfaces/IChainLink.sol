// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Chainlink = Oracle -> ambil data offchain ke onchain (contoh: ambil data harga ETH/USD dari luar blockchain ke dalam blockchain)
interface IChainLink {
    function latestRoundData() external view returns (
        uint80,
        int256,
        uint256,
        uint256,
        uint80
    );
}