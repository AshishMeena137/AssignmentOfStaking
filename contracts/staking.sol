
// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// staking contract address 0x59D0D7eea25814a1291108af01F71B54eC554ac8

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract{
    using SafeMath for uint256;

    ERC20 public token;
    uint256 public rewardRate;  // Reward rate per second
    uint256 public totalStaked;
    address public owner;
    uint public reword;
    
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }
    
    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewards;
    
    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    constructor(uint256 _rewardRate, address _tokenAddress) {
        owner = msg.sender;
        token = ERC20(_tokenAddress);
        rewardRate = _rewardRate;
    }
    
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(stakes[msg.sender].active == false, "You already have an active stake");
        
        token.transferFrom(msg.sender, address(this), _amount);
        
        stakes[msg.sender] = Stake({
            amount: _amount,
            startTime: block.timestamp,
            endTime: 0,
            active: true
        });
        
        totalStaked = totalStaked.add(_amount);
        
        emit Staked(msg.sender, _amount);
    }
    
function unstake() external payable  {
    require(stakes[msg.sender].active == true, "No active stake found");
    calculateReward(msg.sender);
    uint256 amount = stakes[msg.sender].amount;
    uint256 reward = reword;
    
    stakes[msg.sender].active = false;
    stakes[msg.sender].endTime = block.timestamp;  // Set the endTime to the current block timestamp
    
    token.transfer(msg.sender, amount.add(reward));
    
    totalStaked = totalStaked.sub(amount);
    rewards[msg.sender] = rewards[msg.sender].add(reward);
    
    emit Unstaked(msg.sender, amount, reward);
    reword = 0;
}
    
    function calculateReward(address _staker) public returns (uint256) {
        Stake memory take = stakes[_staker];
        
        if (take.endTime <= take.startTime) {
            return 0;
        }
        
        uint256 duration = take.endTime.sub(take.startTime);
        reword = take.amount.mul(duration).mul(rewardRate);
        
        return reword;
    }
    
    function updateRewardRate(uint256 _newRate) external onlyOwner{
        rewardRate = _newRate;
    }
    
    function getStakedAmount(address _staker) external view returns (uint256) {
        return stakes[_staker].amount;
    }
    
    function getStakeDuration(address _staker) external view returns (uint256) {
        if (stakes[_staker].active) {
            return block.timestamp.sub(stakes[_staker].startTime);
        }
        
        return stakes[_staker].endTime.sub(stakes[_staker].startTime);
    }
    
    function getRewardAmount(address _staker) external returns (uint256) {
    return calculateReward(_staker);
    }
}