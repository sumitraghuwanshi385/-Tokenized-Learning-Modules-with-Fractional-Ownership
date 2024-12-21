// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenizedLearningModule {
    struct Module {
        string title;
        string description;
        uint256 totalShares;
        mapping(address => uint256) ownershipShares;
    }

    mapping(uint256 => Module) public modules;
    uint256 public moduleCount;

    address public owner;

    event ModuleCreated(uint256 indexed moduleId, string title, uint256 totalShares);
    event OwnershipTransferred(uint256 indexed moduleId, address indexed from, address indexed to, uint256 shares);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createModule(string memory title, string memory description, uint256 totalShares) public onlyOwner {
        require(totalShares > 0, "Total shares must be greater than zero");

        Module storage newModule = modules[moduleCount];
        newModule.title = title;
        newModule.description = description;
        newModule.totalShares = totalShares;
        newModule.ownershipShares[msg.sender] = totalShares;

        emit ModuleCreated(moduleCount, title, totalShares);
        moduleCount++;
    }

    function transferOwnership(uint256 moduleId, address to, uint256 shares) public {
        Module storage module = modules[moduleId];
        require(module.ownershipShares[msg.sender] >= shares, "Not enough shares to transfer");
        require(to != address(0), "Cannot transfer to zero address");

        module.ownershipShares[msg.sender] -= shares;
        module.ownershipShares[to] += shares;

        emit OwnershipTransferred(moduleId, msg.sender, to, shares);
    }

    function getOwnership(uint256 moduleId, address ownerAddress) public view returns (uint256) {
        return modules[moduleId].ownershipShares[ownerAddress];
    }
}
