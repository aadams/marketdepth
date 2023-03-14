// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import {FullMath} from "v3-core/contracts/libraries/FullMath.sol";
import {IDepth} from "./IDepth.sol";

library DepthLib {
    function setInitialPrices(IDepth.DepthConfig memory config, uint160 sqrtPriceX96, uint160 sqrtDepthX96)
        internal
        returns (uint160 sqrtPriceX96Current, uint160 sqrtPriceX96Tgt)
    {
        if (config.bothSides) {
            // if both, current is lower and target the upper range and we just move upwards
            sqrtPriceX96Current = uint160(FullMath.mulDiv(sqrtPriceX96, 1 << 96, sqrtDepthX96));
            sqrtPriceX96Tgt = uint160(FullMath.mulDiv(sqrtPriceX96, sqrtDepthX96, 1 << 96));
        } else {
            // if upper is true, set current to price and tgt to upper
            // if upper is false, set current to lower and tgt to price
            sqrtPriceX96Current =
                config.upper ? sqrtPriceX96 : uint160(FullMath.mulDiv(sqrtPriceX96, sqrtDepthX96, 1 << 96));
            sqrtPriceX96Tgt =
                config.upper ? uint160(FullMath.mulDiv(sqrtPriceX96, sqrtDepthX96, 1 << 96)) : sqrtPriceX96;
        }
    }
}
