pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface CommunityPaymentEvents {
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

    event AdminAdded(address indexed account, uint256 time);

    event AdminRemoved(address indexed account, uint256 time);

    event BugReportLevelChanged(
        BugLevel indexed level,
        uint256 indexed time,
        uint256 previousAmount,
        uint256 newAmount
    );
}

contract CommunityPayment is CommunityPaymentEvents, Ownable {
    mapping(address => bool) public admin;
    uint256 public numberOfAdmin;
    uint256 public threshold;

    IERC20 public rewardToken;
    uint256[3] public bugReportPayLevels;

    constructor(
        address owner,
        address[] memory initialAdmin,
        uint256 initialThreshold,
        IERC20 initialRewardToken,
        uint256[3] memory bugReportLevels
    ) {
        require(
            threshold <= initialAdmin.length,
            "Threshold > number of admin"
        );
        _transferOwnership(owner); // Give full ownership to the owner address
        rewardToken = initialRewardToken;
        threshold = initialThreshold;
        numberOfAdmin = initialAdmin.length;

        for (uint256 i = 0; i < numberOfAdmin; i++) {
            admin[initialAdmin[i]] = true;
        }

        bugReportPayLevels = bugReportLevels;
    }

    modifier isAdmin(address loc) {
        require(admin[loc], "Not an admin");
        _;
    }

    function addAdmin(address account) external onlyOwner {
        require(!admin[account], "Already admin");
        admin[account] = true;
        numberOfAdmin++;

        emit AdminAdded(account, block.timestamp);
    }

    function removeAdmin(address account) external onlyOwner isAdmin(account) {
        admin[account] = false;
        numberOfAdmin--;
        emit AdminRemoved(account, block.timestamp);
    }

    function _updateBugPaymentLevel(BugLevel level, uint256 newAmount)
        internal
    {
        uint256 previousAmount = bugReportPayLevels[uint256(level)];
        bugReportPayLevels[uint256(level)] = newAmount;

        emit BugReportLevelChanged(
            level,
            block.timestamp,
            previousAmount,
            newAmount
        );
    }
}
