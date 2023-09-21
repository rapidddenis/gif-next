// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {NftId} from "../../types/NftId.sol";
import {Fee} from "../../types/Fee.sol";
import {IService} from "./IService.sol";

interface IProductService is IService {
    function setFees(
        Fee memory policyFee,
        Fee memory processingFee
    ) external;

    function createApplication(
        address applicationOwner,
        uint256 sumInsuredAmount,
        uint256 premiumAmount,
        uint256 lifetime,
        NftId bundleNftId
    ) external returns (NftId nftId);

    // function revoke(unit256 nftId) external;

    function underwrite(NftId nftId) external;

    // function decline(uint256 nftId) external;
    // function expire(uint256 nftId) external;
    function close(NftId nftId) external;

    function collectPremium(NftId nftId) external;

    // function createClaim(uint256 nftId, uint256 claimAmount) external;
    // function confirmClaim(uint256 nftId, uint256 claimId, uint256 claimAmount) external;
    // function declineClaim(uint256 nftId, uint256 claimId) external;
    // function closeClaim(uint256 nftId, uint256 claimId) external;
}
