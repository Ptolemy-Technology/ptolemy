pragma solidity 0.4.24;

import "./Consumer.sol";

contract BasicConsumer is Consumer {

  constructor(address _link, address _ptolemy, bytes32 _specId) public {
    setChainlinkToken(_link);
    setChainlinkPtolemy(_ptolemy);
    specId = _specId;
  }

}
