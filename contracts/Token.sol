//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// My token contract address 0xfC6406Ef530549415e89180532c88139979c2a66

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    
    address public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        owner = msg.sender;
        // Mint initial supply to the contract deployer
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

        function mintFifty() public onlyOwner {
        _mint(msg.sender, 50 * 10**18);
    }
}