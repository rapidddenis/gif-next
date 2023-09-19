import { AddressLike, Signer, ethers, resolveAddress } from "ethers";
import * as iERC721Abi from "../../artifacts/@openzeppelin/contracts/token/ERC721/IERC721.sol/IERC721.json";
import { Instance__factory } from "../../typechain-types";
import { logger } from "../logger";
import { executeTx, getFieldFromLogs } from "./transaction";

const IERC721ABI = new ethers.Interface(iERC721Abi.abi);

/**
 * Register an instance, extract NFT-Id from the transaction logs and return it.
 */
export async function registerInstance(instanceOwner: Signer, instanceAddress: AddressLike): Promise<any> {    
    logger.debug(`registering instance ${instanceAddress}`);
    // register instance
    const instanceAsInstanceOwner = Instance__factory.connect(instanceAddress.toString(), instanceOwner);
    const tx = await executeTx(async () => await instanceAsInstanceOwner.register());
    const instanceNftId = getFieldFromLogs(tx, IERC721ABI, "Transfer", "tokenId");
    logger.info(`Instance registered with NFT ID: ${instanceNftId}`);
    return instanceNftId;
}

export enum Role { POOL_OWNER_ROLE, PRODUCT_OWNER_ROLE }

export async function grantRole(instanceOwner: Signer, instanceAddress: AddressLike, role: Role, beneficiary: AddressLike): Promise<void> {
    const beneficiaryAddress = await resolveAddress(beneficiary);
    logger.debug(`granting role ${Role[role]} to ${beneficiaryAddress}`);
    const instanceAsInstanceOwner = Instance__factory.connect(instanceAddress.toString(), instanceOwner);
    
    let roleValue: string;
    if (role === Role.POOL_OWNER_ROLE) {
        roleValue = await instanceAsInstanceOwner.POOL_OWNER_ROLE();
    } else if (role === Role.PRODUCT_OWNER_ROLE) {
        roleValue = await instanceAsInstanceOwner.PRODUCT_OWNER_ROLE();
    } else {
        throw new Error("unknown role");
    }

    await executeTx(async () => await instanceAsInstanceOwner.grantRole(roleValue, beneficiaryAddress));
    logger.info(`Granted role ${roleValue} to ${beneficiaryAddress}`);
}