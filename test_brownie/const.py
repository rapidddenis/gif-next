from brownie.network import accounts

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

# GIF general
VERSION = (3, 0, 0)

# GIF object types
PROTOCOL = 10
REGISTRY = 20
TOKEN = 30
SERVICE = 40
INSTANCE = 50
STAKE = 60
COMPONENT = 100
TREASURY = 101
PRODUCT = 110
COMPENSATION = 120
ORACLE = 130
POOL = 140
RISK = 200
POLICY = 210
BUNDLE = 220
CLAIM = 211
PAYOUT = 212

# GIF services
COMPONENT_OWNER_SERVICE_NAME = 'ComponentOwnerService'
PRODUCT_SERVICE_NAME = 'ProductService'
POOL_SERVICE_NAME = 'PoolService'
ORACLE_SERVICE_NAME = 'OracleService'

# GIF roles
POOL_OWNER_ROLE = 'PoolOwnerRole'
PRODUCT_OWNER_ROLE = 'ProductOwnerRole'

# GIF ecosystem actors
REGISTRY_OWNER = 'registryOwner'
INSTANCE_OWNER = 'instanceOwner'
PRODUCT_OWNER = 'productOwner'
POOL_OWNER = 'poolOwner'
INVESTOR = 'investor'
CUSTOMER = 'customer'
CUSTOMER_2 = 'customer2'
OUTSIDER = 'outsider'

ACTORS = [REGISTRY_OWNER, INSTANCE_OWNER, PRODUCT_OWNER, POOL_OWNER, INVESTOR, CUSTOMER, CUSTOMER_2, OUTSIDER]

ACCOUNTS = {
    REGISTRY_OWNER: 0,
    INSTANCE_OWNER: 1,
    PRODUCT_OWNER: 2,
    POOL_OWNER: 3,
    INVESTOR: 6,
    CUSTOMER: 7,
    CUSTOMER_2: 8,
    OUTSIDER: 9,
}

# GIF types
ADDRESS = 'address'
NFT_ID = 'uint96'
