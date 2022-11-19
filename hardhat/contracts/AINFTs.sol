// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

error AINFTs__MaxTokenIdsReached();
error AINFTs__NotEnoughFunds();
error AINFTs__TransactionNotSent();

contract AINFTs is ERC721URIStorage, Ownable {
    uint256 public _tokenIds;
    uint256 public maxTokenIds = 100;
    uint256 public _price = 0.01 ether;
    address public tokenAddress;

    constructor(address _tokenAddress) ERC721("AINFTs", "AINFT") {
        tokenAddress = _tokenAddress;
    }

    function mintNFT(address recipient, string memory tokenURI)
        public
        payable
        returns (uint256)
    {
        address sender = msg.sender;

        if (_tokenIds > maxTokenIds) {
            revert AINFTs__MaxTokenIdsReached();
        }
        // if (msg.value < _price) {
        //     revert AINFTs__NotEnoughFunds();
        // }

        console.log("Token address is: %s", tokenAddress);

        console.log(
            "Token address balance is: %s",
            IERC20(tokenAddress).balanceOf(sender)
        );

        require(_price >= IERC20(tokenAddress).balanceOf(sender));
        _tokenIds += 1;

        IERC20(tokenAddress).transferFrom(sender, address(this), _price);
        _mint(recipient, _tokenIds);
        _setTokenURI(_tokenIds, tokenURI);

        return _tokenIds;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        if (!sent) {
            revert AINFTs__TransactionNotSent();
        }
    }

    receive() external payable {}

    fallback() external payable {}
}
