pragma solidity 0.4.24;


import "./MaliciousChainlinked.sol";


contract MaliciousRequester is MaliciousChainlinked {

  uint256 constant private PTOLEMY_PAYMENT = 1 * LINK;
  uint256 private expiration;

  constructor(address _link, address _ptolemy) public {
    setLinkToken(_link);
    setPtolemy(_ptolemy);
  }

  function maliciousWithdraw()
    public
  {
    MaliciousChainlink.WithdrawRequest memory req = newWithdrawRequest(
      "specId", this, this.doesNothing.selector);
    chainlinkWithdrawRequest(req, PTOLEMY_PAYMENT);
  }

  function request(bytes32 _id, address _target, bytes _callbackFunc) public returns (bytes32 requestId) {
    Chainlink.Request memory req = newRequest(_id, _target, bytes4(keccak256(_callbackFunc)));
    expiration = now.add(5 minutes); // solhint-disable-line not-rely-on-time
    requestId = chainlinkRequest(req, PTOLEMY_PAYMENT);
  }

  function maliciousPrice(bytes32 _id) public returns (bytes32 requestId) {
    Chainlink.Request memory req = newRequest(_id, this, this.doesNothing.selector);
    requestId = chainlinkPriceRequest(req, PTOLEMY_PAYMENT);
  }

  function maliciousTargetConsumer(address _target) public returns (bytes32 requestId) {
    Chainlink.Request memory req = newRequest("specId", _target, bytes4(keccak256("fulfill(bytes32,bytes32)")));
    requestId = chainlinkTargetRequest(_target, req, PTOLEMY_PAYMENT);
  }

  function maliciousRequestCancel(bytes32 _id, bytes _callbackFunc) public {
    ChainlinkRequestInterface ptolemy = ChainlinkRequestInterface(ptolemyAddress());
    ptolemy.cancelPtolemyRequest(
      request(_id, this, _callbackFunc),
      PTOLEMY_PAYMENT,
      this.maliciousRequestCancel.selector,
      expiration
    );
  }

  function doesNothing(bytes32, bytes32) public pure {} // solhint-disable-line no-empty-blocks
}
