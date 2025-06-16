// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title KipuBank
 * @dev Ether bank implementation
 * Accounts owners could deposit and withdraw funds
 */
contract KipuBank {
    // ============== IMMUTABLE VARIABLES ========
    
    /// @notice Maximum amount allowed per transaction
    uint256 public immutable transactionThreshold;

    /// @notice Maximum total ETH the bank can hold
    uint256 public immutable bankCap;

    // ============== STATE VARIABLES ============
    
    /// @notice Owner of the contract
    address public owner;

    /// @notice Total number of successful deposits
    uint256 public depositsCount;

    /// @notice Total number of successful withdrawals
    uint256 public withdrawalsCount;
    
    // ============== MAPPINGS ===================

    /// @notice Mapping to track ETH balances of users
    mapping(address => uint256) usersAccounts;  // List of bank user accounts
    
    // ============== EVENTS =====================
    
    /// @notice Emitted when ETH is deposited
    /// @param from The address making the deposit
    /// @param amount Amount of ETH deposited
    /// @param newBalance The user's balance after deposit
    event EtherStored(address indexed from, uint256 amount, uint256 newBalance);

    /// @notice Emitted when ETH is withdrawn
    /// @param to The address receiving the ETH
    /// @param amount Amount of ETH sent
    /// @param newBalance The sender's balance after withdrawal
    event EtherSent(address indexed to, uint256 amount, uint256 newBalance);
    
    // ============== CUSTOM ERRORS ==============
    /// @notice Thrown when ETH sent is zero
    error InvalidAmount();

    /// @notice Thrown when deposit or withdrawal exceeds threshold
    error ExceedsTransactionThreshold();
    
    /// @notice Thrown when withdrawal amount exceeds user balance
    error InsufficientBalance();
    
    /// @notice Thrown when ETH is sent along with withdrawal call
    error NoETHOnWithdraw();

    /// @notice Thrown when the native transfer fails
    error TransferFailed();

    /// @notice Thrown when an unknown function is called
    error InvalidFunctionCall();

    /// @notice Thrown when total deposits exceed global bank cap
    error BankCapExceeded();

    // ============== MODIFIERS ==================
    
    /**
    * @dev Modifier to check the amount is valid by being more than zero
    */
    modifier validAmount() {
        if (msg.value == 0) revert InvalidAmount();
        _;
    }
    
    // ============== CONSTRUCTOR ==============

    /// @notice Initializes the contract setting the deployer as the owner and sets limits
    constructor() {
        owner = msg.sender;             // set contract owner
        transactionThreshold = 2 ether; // max transaction threshold
        bankCap = 100 ether;            // bankcap max limit
    }
    
    // ============== Bank Deposit Functions ==============
    
    /// @notice Deposits ETH to your personal account
    /// @dev Enforces threshold and balance cap
    function deposit() external payable validAmount {
        _handleDeposit(msg.sender, msg.value);
    }
    
    /// @notice Automatically deposits ETH via direct transfer (no calldata)
    receive() external payable {
        _handleDeposit(msg.sender, msg.value);
    }
    
    /// @notice Reverts on unknown function call or calldata
    fallback() external payable {
        revert InvalidFunctionCall();
    }
    
    // ============== Bank Withdrawal/Send Functions ==============
    
    /// @notice Withdraw up to the allowed threshold to a recipient
    /// @param recipient The address receiving the ETH
    /// @param amount The amount to withdraw
    function withdraw(address recipient, uint256 amount) external payable {
        if (msg.value > 0) revert NoETHOnWithdraw();
        if (amount > transactionThreshold) revert ExceedsTransactionThreshold();

        uint256 accountBalance = usersAccounts[msg.sender];
        if (accountBalance < amount) revert InsufficientBalance();
        
        uint256 newBalance = accountBalance - amount;
        usersAccounts[msg.sender] = newBalance;

        (bool success, ) = payable(recipient).call{value: amount}("");
        if (!success) revert TransferFailed();
    
        withdrawalsCount++;    
        emit EtherSent(recipient, amount, newBalance);
    }
    
    // ============== PRIVATE FUNCTIONS ==============

    /// @dev Internal function to handle deposits
    /// @param sender The account depositing ETH
    /// @param amount The ETH amount being deposited
    function _handleDeposit(address sender, uint256 amount) internal validAmount {
        if (amount > transactionThreshold) revert ExceedsTransactionThreshold();

        uint256 accountBalance = usersAccounts[sender];
        uint256 newBalance = accountBalance + amount;

        if (address(this).balance + amount > bankCap) revert BankCapExceeded();

        usersAccounts[sender] = newBalance;
        depositsCount++;
        emit EtherStored(sender, amount, accountBalance);
    }

    // ============== EXTERNAL VIEW FUNCTIONS ==============
    
    /// @notice Returns the ETH balance of the caller
    /// @return Balance of caller's personal account
    function myBalance() external view returns (uint256) {
        return usersAccounts[msg.sender];
    }

    /// @notice Returns the total ETH held by the bank
    /// @return Current ETH balance of the contract
    function bankBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns the ETH balance of any user
    /// @param user Address to query
    /// @return Balance of the specified user
    function balanceOf(address user) external view returns (uint256) {
        return usersAccounts[user];
    }
}
