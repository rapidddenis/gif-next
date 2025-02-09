// SPDX-License-Identifier: APACHE-2.0
pragma solidity 0.8.20;

import {TestGifBase} from "./base/TestGifBase.sol";
import {console} from "../lib/forge-std/src/Script.sol";
import {NftId, toNftId} from "../contracts/types/NftId.sol";

import {ChainNft} from "../contracts/registry/ChainNft.sol";
import {IRegistry} from "../contracts/registry/IRegistry.sol";
import {Registry} from "../contracts/registry/Registry.sol";
import {Instance} from "../contracts/instance/Instance.sol";

import {ComponentOwnerService} from "../contracts/instance/service/ComponentOwnerService.sol";
import {ProductService} from "../contracts/instance/service/ProductService.sol";
import {PoolService} from "../contracts/instance/service/PoolService.sol";

import {TestInstanceBase} from "./modules/TestInstanceBase.sol";

import {
    TestInstanceModuleAccess, 
    TestInstanceModuleBundle, 
    TestInstanceModuleComponent, 
    TestInstanceModuleDistribution,
    TestInstanceModulePolicy, 
    TestInstanceModulePool, 
    TestInstanceModuleRisk, 
    TestInstanceModuleTreasury
} from "./modules/TestInstanceModules.sol";


contract TestDeployModules is TestGifBase {

    function testInstanceBase() public {

        address regAddr = address(registry);
        NftId regNftId = registry.getNftId();

        vm.startPrank(instanceOwner);
        _startMeasureGas("InstanceBase");
        TestInstanceBase instanceBase = new TestInstanceBase(
            regAddr, regNftId);
        _stopMeasureGas();

        instanceBase.register();
        vm.stopPrank();

        NftId baseNftId = instanceBase.getNftId();
        assertTrue(baseNftId.toInt() > 0);
        assertNftId(registry.getNftId(address(instanceBase)), baseNftId, "unexpected instance base nft id");
    }

    function testInstanceAccess() public {
        vm.prank(instanceOwner);
        TestInstanceModuleAccess instance = new TestInstanceModuleAccess(
            registryAddress, 
            registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModuleBundle() public {
        vm.prank(instanceOwner);
        TestInstanceModuleBundle instance = new TestInstanceModuleBundle(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModuleComponent() public {
        vm.prank(instanceOwner);
        TestInstanceModuleComponent instance = new TestInstanceModuleComponent(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModulePolicy() public {
        vm.prank(instanceOwner);
        TestInstanceModulePolicy instance = new TestInstanceModulePolicy(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModulePool() public {
        vm.prank(instanceOwner);
        TestInstanceModulePool instance = new TestInstanceModulePool(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModuleTreasury() public {
        vm.prank(instanceOwner);
        TestInstanceModuleTreasury instance = new TestInstanceModuleTreasury(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModuleCompensation() public {
        vm.prank(instanceOwner);
        TestInstanceModuleDistribution instance = new TestInstanceModuleDistribution(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }

    function testInstanceModuleRisk() public {
        vm.prank(instanceOwner);
        TestInstanceModuleRisk instance = new TestInstanceModuleRisk(registryAddress, registryNftId);

        vm.prank(instanceOwner);
        instance.register();
    }
}
