pragma solidity >=0.4.21 <0.7.0;
import "https://github.com/Ptolemy-Technology/ptolemy/evm-contracts/src/v0.4/PChainlinkClient.sol";
import "https://github.com/Ptolemy-Technology/ptolemy/evm-contracts/src/v0.4/vendor/Ownable.sol";
contract price is ChainlinkClient, Ownable{
    event HighestBidIncreased(address bidder, uint amount); // Event

    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;

  uint256 public currentPrice;
  int256 public changeDay;

  event RequestFulfilled(
    bytes32 indexed requestId,
    uint256 indexed price
  );

 

  constructor() public Ownable() {
    setPublicChainlinkToken();
  }  
 function requestPrice(address _oracle, string _jobId,string _imageUrl)
  public
  onlyOwner
 
{
  Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), this, this.fulfill.selector);
 req.add("queryParams", _imageUrl);
 //req.add("version","2018-3-19");
 //req.add("classifier_ids","default");
 // req.addInt("times",100);
  sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
} 
    
    
   function fulfill(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
  {
    emit RequestFulfilled(_requestId, _price);
    currentPrice = _price;
  }
  
    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly { // solhint-disable-line no-inline-assembly
      result := mload(add(source, 32))
    }
  } 
    
    
}













