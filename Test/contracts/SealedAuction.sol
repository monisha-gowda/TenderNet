pragma solidity ^0.5.0;

contract SealedAuction
{
    // Auction parameters. Times are either
    // in the format of unix timestamps (seconds that have passed since 1970-01-01)
    // or a time period in seconds.

    //details of the Tender should be described
    address public beneficiaryAddress;
    uint public auctionClose;
    // Current state of the auction.
    address private topBidder;
    uint private topBid;

    // Will be set true once the auction is complete, preventing any further change
    bool auctionComplete;
	
   
   	struct Bid{
   			address Bidder;
   			uint Bid;
   	}
   	//ensuring one bid per bidder address
   	mapping(address => bool)private BidDone;
   	//mapping bidder address to their bid
   	mapping(uint => Bid) private Bids;
   	uint public BidCount;

    // Events to fire when change happens
    event auctionResult(address winner, uint bidAmount);

    /// Create an auction with `_biddingTime`
    /// seconds for bidding on behalf of the
    /// beneficiary address `_beneficiary`.
    constructor(
        uint _biddingTime,
        address _beneficiary
    ) internal {
        beneficiaryAddress = _beneficiary;
        auctionClose = now + _biddingTime;
    }

    /// You may bid on the auction with the value sent
    /// along with this transaction.
    function make_bid() public payable {
        // No argument is necessary, all
        // information is already added to
        // the transaction. The keyword payable
        // is required so the function
        // receives Ether.

        // Revert the call in case the bidding
        // period is over.
        require(now <= auctionClose);
        require(!BidDone[msg.sender]);
        if(msg.value > topBid)
        {
            topBidder = msg.sender;
            topBid = msg.value;
        }

        Bids[BidCount++]=Bid(msg.sender,msg.value);
        BidDone[msg.sender]=true;
    }

    //   function evaluate() internal{
    	//Define evaluation code to choose the winner bid for criteria other
    	//than the least bid offered from the mapping Bids 
    	//else
    	//finalbid = topbid and finalBidder = topbidder
    //  }

    function auctionEnd() private {
        // 1. Conditions
        require(now >= auctionClose); // auction did not yet end
        require(!auctionComplete); // this function has already been called

        // 2. Effects
        auctionComplete = true;
        emit auctionResult(topBidder, topBid);
    }
}