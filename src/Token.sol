// SPDX-License-Identifier: MIT
// This is an ERC20 token contract - a standard for creating fungible tokens (like coins) on ETH. 
// Think of it like creating your own cryptocurrency
pragma solidity ^0.8.30;

// Library for basic token functionalities (transfer, balance checking, etc.)
import { ERC20 } from "@openzeppelin/token/ERC20/ERC20.sol";

// Creates a contract named "Token" that inherits from the ERC20 standard
contract Token is ERC20 {
    // constructor adalah function yang dieksekusi pertama kali saat contract di-deploy
    constructor() ERC20("Vidnarg", "VIDNARG") {
        // Creates 100,000 tokens and gives them to whoever deploys the contract
        _mint(msg.sender, 100000 * 10 ** decimals());
    }

    // Creates new tokens out of thin air
    // Like a central bank printing new money
    // Use case: reward users, create initial token distribution
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // Destroys tokens from an address/decreases total supply
    // Like taking money and burning it
    // Use case: reduce supply to increase value, remove tokens from circulation
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    // defaultnya ETH = 18 decimals,
    // misal 0.1 ETH = 0.1 * 10^18 = 10^17 wei, 
    // misal 1 ETH = 1 * 10^18 wei
    // FE convert decimals yang ada di situ jadi ETH
    function decimals() public pure override returns (uint8) {
        return 19;
    }
}