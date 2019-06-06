pragma solidity ^0.5.9;

interface DPlayStoreInterface {
	
	// 이벤트들
    event ChangePrice(uint indexed gameId, uint price);
    event Publish(uint indexed gameId);
    event Unpublish(uint indexed gameId);
    event Buy(uint indexed gameId);
    event Rate(uint indexed gameId, address rater, uint rating);
	
	// 게임 정보
	struct Game {
		
		address owner;
		uint price;
		bool isPublished;
		
		uint createTime;
		uint lastUpdateTime;
	}
	
	// 게임 세부 정보 (언어별로 필요합니다.)
	struct GameDetails {
		
		string title;
		string summary;
		string downloadURL;
		
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
	
	// 새 게임을 생성합니다.
	function create(uint price) external returns (uint gameId);
	
	// 게임의 가격을 변경합니다.
	function changePrice(uint gameId, uint price) external;
	
	// 언어별로 게임 세부 정보를 입력합니다.
	function setDetails(
		uint gameId,
		string calldata language,
		
		string calldata title,
		string calldata summary,
		string calldata downloadURL,
		
		string calldata description,
		string calldata titleImageURL,
		string calldata bannerImageURL,
		
		string calldata keyword1,
		string calldata keyword2,
		string calldata keyword3,
		string calldata keyword4,
		string calldata keyword5) external;
	
	// 게임 정보를 반환합니다.
	function getGameInfo(uint gameId, string calldata language) external view returns (
		
		uint price,
		bool isPublished,
		
		string memory title,
		string memory summary,
		string memory downloadURL,
		
		string memory description,
		string memory titleImageURL,
		string memory bannerImageURL,
		
		string memory keyword1,
		string memory keyword2,
		string memory keyword3,
		string memory keyword4,
		string memory keyword5
	);
	
	// 게임을 출시합니다.
	function publish(uint gameId) external;
	
	// 게임 출시를 취소합니다.
	function unpublish(uint gameId) external;
	
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