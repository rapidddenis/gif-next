// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

type VersionPart is uint8;

using {
    versionPartGt as >,
    versionPartEq as ==,
    VersionPartLib.toInt
}
    for VersionPart global;

function versionPartGt(VersionPart a, VersionPart b) pure returns(bool isGreaterThan) { return VersionPart.unwrap(a) > VersionPart.unwrap(b); }
function versionPartEq(VersionPart a, VersionPart b) pure returns(bool isSame) { return VersionPart.unwrap(a) == VersionPart.unwrap(b); }

library VersionPartLib {
    function toInt(VersionPart x) external pure returns(uint) { return VersionPart.unwrap(x); }
}

type Version is uint24; // contains major,minor,patch version parts

using {
    versionGt as >,
    versionEq as ==,
    VersionLib.toInt,
    VersionLib.toMajorPart,
    VersionLib.toVersionParts
}
    for Version global;

function versionGt(Version a, Version b) pure returns(bool isGreaterThan) { return Version.unwrap(a) > Version.unwrap(b); }
function versionEq(Version a, Version b) pure returns(bool isSame) { return Version.unwrap(a) == Version.unwrap(b); }

library VersionLib {
    function toInt(Version version) external pure returns(uint) { return Version.unwrap(version); }

    function toMajorPart(Version version)
        external    
        pure 
        returns(VersionPart major)
    { 
        uint24 versionInt = Version.unwrap(version);
        uint8 majorInt = uint8(versionInt >> 16);
        return VersionPart.wrap(majorInt);
    }

    function toVersionParts(Version version)
        external
        pure
        returns(
            VersionPart major,
            VersionPart minor,
            VersionPart patch
        )
    {
        uint24 versionInt = Version.unwrap(version);
        uint8 majorInt = uint8(versionInt >> 16);

        versionInt -= majorInt << 16;
        uint8 minorInt = uint8(versionInt >> 8);
        uint8 patchInt = uint8(versionInt - (minorInt << 8));

        return (
            VersionPart.wrap(majorInt),
            VersionPart.wrap(minorInt),
            VersionPart.wrap(patchInt)
        );
    }

    function toVersionPart(uint256 versionPart) external pure returns(VersionPart) { 
        return VersionPart.wrap(uint8(versionPart)); 
    }

    function toVersion(
        uint256 major,
        uint256 minor,
        uint256 patch
    )
        external
        pure
        returns(Version)
    {
        require(
            major < 256 && minor < 256 && patch < 256,
            "ERROR:VRS-010:VERSION_PART_TOO_BIG");

        return Version.wrap(
            uint24(
                (major << 16) + (minor << 8) + patch));
    }

    function zeroVersion() external pure returns(Version) {
        return Version.wrap(0);
    }
}
