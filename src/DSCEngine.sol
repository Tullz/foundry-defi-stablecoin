//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title DSCEngine
 * @author Tullz
 * The system is designed to be as mininmal as possible, and have the tokens maintain a $1 Peg
 * This stablecoins has the properties:
 * - Exogenous Collateral
 * - Dollar Pegged
 * - Algorithmically stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was only backed by wETH and wBTC
 *
 * Our DSC system should always be "overcollateralised". More collateral than DSC at all times
 *
 * @notice This contract is the core of the DSC system.
 * @notice It handles all the logic for mining and redeeming, as well as depositing and withdrawing collateral
 * @notice This contratc is VERY loosely based on the MakerDAO DSS (DAI) system
 */
contract DSCEngine {
    function depositCollateralAndMintDsc() external {}

    function depositCollateral() external {}

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
