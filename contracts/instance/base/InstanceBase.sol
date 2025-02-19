// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {Versionable} from "../../shared/Versionable.sol";
import {Registerable} from "../../shared/Registerable.sol";

import {ObjectType, INSTANCE} from "../../types/ObjectType.sol";
import {Key32} from "../../types/Key32.sol";
import {NftId} from "../../types/NftId.sol";
import {StateId} from "../../types/StateId.sol";
import {Version, VersionPart, VersionLib} from "../../types/Version.sol";

import {IComponentOwnerService} from "../service/IComponentOwnerService.sol";
import {IDistributionService} from "../service/IDistributionService.sol";
import {IProductService} from "../service/IProductService.sol";
import {IPoolService} from "../service/IPoolService.sol";

import {IKeyValueStore} from "./IKeyValueStore.sol";
import {IInstance} from "../IInstance.sol";
import {IInstanceBase} from "./IInstanceBase.sol";

import {KeyValueStore} from "./KeyValueStore.sol";

abstract contract InstanceBase is
    Versionable,
    Registerable,
    IInstanceBase
{
    IKeyValueStore internal _keyValueStore;

    IComponentOwnerService internal _componentOwnerService;
    IDistributionService internal _distributionService;
    IProductService internal _productService;
    IPoolService internal _poolService;

    constructor(
        address registry,
        NftId registryNftId
    )
        Registerable(registry, registryNftId)
        Versionable()
    {
        _keyValueStore = new KeyValueStore();

        _registerInterface(type(IInstance).interfaceId);
        _linkToServicesInRegistry();
    }

    function getKeyValueStore() public view virtual override returns (IKeyValueStore keyValueStore) { return _keyValueStore; }

    function updateState(Key32 key, StateId state) external override {
        _keyValueStore.updateState(key, state);
    }

    function getState(Key32 key) external view override returns (StateId state) {
        return _keyValueStore.getState(key);
    }

    // from versionable
    function getVersion()
        public 
        pure 
        virtual override
        returns(Version)
    {
        return VersionLib.toVersion(3,0,0);
    }

    // from registerable
    function getType() external pure override returns (ObjectType objectType) {
        return INSTANCE();
    }


    // internal / private functions
    function _linkToServicesInRegistry() internal {
        VersionPart majorVersion = getVersion().toMajorPart();
        _componentOwnerService = IComponentOwnerService(_getAndCheck("ComponentOwnerService", majorVersion));
        _distributionService = IDistributionService(_getAndCheck("DistributionService", majorVersion));
        _productService = IProductService(_getAndCheck("ProductService", majorVersion));
        _poolService = IPoolService(_getAndCheck("PoolService", majorVersion));
    }

    function _getAndCheck(string memory serviceName, VersionPart majorVersion) internal view returns (address serviceAddress) {
        serviceAddress = _registry.getServiceAddress(serviceName, majorVersion);
        require(
            serviceAddress != address(0),
            "ERROR:INS-001:NOT_REGISTERED"
        );
    }
}
