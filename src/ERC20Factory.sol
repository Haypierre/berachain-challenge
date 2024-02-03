// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import "./ERC20Token.sol";
// import "./ERC20Proxy.sol";

// contract Factory {
//     event ERC20TokenCreated(address tokenAddress);

//     function setERC20Proxy(address initialOwner, address initialImplementation, bytes memory _data)
//     private returns (address) {
//         ERC20Proxy p = new ERC20Proxy(
//             initialOwner,
//             initialImplementation,
//             _data
//         );
//         // emit event
//         return address(p);
//     }


//     function deployNewUpgradableERC20Token(
//         string calldata name,
//         string calldata symbol,
//         uint8 decimals,
//         uint256 initialSupply
//     ) public returns (address) {
//         owner = msg.sender;
//         ERC20Token token = new ERC20Token(
//             name,
//             symbol,
//             decimals,
//             initialSupply,
//             owner
//         );

//         tokenAddress = address(token);
//         emit ERC20TokenCreated(tokenAddress);
//         proxyAddresss = setERC20Proxy(owner, tokenAddress, "");
//         return proxyAddress;
//     }
// }