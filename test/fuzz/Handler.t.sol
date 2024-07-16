//SPDX-License-Identifier: MIT

//Handler is going to narrow down the way we call the function
//e.g. only call redeemCollateral when there is collateral present

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralisedStableCoin} from "../../src/DecentralisedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    DSCEngine engine;
    DecentralisedStableCoin dsc;

    ERC20Mock weth;
    ERC20Mock wbtc;

    address USER = makeAddr("USER");

    uint96 public constant MAX_DEPOSIT_SIZE = type(uint96).max;

    constructor(DSCEngine _engine, DecentralisedStableCoin _dsc) {
        engine = _engine;
        dsc = _dsc;

        address[] memory collateralTokens = engine.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);
    }

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        amountCollateral = amountCollateral > MAX_DEPOSIT_SIZE ? MAX_DEPOSIT_SIZE : amountCollateral; // amountCollateral greater than max depo size true THEN max depo size, false THEN amountCollateral
        amountCollateral = amountCollateral <= 0 ? 1 : amountCollateral; // amountCollateral less than or equal to 0 true THEN 1, false THEN amountCollateral

        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);

        vm.startPrank(USER);
        collateral.mint(USER, amountCollateral);
        collateral.approve(address(engine), amountCollateral);
        engine.depositCollateral(address(collateral), amountCollateral);
        vm.stopPrank();
    }

    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = engine.getCollateralBalanceOfUserPerToken(USER, address(collateral));
        amountCollateral = bound(amountCollateral, 0, maxCollateralToRedeem);
        if (amountCollateral == 0) {
            return;
        }

        vm.startPrank(USER);
        engine.redeemCollateral(address(collateral), amountCollateral);
        vm.stopPrank();
    }

    //Helper Functions
    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
