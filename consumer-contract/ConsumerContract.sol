pragma solidity ^0.4.24;

interface IInvokeOracle {
    function requestData(address _authorizedWalletAddress,string  fromIndex) external returns (uint256 requestId);

    function showPrice(uint256 _reqid) external view returns (uint256 answer, uint256 updatedOn);
}

contract ConsumerContract {
    address CONTRACTADDR = 0x902e7B2555A699edE58e6C0A9086701833d996AD;
    address private owner;
    mapping(string => uint256) latestRequestData;


    constructor() public{
        owner = msg.sender;
    }

    //Note, below function will not trigger if you do not put PLI in above contract address
    function getPriceInfo(string  _symbol) external returns (uint256) {
        require(msg.sender==owner,"Only owner can trigger this");
        (latestRequestData[_symbol]) = IInvokeOracle(CONTRACTADDR).requestData({_authorizedWalletAddress:owner,fromIndex:_symbol});
        return latestRequestData[_symbol];
    }

    //TODO - you can customize below function as you want, but below function will give you the pricing value
    //This function will give you last stored value in the contract
    function show(string symbol) external view returns (uint256 _answer, string _symbol, uint256 _timestamp) {
        (uint256 answer, uint256 updatedOn) = IInvokeOracle(CONTRACTADDR).showPrice({_reqid: latestRequestData[symbol]});
        return (answer,symbol, updatedOn);
    }
}
