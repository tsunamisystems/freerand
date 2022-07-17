// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface Rand {
    function rand(uint256[] calldata inputs) external view returns (uint256);
}

contract RandExample {
    Rand randv3 = Rand(0x57794b9C51C879DA6470dD0F6865b2ACF933C7FE);

    function foo() public view returns (uint256) {
        uint256[] memory seed; // here we use an empty seed
        uint256 r = randv3.rand(seed);
        return r;
    }
} // ts22

interface IERC20 {
    function transfer(address to, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}
