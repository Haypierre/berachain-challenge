// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { ERC20PermitUpgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ERC1967Utils } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract ERC20Token is Initializable, ERC20Upgradeable, OwnableUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {
    address public factory;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner,
        address _factory,
        string calldata name,
        string calldata symbol,
        uint8 decimals,
        uint256 initialSupply
    )
        public
        initializer
    {
        __ERC20_init(name, symbol);
        __Ownable_init(initialOwner);
        __ERC20Permit_init(name);
        __UUPSUpgradeable_init();
        factory = _factory;

        // TODO: test for under/overflow
        _mint(initialOwner, initialSupply * 10 ** decimals);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getAddress() public view returns (address implementation) {
        return ERC1967Utils.getImplementation();
    }

    function _authorizeUpgrade(address /* newImplementation */ ) internal view override {
        address sender = _msgSender();
        if (sender != owner() && sender != factory) {
            revert OwnableUnauthorizedAccount(sender);
        }
    }
}
