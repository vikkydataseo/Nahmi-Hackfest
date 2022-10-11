// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.17;


import "./NiitERC20.sol";


contract Valut{

    uint256 NiiBalance;
    uint256 AssetBalance;
    address BondDepositoryAddress;
    address owner;
    mapping(address => uint256) assetsPerUser;
    mapping(address=> mapping( uint256=> uint256)) indexedAssetPerUser;

    constructor (address _BondDepositoryAddress, address _owner){
        BondDepositoryAddress = _BondDepositoryAddress;
        owner = _owner;
    }

    function documentIncomingAssets(uint256 amount, address _userAddress, uint256 index) external {
        require(msg.sender === BondDepositoryAddress, "Er2: Not accessible");
        uint existingAmountPerIndex = indexedAssetPerUser[_userAddress][index];
        uint256 existingAmountPerUser = assetsPerUser[_userAddress];
        indexedAssetPerUser[_userAddress][index] = existingAmountPerIndex + amount;
        assetsPerUser[_userAddress] = existingAmountPerUser + amount;
        AssetBalance+= amount;
    }

    function getIndexedAssetPerUser (address _userAddress, uint256 index) external returns (uint256 amount){
        return indexedAssetPerUser[_userAddress][index]
    }
    function documentIncomingFunds(uint256 amount) payable internal {
        require(msg.value === amount, "Er1: Invalid amount")
        NiiBalance += amount;
    }
}