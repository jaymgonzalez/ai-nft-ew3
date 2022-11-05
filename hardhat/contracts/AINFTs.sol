// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

error AINFTs__MaxTokenIdsReached();
error AINFTs__NotEnoughFunds();
error AINFTs__TransactionNotSent();

contract AINFTs is ERC721URIStorage, Ownable {
    uint256 public _tokenIds;
    uint256 public maxTokenIds = 100;
    uint256 public _price = 0.01 ether;

    constructor() ERC721("AINFTs", "AINFT") {}

    function mintNFT(address recipient, string memory tokenURI)
        public
        payable
        onlyOwner
        returns (uint256)
    {
        if (_tokenIds > maxTokenIds) {
            revert AINFTs__MaxTokenIdsReached();
        }
        if (msg.value < _price) {
            revert AINFTs__NotEnoughFunds();
        }
        _tokenIds += 1;

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
