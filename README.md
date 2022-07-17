## free rand() on bsc

warning: experimental, use at your own risk.

```solidity
interface Rand {
    function rand(uint256[] calldata inputs) external view returns (uint256);
}
```

```solidity
contract RandExample {
    Rand randv3 = Rand(0x57794b9C51C879DA6470dD0F6865b2ACF933C7FE);
    function foo() public view returns (uint256) {
        uint256[] memory seed; // here we use an empty seed
        uint256 r = randv3.rand(seed);
        return r;
    }
}
```

uses balances of a number of tokens/addresses to produce pseudo random

  * dead bnb
  * validating bnb
  * dead safemoon
  * number of wbnb in wbnb/busd pool
  * number of busd in wbnb/busd pool

(these numbers constantly change, combined with an optional given seed such as tokenId or whatever)
