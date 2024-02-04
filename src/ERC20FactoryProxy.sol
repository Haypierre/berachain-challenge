// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20Factory } from "./ERC20Factory.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

interface IERC20FactoryProxyEvents {
    event UpgradeableERC20FactoryCreated(address proxy);
}

contract ERC20FactoryProxy is Ownable, IERC20FactoryProxyEvents {
    constructor(address initialOwner) Ownable(initialOwner) { }

    function deployNewUpgradeableFactory() public onlyOwner returns (address) {
        ERC20Factory factoryContract = new ERC20Factory();
        ERC1967Proxy proxy =
            new ERC1967Proxy(address(factoryContract), abi.encodeCall(factoryContract.initialize, owner()));
        emit UpgradeableERC20FactoryCreated(address(proxy));
        return address(proxy);
    }
}
