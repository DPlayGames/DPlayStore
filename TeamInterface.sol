pragma solidity ^0.5.1;

interface TeamInterface {
	
    event DistributeDC(uint indexed teamId, uint amount);
    
    // DC를 팀에 분배합니다.
	function distributeDC(uint teamId, uint amount) external;
}