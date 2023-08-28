// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {IPoolComponent} from "./IPool.sol";
import {Component} from "./Component.sol";


contract Pool is
    Component,
    IPoolComponent
{

    constructor(
        address registry, 
        address instance
    )
        Component(registry, instance)
    { }

    // from registerable
    function getType() public view override returns(uint256) {
        return _registry.POOL();
    }

    // from registerable
    function getData() external view override returns(bytes memory data) {
        return bytes(abi.encode(getInstance().getNftId()));
    }
}