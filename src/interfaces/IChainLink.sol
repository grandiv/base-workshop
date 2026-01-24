// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Chainlink = Oracle -> ambil data offchain ke onchain (contoh: ambil data harga ETH/USD dari luar blockchain ke dalam blockchain)
interface IChainLink {
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}