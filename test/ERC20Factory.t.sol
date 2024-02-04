// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test } from "forge-std/src/Test.sol";
import { ERC20UpgradeableFactory, IERC20UpgradeableFactoryEvents } from "../src/ERC20UpgradeableFactory.sol";
import { ERC20MetaFactory } from "../src/ERC20MetaFactory.sol";
import { ERC20Token } from "../src/ERC20Token.sol";

contract ERC20FactoryTest is Test, IERC20UpgradeableFactoryEvents {
    ERC20MetaFactory public metaFactory;
    ERC20UpgradeableFactory public factory;
    ERC20UpgradeableFactory public factoryV2;
    ERC20Token public myTokenV2;

    address public admin = address(42);
    address public firstOwner = address(1);
    address public secondOwner = address(2);
    address public factoryProxyAddress;

    function setUp() public {
        vm.deal(address(this), 100 ether);
        vm.deal(admin, 100 ether);
        myTokenV2 = new ERC20Token();
        factoryV2 = new ERC20UpgradeableFactory();
        metaFactory = new ERC20MetaFactory(admin);
        vm.startPrank(admin);
        factoryProxyAddress = metaFactory.deployNewUpgradeableFactory();
        factory = ERC20UpgradeableFactory(factoryProxyAddress);
        vm.stopPrank();
    }

    function testDeployNewUpgradeableERC20Token() public {
        vm.startPrank(firstOwner);
        vm.expectEmit();
        emit UpgradeableERC20TokenCreated(address(0x380912F2EaBC6148baaa7f333555bf552BADAcD1));
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

    function testUpgradeFactory() public {
        // not the factory owner
        vm.startPrank(firstOwner);
        // firstOwner isn't the current owner
        // TODO: specify the error
        // reason:  Reason: OwnableUnauthorizedAccount(0x0000000000000000000000000000000000000001)
        vm.expectRevert();
        factory.upgrade(factoryProxyAddress, address(factoryV2));
        vm.startPrank(admin);
        factory.upgrade(factoryProxyAddress, address(factoryV2));
    }
}
