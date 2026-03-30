// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolatilityOracle is Ownable {
    IUniswapV3Pool public immutable pool;
    uint32 public constant TWAP_PERIOD = 30 minutes;

    constructor(address _pool) Ownable(msg.sender) {
        pool = IUniswapV3Pool(_pool);
    }

    /**
     * @dev Returns a simplified "Volatility Factor" (0-1000).
     * Compares short-term price to long-term TWAP.
     */
    function getVolatilityFactor() public view returns (uint256) {
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = TWAP_PERIOD;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives, ) = pool.observe(secondsAgos);

        int56 tickAverage = (tickCumulatives[1] - tickCumulatives[0]) / int32(TWAP_PERIOD);
        
        // Simplified: calculate distance from current tick to average
        (, int24 currentTick, , , , , ) = pool.slot0();
        int24 diff = currentTick > int24(tickAverage) ? currentTick - int24(tickAverage) : int24(tickAverage) - currentTick;

        // Scale the difference into a basis point factor
        return uint256(uint24(diff)) * 10; 
    }

    function getCurrentFeeBps() external view returns (uint256) {
        uint256 factor = getVolatilityFactor();
        if (factor > 500) return 200; // 2% fee during high stress
        if (factor > 200) return 100; // 1% fee during moderate stress
        return 50; // 0.5% base fee
    }
}
