pragma solidity 0.4.24;

import "../interfaces/ChainlinkRequestInterface.sol";
import "../interfaces/PtolemyInterface.sol";

/* solhint-disable no-empty-blocks */

contract EmptyPtolemy is ChainlinkRequestInterface, PtolemyInterface {

  function cancelPtolemyRequest(bytes32, uint256, bytes4, uint256) external {}
  function fulfillPtolemyRequest(bytes32, uint256, address, bytes4, uint256, bytes32) external returns (bool) {}
  function getAuthorizationStatus(address) external view returns (bool) { return false; }
  function onTokenTransfer(address, uint256, bytes) external pure {}
  function ptolemyRequest(address, uint256, bytes32, address, bytes4, uint256, uint256, bytes) external {}
  function setFulfillmentPermission(address, bool) external {}
  function withdraw(address, uint256) external {}
  function withdrawable() external view returns (uint256) {}

}
