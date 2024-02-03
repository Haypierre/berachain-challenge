// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract ERC20Proxy is ERC1967Proxy, Ownable {
    constructor(
        address initialOwner,
        address initialImplementation,
        bytes memory _data
    )
        payable
        ERC1967Proxy(initialImplementation, _data)
        Ownable(initialOwner)
    { }

    function upgradeImplementation(address newImplementation, bytes memory _data) public onlyOwner {
        ERC1967Utils.upgradeToAndCall(newImplementation, _data);
    }
}
