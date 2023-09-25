// SPDX-License-Identifier: APACHE-2.0
pragma solidity 0.8.20;

import "../../lib/forge-std/src/Test.sol";

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {ChainNft, IChainNft} from "../../contracts/registry/ChainNft.sol";
import {Registry} from "../../contracts/registry/Registry.sol";

import {ComponentOwnerService} from "../../contracts/instance/service/ComponentOwnerService.sol";
import {ProductService} from "../../contracts/instance/service/ProductService.sol";
import {PoolService} from "../../contracts/instance/service/PoolService.sol";

import {Instance} from "../../contracts/instance/Instance.sol";
import {TestProduct} from "../../contracts/test/TestProduct.sol";
import {TestPool} from "../../contracts/test/TestPool.sol";
import {USDC} from "../mock/Usdc.sol";

import {IPolicy} from "../../contracts/instance/module/policy/IPolicy.sol";
import {IPool} from "../../contracts/instance/module/pool/IPoolModule.sol";
import {NftId, NftIdLib} from "../../contracts/types/NftId.sol";

contract TestGifBase is Test {
    using NftIdLib for NftId;

    ChainNft public chainNft;
    Registry public registry;
    IERC20Metadata public token;
    ComponentOwnerService public componentOwnerService;
    ProductService public productService;
    PoolService public poolService;
    Instance public instance;
    TestProduct public product;
    TestPool public pool;

    address public registryAddress;
    NftId public registryNftId;

    address public registryOwner = makeAddr("registryOwner");
    address public instanceOwner = makeAddr("instanceOwner");
    address public productOwner = makeAddr("productOwner");
    address public poolOwner = makeAddr("poolOwner");
    address public customer = makeAddr("customer");
    address public outsider = makeAddr("outsider");

    string private _checkpointLabel;
    uint256 private _checkpointGasLeft = 1; // Start the slot warm.

    function setUp() public virtual {

        console.log("tx origin", tx.origin);

        // deploy registry, nft, and services
        vm.startPrank(registryOwner);
        _deployRegistry(registryOwner);
        _deployServices();
        vm.stopPrank();

        // deploy instance
        vm.startPrank(instanceOwner);
        _deployInstance();
        _deployToken();
        vm.stopPrank();

        // deploy pool
        vm.startPrank(poolOwner);
        _deployPool();
        vm.stopPrank();

        // deploy product
        vm.startPrank(productOwner);
        _deployProduct();
        vm.stopPrank();
    }

    function fundAccount(address account, uint256 amount) public {
        token.transfer(account, amount);
    }

    /// @dev Helper function to assert that a given NftId is equal to the expected NftId.
    function assertNftId(NftId actualNftId, NftId expectedNftId, string memory message) public {
        if(block.chainid == 31337) {
            assertEq(actualNftId.toInt(), expectedNftId.toInt(), message);
        } else {
            // solhint-disable-next-line
            console.log("chain not anvil, skipping assertNftId");
        }
    }

    /// @dev Helper function to assert that a given NftId is equal to zero.
    function assertNftIdZero(NftId nftId, string memory message) public {
        if(block.chainid == 31337) {
            assertTrue(nftId.eqz(), message);
        } else {
            // solhint-disable-next-line
            console.log("chain not anvil, skipping assertNftId");
        }
    }

    function _startMeasureGas(string memory label) internal virtual {
        _checkpointLabel = label;
        _checkpointGasLeft = gasleft();
    }


    function _stopMeasureGas() internal virtual {
        // Subtract 100 to account for the warm SLOAD in startMeasuringGas.
        uint256 gasDelta = _checkpointGasLeft - gasleft() - 100;
        string memory message = string(abi.encodePacked(_checkpointLabel, " gas"));
        console.log(message, gasDelta);
    }

    function _deployRegistry(address registryNftOwner) internal {
        registry = new Registry();
        ChainNft nft = new ChainNft(address(registry));

        registry.initialize(address(nft), registryNftOwner);
        registryAddress = address(registry);
        registryNftId = registry.getNftId();

        console.log("nft deployed at", address(nft));
        console.log("registry deployed at", address(registry));
    }


    function _deployServices() internal {
        componentOwnerService = new ComponentOwnerService(
            registryAddress, registryNftId);
        componentOwnerService.register();

        console.log("service name", componentOwnerService.NAME());
        console.log("service nft id", componentOwnerService.getNftId().toInt());
        console.log("component owner service deployed at", address(componentOwnerService));

        productService = new ProductService(
            registryAddress, registryNftId);
        productService.register();

        console.log("service name", productService.NAME());
        console.log("service nft id", productService.getNftId().toInt());
        console.log("product service deployed at", address(productService));

        poolService = new PoolService(
            registryAddress, registryNftId);
        poolService.register();

        console.log("service name", poolService.NAME());
        console.log("service nft id", poolService.getNftId().toInt());
        console.log("pool service deployed at", address(poolService));
    }


    function _deployInstance() internal {
        instance = new Instance(
            address(registry), 
            registry.getNftId());
        instance.register();

        console.log("instance deployed at", address(instance));

        bytes32 productOwnerRole = instance.getRoleForName("ProductOwner");
        bytes32 poolOwnerRole = instance.getRoleForName("PoolOwner");

        instance.grantRole(productOwnerRole, productOwner);
        instance.grantRole(poolOwnerRole, poolOwner);
        console.log("product and pool roles granted");
    }


    function _deployToken() internal {
        USDC usdc  = new USDC();
        address usdcAddress = address(usdc);
        token = IERC20Metadata(usdcAddress);
        console.log("token deployed at", usdcAddress);
    }


    function _deployPool() internal {
        pool = new TestPool(address(registry), instance.getNftId(), address(token));
        pool.register();
        console.log("pool deployed at", address(pool));
    }


    function _deployProduct() internal {
        product = new TestProduct(address(registry), instance.getNftId(), address(token), address(pool));
        product.register();
        console.log("product deployed at", address(product));
    }
}