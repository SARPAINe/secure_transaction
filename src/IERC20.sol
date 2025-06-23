// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IERC20 {
    // function balanceOf(address account) external view returns (uint256);
    function balanceOf(address who) external view returns (uint);

    function transfer(address recipient, uint256 amount) external;

    function approve(address spender, uint256 amount) external;

    function isBlackListed(address who) external view returns (bool);

    function allowance(
        address _owner,
        address _spender
    ) external returns (uint remaining);
    // Add other necessary functions here
}
