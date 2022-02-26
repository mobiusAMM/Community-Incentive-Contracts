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
        uint256 timeOfRequest;
        uint256 timeOfFulfillment;
        bool killed;
        uint256 approvals;
    }

    struct GeneralRequest {
        uint256 id;
        address origin;
        uint256 requestedReward;
        bool fulfilled;
        uint256 approvals;
    }

    event BugReportCreated(
        uint256 indexed id,
        address indexed origin,
        BugLevel severity,
        uint256 time,
        string description
    );

    event RequestCreated(
        uint256 indexed id,
        address indexed origin,
        uint256 requestedReward,
        uint256 time,
        string description
    );

    event BugReportApproved(uint256 indexed id, address admin);
    event RequestApproved(uint256 indexed id, address admin);

    event ReportPaid(
        bool indexed isBugReport,
        uint256 indexed id,
        address payee,
        uint256 reward
    );
}
