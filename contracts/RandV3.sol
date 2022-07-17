// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

address constant dead = 0x000000000000000000000000000000000000dEaD;

// optional seed should be some nonce (number used once) to prevent duplicate in-same-block results
// solid example would be ([nonceOrTokenId, address(this).balance, balanceOf(this), balanceOf(dead)])
contract RandV3 is OwnableUpgradeable {
    using AddressUpgradeable for *;
    string public _name;
    string public _symbol;
    struct tokenHolder {
        IERC20 token;
        address holder;
    }
    tokenHolder[] public tokenHolders;

    function initialize() public initializer {
        __Ownable_init();
        _name = "RandV3";
        _symbol = "FREERAND";

        // dead bnb
        tokenHolders.push(
            tokenHolder({
                token: IERC20(address(0)),
                holder: address(0x000000000000000000000000000000000000dEaD)
            })
        );
        // v
        tokenHolders.push(
            tokenHolder({
                token: IERC20(address(0)),
                holder: address(0x0000000000000000000000000000000000001000)
            })
        );
        // sfm
        tokenHolders.push(
            tokenHolder({
                token: IERC20(
                    address(0x42981d0bfbAf196529376EE702F2a9Eb9092fcB5)
                ),
                holder: address(0x0000000000000000000000000000000000000001)
            })
        );
        // wbnb/busd wbnb
        tokenHolders.push(
            tokenHolder({
                token: IERC20(
                    address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c)
                ),
                holder: address(0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE)
            })
        );
        // wbnb/busd busd
        tokenHolders.push(
            tokenHolder({
                token: IERC20(
                    address(0x55d398326f99059fF775485246999027B3197955)
                ),
                holder: address(0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE)
            })
        );
    }

    // free rand()
    function rand(uint256[] calldata optionalSeed)
        public
        view
        returns (uint256)
    {
        return uint256(bytes32(keccak256(seeded(optionalSeed))));
    }

    // free rand()
    function easyrand() public view returns (uint256) {
        uint256[] memory a;
        return uint256(bytes32(keccak256(seeded2(a))));
    }

    function randuint8(uint256[] calldata optionalSeed)
        public
        view
        returns (uint8)
    {
        return uint8(bytes32(keccak256(seeded(optionalSeed)))[0]);
    }

    // free rand bytes32
    function randbytes32(uint256[] calldata optionalSeed)
        public
        view
        returns (bytes32)
    {
        return bytes32(keccak256(seeded(optionalSeed)));
    }

    function hashed(uint256[] calldata optionalSeed)
        public
        view
        returns (bytes32)
    {
        return keccak256(seeded(optionalSeed));
    }

    function seeded(uint256[] calldata optionalSeed)
        public
        view
        returns (bytes memory)
    {
        uint256[] memory balances = getBalances();
        return
            abi.encodePacked(
                balances,
                optionalSeed // IMPORTANT: if not, every call in this block will have same rand output.
            );
    }

    function seeded2(uint256[] memory optionalSeed)
        public
        view
        returns (bytes memory)
    {
        uint256[] memory balances = getBalances();
        return
            abi.encodePacked(
                balances,
                optionalSeed // IMPORTANT: if not, every call in this block will have same rand output.
            );
    }

    function setTokens(tokenHolder[] calldata tokenHolders_) public onlyOwner {
        uint256 l = tokenHolders_.length;
        for (uint256 i = 0; i < l; i++) {
            tokenHolders.push(tokenHolders_[i]);
        }
    }

    function pushTokenholders(tokenHolder[] calldata tokenHolders_)
        public
        onlyOwner
    {
        uint256 l = tokenHolders_.length;
        for (uint256 i = 0; i < l; i++) {
            tokenHolders.push(tokenHolders_[i]);
        }
    }

    function pushTokens(IERC20[] calldata tokens_, address[] calldata addrs_)
        public
        onlyOwner
    {
        uint256 l = addrs_.length;
        require(l == tokens_.length, "length mismatch");
        for (uint256 i = 0; i < l; i++) {
            tokenHolders.push(
                tokenHolder({token: tokens_[i], holder: addrs_[i]})
            );
        }
    }

    function getBalances() public view returns (uint256[] memory balances) {
        balances = new uint256[](tokenHolders.length);
        for (uint256 i = 0; i < tokenHolders.length; i++) {
            tokenHolder memory th = tokenHolders[i];
            balances[i] = address(th.token) == address(0)
                ? th.holder.balance
                : th.token.balanceOf(th.holder);
        }
        return balances;
    }

    function getTokens() public view returns (tokenHolder[] memory) {
        return tokenHolders;
    }

    function getNTokens() public view returns (uint256) {
        return tokenHolders.length;
    }

    // override name, symbol, and metadata
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function setNameSymbol(string memory name_, string memory symbol_)
        public
        onlyOwner
    {
        _name = name_;
        _symbol = symbol_;
    }

    /// @dev admin can get ether out
    function getEther(address to, uint256 amount) public onlyOwner {
        if (amount == 0) {
            amount = address(this).balance;
        }
        payable(to).sendValue(amount);
    }

    ///@dev admin can get all ether out
    function withdrawEther() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    /// @dev admin can get token (it happens..)
    function getToken(
        address tokenAddr,
        address to,
        uint256 amount
    ) public onlyOwner {
        IERC20 token = IERC20(tokenAddr);
        if (amount == 0) {
            amount = token.balanceOf(address(this));
        }
        token.transfer(to, amount);
    }
} // ts22

interface IERC20 {
    function transfer(address to, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}
