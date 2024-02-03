// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { Test } from "forge-std/src/Test.sol";
import { ERC20Factory, IERC20FactoryEvents } from "../src/ERC20Factory.sol";
import { ERC20Token } from "../src/ERC20Token.sol";

contract ERC20FactoryTest is Test, IERC20FactoryEvents {
    ERC20Factory public factory;
    address public firstOwner = address(1);
    address public secondOwner = address(2);

    function setUp() public {
        factory = new ERC20Factory();
    }

    function testDeployNewUpgradeableERC20Token() public {
        vm.startPrank(firstOwner);
        vm.expectEmit();
        emit UpgradeableERC20TokenCreated(address(0x037eDa3aDB1198021A9b2e88C22B464fD38db3f3));
        address proxy = factory.deployNewUpgradeableERC20Token("Sauce", "SCE", 18, 1);
        uint256 totalSupply = ERC20Token(proxy).totalSupply();
        assertEq(
            totalSupply,
            1e18,
            "Call should have been delegated to the token implemtantation contract and returns correct total supply"
        );
    }
}
