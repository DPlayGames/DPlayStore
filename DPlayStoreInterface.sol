pragma solidity ^0.5.1;

interface DPlayStoreInterface {
	
	// 게임 정보
	struct Game {
		string title;
		string description;
		string[] keywords;
	}
	
	// 게임을 출시합니다.
	// publish
	
	// 게임을 구매합니다.
	// buy
	
	// 게임을 평가합니다.
	
	// 키워드와 키워드에 해당하는 게임의 숫자를 가져옵니다.
	
	// 게임 목록을 최신 순으로 가져옵니다.
	
	// 게임 목록을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	
	// 키워드에 해당하는 게임 목록을 최신 순으로 가져옵니다.
	
	// 키워드에 해당하는 게임 목록을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	// (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
}