# Adaptive Volatility Controller

Fixed tokenomics often fail during "Black Swan" events. This repository implements a reactive fee model that scales based on market conditions. It acts as an algorithmic "Shock Absorber" for the project's native token.

## Logic Flow
1. **Observation**: The contract queries a Uniswap V3 pool for the Time-Weighted Average Price (TWAP).
2. **Calculation**: It compares the current price to the TWAP to determine a "Volatility Score."
3. **Adjustment**: 
    - **High Volatility**: Fee increases (e.g., from 0.5% to 2.0%) to increase buyback power.
    - **Low Volatility**: Fee decreases (e.g., to 0.2%) to reward active traders.
4. **Enforcement**: The `TaxHarvester` from Repo 40 queries this controller before every execution.

## Technical Strategy
Uses the **Geometric Mean TWAP** to prevent price manipulation, ensuring the fee only changes based on sustained market movement rather than single-block "flash" spikes.
