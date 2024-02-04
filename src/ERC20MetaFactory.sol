// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20UpgradeableFactory } from "./ERC20UpgradeableFactory.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

interface IERC20FactoryProxyEvents {
    event UpgradeableERC20FactoryCreated(address proxy);
}

contract ERC20MetaFactory is Ownable, IERC20FactoryProxyEvents {
    constructor(address initialOwner) Ownable(initialOwner) { }

    function deployNewUpgradeableFactory() public onlyOwner returns (address) {
        ERC20UpgradeableFactory factoryContract = new ERC20UpgradeableFactory();
        ERC1967Proxy proxy =
            new ERC1967Proxy(address(factoryContract), abi.encodeCall(factoryContract.initialize, owner()));
        emit UpgradeableERC20FactoryCreated(address(proxy));
        return address(proxy);
    }
}
