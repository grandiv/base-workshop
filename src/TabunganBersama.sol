// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

// TabunganBersama -> Vault to pool tokens together
contract TabunganBersama is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    error AmountIsZero();
    error InsufficientBalance();

    address public token;

    uint256 public totalSupplyShares; // misal bob and alice deposit masing2 1jt, artinya totalSupplyShares = 2jt
    uint256 public totalSupplyAssets; // dari 2jt (bob + alice), deployer ngasih yield 2jt, artinya totalSupplyAssets = 4jt

    mapping(address => uint256) public userSupplyShares;

    constructor(address _token) Ownable(msg.sender) {
        token = _token;
    }

    function deposit(uint256 _amount) public nonReentrant { // nyimpen uang
        if (_amount == 0) revert AmountIsZero();
        uint256 shares = 0;

        if (totalSupplyShares == 0) {
            shares = _amount;
        } else {
            shares = _amount * totalSupplyShares / totalSupplyAssets;
        }

        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        userSupplyShares[msg.sender] += shares;
        totalSupplyShares += shares;
        totalSupplyAssets += _amount;
    }

    // Yield -> bonus -> bunga -> kita dapet benefitnya
    function withdraw(uint256 _shares) public nonReentrant { // narik uang
        if (_shares == 0) revert AmountIsZero();
        if (userSupplyShares[msg.sender] < _shares) revert InsufficientBalance();

        uint256 amount = _shares * totalSupplyAssets / totalSupplyShares;

        userSupplyShares[msg.sender] -= _shares;
        totalSupplyShares -= _shares;
        totalSupplyAssets -= amount;

        IERC20(token).safeTransfer(msg.sender, amount);
    }

    function distributeYield(uint256 _amount) public onlyOwner {
        totalSupplyAssets += _amount;

        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
    }
}