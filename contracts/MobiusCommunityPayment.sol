pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MobiusCommunityPayment {
    enum BugLevel {
        BASIC,
        MEDIUM,
        IMPORTANT
    }

    struct BugReport {
        uint256 id;
        address origin;
        BugLevel perceivedLevel;
        bool fulfilled;
        uint256 approvals;
    }

    struct GeneralRequest {
        uint256 id;
        address origin;
        uint256 requestedReward;
        bool fulfilled;
        uint256 approvals;
    }
}
