// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {IRegistry} from "../../../registry/IRegistry.sol";
import {IInstance} from "../../IInstance.sol";
import {NftId} from "../../../types/NftId.sol";
import {StateId} from "../../../types/StateId.sol";
import {Timestamp} from "../../../types/Timestamp.sol";
import {Blocknumber} from "../../../types/Blocknumber.sol";

import {IProductService} from "../../service/IProductService.sol";
import {IPoolService} from "../../service/IPoolService.sol";

interface IBundle {

    struct BundleInfo {
        NftId nftId;
        NftId poolNftId;
        StateId state; // active, paused, closed (expriy only implicit)
        bytes filter; // required conditions for applications to be considered for collateralization by this bundle
        uint256 capitalAmount; // net investment capital amount (<= balance)
        uint256 lockedAmount; // capital amount linked to collateralizaion of non-closed policies (<= balance)
        uint256 balanceAmount; // total amount of funds: net investment capital + net premiums - payouts
        Timestamp createdAt;
        Timestamp expiredAt; // no new policies
        Timestamp closedAt;
        Blocknumber updatedIn;
    }
}

interface IBundleModule is IBundle {

    function createBundleInfo(
        NftId bundleNftId,
        NftId poolNftId,
        uint256 amount, 
        uint256 lifetime, 
        bytes calldata filter
    ) external;

    function setBundleInfo(BundleInfo memory bundleInfo) external;
    function collateralizePolicy(NftId bundleNftId, NftId policyNftId, uint256 amount) external;
    function releasePolicy(NftId bundleNftId, NftId policyNftId) external returns(uint256 collateralAmount);

    function getBundleInfo(NftId bundleNftId) external view returns(BundleInfo memory bundleInfo);

    // repeat registry linked signature
    function getRegistry() external view returns (IRegistry registry);

    // repeat service linked signatures to avoid linearization issues
    function getProductService() external returns(IProductService);
    function getPoolService() external returns(IPoolService);
}
