// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ERC20Token } from "./ERC20Token.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

interface IERC20FactoryEvents {
    event UpgradeableERC20TokenCreated(address proxy);
}

contract ERC20Factory is IERC20FactoryEvents {
    function deployNewUpgradeableERC20Token(
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 initialSupply
    )
        public
        returns (address)
    {
        ERC20Token tokenContract = new ERC20Token();
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(tokenContract),
            abi.encodeCall(tokenContract.initialize, (msg.sender, address(this), name, symbol, decimals, initialSupply))
        );
        address proxyAddress = address(proxy);
        emit UpgradeableERC20TokenCreated(proxyAddress);
        return proxyAddress;
    }

    function upgradeERC20Token(address proxyAddress, address newImplemAddress) public returns (address) {
        ERC20Token tokenContract = ERC20Token(proxyAddress);
        if (tokenContract.owner() != msg.sender) revert OwnableUpgradeable.OwnableUnauthorizedAccount(msg.sender);
        ERC20Token(proxyAddress).upgradeToAndCall(newImplemAddress, "");
        return proxyAddress;
    }
}
