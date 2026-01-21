// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockedWallet {
    address public beneficiary;
    uint256 public unlockTime;

    constructor(address _beneficiary, uint256 _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time must be in future");
        require(_beneficiary != address(0), "Invalid beneficiary");

        beneficiary = _beneficiary;
        unlockTime = _unlockTime;
    }

    function withdraw() external {
        require(msg.sender == beneficiary, "Not beneficiary");
        require(block.timestamp >= unlockTime, "Funds are still locked");

        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");

        (bool success, ) = beneficiary.call{value: amount}("");
        require(success, "ETH transfer failed");
    }

    receive() external payable {}
}

