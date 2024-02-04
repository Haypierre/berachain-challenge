// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test } from "forge-std/src/Test.sol";
import { ERC20Factory, IERC20FactoryEvents } from "../src/ERC20Factory.sol";
import { ERC20FactoryProxy } from "../src/ERC20FactoryProxy.sol";
import { ERC20Token } from "../src/ERC20Token.sol";

contract ERC20FactoryTest is Test, IERC20FactoryEvents {
    ERC20FactoryProxy public factoryProxy;
    ERC20Factory public factory;
    ERC20Token public myTokenV2;

    address public admin = address(42);
    address public firstOwner = address(1);
    address public secondOwner = address(2);

    function setUp() public {
        vm.deal(address(this), 100 ether);
        vm.deal(admin, 100 ether);
        myTokenV2 = new ERC20Token();
        factoryProxy = new ERC20FactoryProxy(admin);
        vm.startPrank(admin);
        address factoryAddress = factoryProxy.deployNewUpgradeableFactory();
        factory = ERC20Factory(factoryAddress);
        vm.stopPrank();
    }

    function testDeployNewUpgradeableERC20Token() public {
        vm.startPrank(firstOwner);
        vm.expectEmit();
        emit UpgradeableERC20TokenCreated(address(0xF4AC4798c8af97F5905a52989Fac88a858493A34));
        address proxy = factory.deployNewUpgradeableERC20Token("Sauce", "SCE", 18, 1);
        uint256 totalSupply = ERC20Token(proxy).totalSupply();
        assertEq(
            totalSupply,
            1e18,
            "Call should have been delegated to the token implementation contract and returns its correct total supply"
        );
    }

    function testUpgradeERC20TokenFromParams() public {
        vm.startPrank(firstOwner);
        address proxy = factory.deployNewUpgradeableERC20Token("Sauce", "SCE", 18, 100);
        vm.startPrank(secondOwner);
        // secondOwner isn't the current owner
        // TODO: specify the error
        vm.expectRevert();
        factory.upgradeERC20Token(proxy, address(myTokenV2));
        vm.startPrank(firstOwner);
        factory.upgradeERC20Token(proxy, address(myTokenV2));
        assertEq(
            address(myTokenV2),
            ERC20Token(proxy).getAddress(),
            "Implementation address should've been updated to myTokenV2 address"
        );
    }
}
