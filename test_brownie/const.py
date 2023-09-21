from brownie.network import accounts

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

# GIF services
COMPONENT_OWNER_SERVICE_NAME = 'ComponentOwnerService'
PRODUCT_SERVICE_NAME = 'ProductService'
RISKPOOL_SERVICE_NAME = 'PoolService'
ORACLE_SERVICE_NAME = 'OracleService'

# GIF ecosystem actors
REGISTRY_OWNER = 'registryOwner'
INSTANCE_OWNER = 'instanceOwner'
PRODUCT_OWNER = 'productOwner'
POOL_OWNER = 'poolOwner'
CUSTOMER = 'customer'
CUSTOMER_2 = 'customer2'
OUTSIDER = 'outsider'

ACTORS = [REGISTRY_OWNER, INSTANCE_OWNER, PRODUCT_OWNER, POOL_OWNER, CUSTOMER, CUSTOMER_2, OUTSIDER]

ACCOUNTS = {
    REGISTRY_OWNER: 0,
    INSTANCE_OWNER: 1,
    PRODUCT_OWNER: 2,
    POOL_OWNER: 3,
    CUSTOMER: 6,
    CUSTOMER_2: 7,
    OUTSIDER: 9,
}

# GIF types
ADDRESS = 'address'
NFT_ID = 'uint96'
