// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ERC20Token } from "./ERC20Token.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface IERC20UpgradeableFactoryEvents {
    event UpgradeableERC20TokenCreated(address proxy);
}

contract ERC20UpgradeableFactory is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    IERC20UpgradeableFactoryEvents
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
    }

    function _authorizeUpgrade(address /* newImplementation */ ) internal view override { }

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

    function upgradeERC20Token(address proxyAddress, address newTokenImplemAddress) public returns (address) {
        ERC20Token tokenContract = ERC20Token(proxyAddress);
        if (tokenContract.owner() != msg.sender) revert OwnableUpgradeable.OwnableUnauthorizedAccount(msg.sender);
        // since the msg.sender will be the factory address
        // we need to check for the owner in the Factory
        // and add factory as authorize address to perform ERC20Token upgrade
        // (see _authorizeUpgrade in ERC20Token.sol)
        ERC20Token(proxyAddress).upgradeToAndCall(newTokenImplemAddress, "");
        return proxyAddress;
    }

    function upgrade(address proxyAddress, address newFactoryImplemAddress) public returns (address) {
        if (owner() != msg.sender) revert OwnableUpgradeable.OwnableUnauthorizedAccount(msg.sender);
        upgradeToAndCall(newFactoryImplemAddress, "");
        return proxyAddress;
    }
}
