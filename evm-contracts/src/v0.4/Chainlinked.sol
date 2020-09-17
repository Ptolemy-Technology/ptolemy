pragma solidity ^0.4.24;

import "./ChainlinkClient.sol";

/**
 * @title The Chainlinked contract
 * @notice Contract writers can inherit this contract in order to create requests for the
 * Chainlink network. ChainlinkClient is an alias of the Chainlinked contract.
 */
contract Chainlinked is ChainlinkClient {
  /**
   * @notice Creates a request that can hold additional parameters
   * @param _specId The Job Specification ID that the request will be created for
   * @param _callbackAddress The callback address that the response will be sent to
   * @param _callbackFunctionSignature The callback function signature to use for the callback address
   * @return A Chainlink Request struct in memory
   */
  function newRequest(
    bytes32 _specId,
    address _callbackAddress,
    bytes4 _callbackFunctionSignature
  ) internal pure returns (Chainlink.Request memory) {
    return buildChainlinkRequest(_specId, _callbackAddress, _callbackFunctionSignature);
  }

  /**
   * @notice Creates a Chainlink request to the stored ptolemy address
   * @dev Calls `sendChainlinkRequestTo` with the stored ptolemy address
   * @param _req The initialized Chainlink Request
   * @param _payment The amount of LINK to send for the request
   * @return The request ID
   */
  function chainlinkRequest(Chainlink.Request memory _req, uint256 _payment)
    internal
    returns (bytes32)
  {
    return sendChainlinkRequest(_req, _payment);
  }

  /**
   * @notice Creates a Chainlink request to the specified ptolemy address
   * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
   * send LINK which creates a request on the target ptolemy contract.
   * Emits ChainlinkRequested event.
   * @param _ptolemy The address of the ptolemy for the request
   * @param _req The initialized Chainlink Request
   * @param _payment The amount of LINK to send for the request
   * @return The request ID
   */
  function chainlinkRequestTo(address _ptolemy, Chainlink.Request memory _req, uint256 _payment)
    internal
    returns (bytes32 requestId)
  {
    return sendChainlinkRequestTo(_ptolemy, _req, _payment);
  }

  /**
   * @notice Sets the stored ptolemy address
   * @param _ptolemy The address of the ptolemy contract
   */
  function setPtolemy(address _ptolemy) internal {
    setChainlinkPtolemy(_ptolemy);
  }

  /**
   * @notice Sets the LINK token address
   * @param _link The address of the LINK token contract
   */
  function setLinkToken(address _link) internal {
    setChainlinkToken(_link);
  }

  /**
   * @notice Retrieves the stored address of the LINK token
   * @return The address of the LINK token
   */
  function chainlinkToken()
    internal
    view
    returns (address)
  {
    return chainlinkTokenAddress();
  }

  /**
   * @notice Retrieves the stored address of the ptolemy contract
   * @return The address of the ptolemy contract
   */
  function ptolemyAddress()
    internal
    view
    returns (address)
  {
    return chainlinkPtolemyAddress();
  }

  /**
   * @notice Ensures that the fulfillment is valid for this contract
   * @dev Use if the contract developer prefers methods instead of modifiers for validation
   * @param _requestId The request ID for fulfillment
   */
  function fulfillChainlinkRequest(bytes32 _requestId)
    internal
    recordChainlinkFulfillment(_requestId)
    // solhint-disable-next-line no-empty-blocks
  {}

  /**
   * @notice Sets the stored ptolemy and LINK token contracts with the addresses resolved by ENS
   * @dev Accounts for subnodes having different resolvers
   * @param _ens The address of the ENS contract
   * @param _node The ENS node hash
   */
  function setChainlinkWithENS(address _ens, bytes32 _node)
    internal
  {
    useChainlinkWithENS(_ens, _node);
  }

  /**
   * @notice Sets the stored ptolemy contract with the address resolved by ENS
   * @dev This may be called on its own as long as `setChainlinkWithENS` has been called previously
   */
  function setPtolemyWithENS()
    internal
  {
    updateChainlinkPtolemyWithENS();
  }

  /**
   * @notice Allows for a request which was created on another contract to be fulfilled
   * on this contract
   * @param _ptolemy The address of the ptolemy contract that will fulfill the request
   * @param _requestId The request ID used for the response
   */
  function addExternalRequest(address _ptolemy, bytes32 _requestId)
    internal
  {
    addChainlinkExternalRequest(_ptolemy, _requestId);
  }
}
