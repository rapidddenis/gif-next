// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

// uint96 allows for chain ids up to 13 digits
type ObjectType is uint8;

// type bindings
using {
    eqObjectType as ==,
    neObjectType as !=,
    ObjectTypeLib.toInt
} for ObjectType global;

// general pure free functions
/// @dev Converts the uint8 to a ObjectTypeId.
function toObjectType(uint256 objectType) pure returns(ObjectType) { return ObjectType.wrap(uint8(objectType)); }

/// @dev Return the ObjectType zero (0)
function zeroObjectType() pure returns(ObjectType) { return ObjectType.wrap(0); }

// pure free functions for operators
function eqObjectType(ObjectType a, ObjectType b) pure returns(bool isSame) { return ObjectType.unwrap(a) == ObjectType.unwrap(b); }
function neObjectType(ObjectType a, ObjectType b) pure returns(bool isDifferent) { return ObjectType.unwrap(a) != ObjectType.unwrap(b); }

// library functions that operate on user defined type
library ObjectTypeLib {
    /// @dev Converts the NftId to a uint256.
    function toInt(ObjectType objectType) public pure returns(uint96) { return uint96(ObjectType.unwrap(objectType)); }
    /// @dev Returns true if the value is non-zero (> 0).
    function gtz(ObjectType a) public pure returns(bool) { return ObjectType.unwrap(a) > 0; }
    /// @dev Returns true if the value is zero (== 0).
    function eqz(ObjectType a) public pure returns(bool) { return ObjectType.unwrap(a) == 0; }
    /// @dev Returns true if the values are equal (==).
    function eq(ObjectType a, ObjectType b) public pure returns(bool isSame) { return eqObjectType(a, b); }
}
