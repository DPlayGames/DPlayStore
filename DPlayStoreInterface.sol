pragma solidity ^0.5.9;

interface DPlayStoreInterface {
	
	// 게임 정보
	struct Game {
		string title;
		string summary;
		uint price;
		string description;
		string titleImageURL;
		string bannerImageURL;
		
		// 키워드는 최대 5개까지 입력 가능합니다.
		string keyword1;
		string keyword2;
		string keyword3;
		string keyword4;
		string keyword5;
	}
	
	// 게임을 출시합니다.
	function publish(
		string calldata title,
		string calldata summary,
		uint price,
		string calldata description,
		string calldata titleImageURL,
		string calldata bannerImageURL,
		
		string calldata keyword1,
		string calldata keyword2,
		string calldata keyword3,
		string calldata keyword4,
		string calldata keyword5) external returns (uint gameId);
	
	// 게임 정보를 반환합니다.
	function getGameInfo(uint gameId) external view returns (
		string memory title,
		string memory summary,
		uint price,
		string memory description,
		string memory titleImageURL,
		string memory bannerImageURL,
		
		string memory keyword1,
		string memory keyword2,
		string memory keyword3,
		string memory keyword4,
		string memory keyword5
	);
	
	// 게임을 구매합니다.
	function buy(uint gameId) external payable;
	
	// 게임을 평가합니다.
	function rate(uint gameId, uint rating) external;
	
	// 키워드에 해당하는 게임의 숫자를 가져옵니다.
	function getGameCountByKeyword(string calldata keyword) external view returns (uint);
	
	// 게임 목록을 최신 순으로 가져옵니다.
	function getGameListNewest(uint count) external view returns (uint[] memory);
	
	// 게임 목록을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	function getGameListByRating(uint ratingCount, uint count) external view returns (uint[] memory);
	
	// 키워드에 해당하는 게임 목록을 최신 순으로 가져옵니다.
	function getGameListNewestByKeyword(uint keyword, uint count) external view returns (uint[] memory);
	
	// 키워드에 해당하는 게임 목록을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	// (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
	function getGameListByRatingAndKeyword(uint ratingCount, uint keyword, uint count) external view returns (uint[] memory);
}