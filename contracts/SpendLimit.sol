// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SpendLimit {
    uint public ONE_DAY = 1 minutes;

    /// This struct serves as data storage of daily spending limits users enable
    /// limit: the amount of a daily spending limit
    /// available: the available amount that can be spent
    /// resetTime: block.timestamp at the available amount is restored
    /// isEnabled: true when a daily spending limit is enabled
    struct Limit {
        uint limit;
        uint available;
        uint resetTime;
        bool isEnabled;
    }

    mapping(address => Limit) public limits; // token => Limit

    modifier onlyAccount() {
        require(
            msg.sender == address(this),
            "Only the account that inherits this contract can call this method."
        );
        _;
    }

    function setSpendingLimit(address _token, uint _amount) public onlyAccount {
        require(_amount != 0, "Invalid Amount");

        uint resetTime;
        uint timestamp = block.timestamp; // L2 Block timestamp

        if (_isValidUpdate(_token)) {
            resetTime = ONE_DAY + timestamp;
        } else {
            resetTime = timestamp;
        }
        _updateLimit(_token, _amount, _amount, resetTime, true);
    }

    function removeSpendingLimit(address _token) public onlyAccount {
        require(_isValidUpdate(_token), "Invalid Update");
        _updateLimit(_token, 0, 0, 0, false);
    }

    function _isValidUpdate(address _token) internal view returns (bool) {
        if (limits[_token].isEnabled) {
            require(
                limits[_token].limit == limits[_token].available ||
                    block.timestamp > limits[_token].resetTime,
                "Invalid Update"
            );

            return true;
        } else {
            return false;
        }
    }

    function _updateLimit(
        address _token,
        uint _limit,
        uint _available,
        uint _resetTime,
        bool _isEnabled
    ) private {
        Limit storage limit = limits[_token];
        limit.limit = _limit;
        limit.available = _available;
        limit.resetTime = _resetTime;
        limit.isEnabled = _isEnabled;
    }

    function _checkSpendingLimit(address _token, uint _amount) internal {
        Limit memory limit = limits[_token];

        if (!limit.isEnabled) return;

        uint timestamp = block.timestamp; // L2 block timestamp

        if (limit.limit != limit.available && timestamp > limit.resetTime) {
            limit.resetTime = timestamp + ONE_DAY;
            limit.available = limit.limit;

        } else if (limit.limit == limit.available) {
            limit.resetTime = timestamp + ONE_DAY;
        }

        require(limit.available >= _amount, "Exceed daily limit");

        limit.available -= _amount;
        limits[_token] = limit;
    }
}
