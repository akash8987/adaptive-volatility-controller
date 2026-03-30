const { ethers } = require("ethers");

/**
 * Simulates how the fee scales as the price deviates from the TWAP.
 */
function simulateFeeScaling(tickDiff) {
    const factor = tickDiff * 10;
    let fee;
    
    if (factor > 500) fee = "2.0%";
    else if (factor > 200) fee = "1.0%";
    else fee = "0.5%";

    console.log(`Tick Deviation: ${tickDiff} | Calculated Fee: ${fee}`);
}

console.log("Scenario 1: Stable Market");
simulateFeeScaling(10); 

console.log("Scenario 2: High Volatility");
simulateFeeScaling(60);
