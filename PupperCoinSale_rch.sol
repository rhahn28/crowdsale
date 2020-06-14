pragma solidity ^0.5.0;
import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
// @TODO: Inherit the crowdsale contracts
// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint cap,
        uint openingTime,
        uint closingTime,
        uint goal
    )
            // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        RefundablePostDeliveryCrowdsale()
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        CappedCrowdsale(cap)
        public {
        }
    }
contract PupperCoinSaleDeployer {
    
    address public pupper_sale_address;  // this is  the contract addresses
    address public token_address;  // contractt address
    
    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal,// this address will receive all Ether raised by the sale
        uint cap
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        // TOKEN STUFF- creating and getitng the address of the smart contract for the token
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);  // use function address and get it from the token
                                      // this is the address of the smart contract that represents the coin
        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        // TOKEN SALE STUFF
        /*
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint cap,
        uint openingTime,
        uint closingTime,
        uint goal
        */
        PupperCoinSale pupper_sale = new PupperCoinSale(
                                        1,  //conversion rate wei => token
                                        wallet, // where the tokens end up
                                        token, // token being sold
                                        cap, //max token to sell
                                        now, 
                                        now + 30 minutes, 
                                        goal //goal amount);
        pupper_sale_address = address(pupper_sale);
        
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(pupper_sale_address);
        token.renounceMinter();