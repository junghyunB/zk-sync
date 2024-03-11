// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HyeonERC20 is ERC20 {
    uint8 private _decimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20(name_, symbol_) {
        _decimals = decimals_;
    }

    function mint(address _to, uint256 _amount) public returns (bool) {
        _mint(_to, _amount);
        return true;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}

// deploy result 
/**
 - Contract address: 0xbaB1e66465B59DE504F52b64C2F6A2ebbe0eFC99
 - Contract source: contracts/HyeonERC20.sol:HyeonERC20
 - Encoded constructor arguments: 0x000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000a4879656f6e546f6b656e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000034859540000000000000000000000000000000000000000000000000000000000
 Your verification ID is: 7918
 */