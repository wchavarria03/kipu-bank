# KipuBank - Smart Contract Banking System

## 📖 Contract General Description

KipuBank is a decentralized banking system implemented in Solidity that allows users to deposit and withdraw Ether (ETH) securely. The contract acts as a digital bank with transaction limits and maximum capacity to ensure system security and stability.

### Main Functionalities

- **💰 ETH Deposits**: Users can deposit Ether into their personal accounts
- **💸 ETH Withdrawals**: Ability to withdraw funds to any valid address
- **🔒 Transaction Limits**: Maximum of 2 ETH per transaction for enhanced security
- **🏦 Bank Capacity**: Maximum limit of 100 ETH in the bank
- **📊 Balance Tracking**: Query individual and bank balances
- **📝 Events**: Emission of events for deposits and withdrawals for easy tracking
- **⚡ Automatic Reception**: Support for receiving ETH through direct transfers

### Security Features

- Amount validation (0 ETH transactions not allowed)
- Overflow/underflow protection
- Sufficient balance verification before withdrawals
- Transaction limit and total capacity control
- Custom error handling with descriptive messages

## 🚀 Deployment Instructions

### Prerequisites

- A wallet with ETH for deployment gas (e.g., MetaMask)
- Access to an Ethereum network (Mainnet, testnet, or local network)

### Deploy with Remix IDE

1. **Open Remix**: Go to [https://remix.ethereum.org](https://remix.ethereum.org)
2. **Create file**: Create a new file called `KipuBank.sol`
3. **Copy code**: Copy the content from `contracts/kipuBank.sol`
4. **Compile**: 
   - Go to the "Solidity Compiler" tab
   - Select version 0.8.19 or higher
   - Click "Compile KipuBank.sol"
5. **Deploy**:
   - Go to the "Deploy & Run Transactions" tab
   - Select your environment (Injected Web3 for MetaMask)
   - Click "Deploy"
   - Confirm the transaction in your wallet

### Recommended Networks for Testing
- **Sepolia Testnet**: `https://sepolia.infura.io/v3/YOUR_PROJECT_ID`

## 🤝 How to Interact with the Contract

Once deployed, you can interact with the KipuBank contract using Remix IDE's user-friendly interface:

### Using Remix IDE

1. **Access Contract**: After deployment, your contract will appear in the "Deployed Contracts" section
2. **Connect Wallet**: Ensure MetaMask or your preferred wallet is connected to Remix

### Main Interactions

#### 💰 Deposit ETH
- **Method 1**: Use the `deposit` function button
  - Enter the ETH amount in the "Value" field (e.g., 1 for 1 ETH)
  - Click the red `deposit` button
  - Confirm the transaction in your wallet

- **Method 2**: Send ETH directly to the contract address
  - The contract will automatically process the deposit via the `receive()` function

#### 💸 Withdraw ETH
- Use the `withdraw` function
- Enter the recipient address and amount (in Wei)
- Click the button and confirm the transaction
- Note: You cannot send ETH with withdrawal transactions

#### 📊 Check Balances
- **Your Balance**: Click the blue `myBalance` button to see your account balance
- **Bank Balance**: Click `bankBalance` to see total ETH in the contract
- **Any User's Balance**: Use `balanceOf` with a specific address

#### 📈 View Statistics
- **Total Deposits**: Check `depositsCount` for number of successful deposits
- **Total Withdrawals**: Check `withdrawalsCount` for number of successful withdrawals

### Important Limits
- **Transaction Limit**: Maximum 2 ETH per transaction
- **Bank Capacity**: Maximum 100 ETH total in the contract
- **Minimum Amount**: Must be greater than 0 ETH

### Monitoring Activity
- Check the Remix console for transaction receipts and events
- Events `EtherStored` and `EtherSent` are emitted for deposits and withdrawals respectively

## 📋 Contract Information

- **Solidity Version**: ^0.8.19
- **License**: MIT
- **Transaction Limit**: 2 ETH
- **Maximum Capacity**: 100 ETH

## 📝 License

This project is under the MIT License - see the [LICENSE](LICENSE) file for more details. 