pragma solidity ^0.5.9;

interface DPlayCoinInterface {
	
	event Transfer(address indexed from, address indexed to, uint value);
	event Approval(address indexed owner, address indexed spender, uint value);
	
	function name() external view returns (string memory);
	function symbol() external view returns (string memory);
	function decimals() external view returns (uint8);
	
	function totalSupply() external view returns (uint);
	function balanceOf(address owner) external view returns (uint balance);
	function transfer(address to, uint value) external returns (bool success);
	function transferFrom(address from, address to, uint value) external returns (bool success);
	function approve(address spender, uint value) external returns (bool success);
	function allowance(address owner, address spender) external view returns (uint remaining);
	
	// Returns the DC power.
	// DC 파워를 반환합니다.
	function getPower(address user) external view returns (uint power);
}