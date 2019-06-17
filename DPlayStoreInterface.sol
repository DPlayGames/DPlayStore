pragma solidity ^0.5.9;

interface DPlayStoreInterface {
	
	// 이벤트
	// Events
    event ChangePrice(uint indexed gameId, uint price);
    event ChangeGameInfo(uint indexed gameId, string gameURL, bool isWebGame, string defaultLanguage);
    event Publish(uint indexed gameId);
    event Unpublish(uint indexed gameId);
    event Buy(uint indexed gameId, address indexed buyer);
    event Rate(uint indexed gameId, address indexed rater, uint rating, string review);
    event UpdateRating(uint indexed gameId, address indexed rater, uint rating, string review);
    event RemoveRating(uint indexed gameId, address indexed rater);
    
    // 게임 정보
    // Game info
	struct Game {
		address	publisher;
		bool	isPublished;
		uint	price;
		string	gameURL;
		bool	isWebGame;
		string	defaultLanguage;
		uint	createTime;
		uint	lastUpdateTime;
		uint	publishTime;
	}
	
	// 게임 세부 정보 (언어별로 필요합니다.)
	// Game Details (Needed for each language)
	struct GameDetails {
		string	title;
		string	summary;
		string	description;
		string	titleImageURL;
		string	bannerImageURL;
	}
	
	// 평가 정보
	// Rating info
	struct Rating {
		address	rater;
		uint	rating;
		string	review;
	}
	
	function ratingDecimals() external view returns (uint8);
	
	// 게임의 개수를 반환합니다.
	// Returns the number of games.
	function getGameCount() external view returns (uint);
	
	// 새 게임을 생성합니다.
	// Creates a new game.
	function newGame(uint price, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external returns (uint gameId);
	
	// 특정 주소가 배포자인지 확인합니다.
	// Checks if the given address is the publisher's address.
	function checkIsPublisher(address addr, uint gameId) external view returns (bool);
	
	// 게임의 정보를 반환합니다.
	// Returns the info of a game.
	function getGameInfo(uint gameId) external view returns (
		address publisher,
		bool isPublished,
		uint price,
		string memory gameURL,
		bool isWebGame,
		string memory defaultLanguage,
		uint createTime,
		uint lastUpdateTime
	);
	
	// 게임의 가격을 변경합니다.
	// Changes the price of a game.
	function changePrice(uint gameId, uint price) external;
	
	// 게임의 정보를 변경합니다.
	// Changes the info of a game.
	function changeGameInfo(uint gameId, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external;
	
	// 언어별로 게임의 세부 정보를 추가합니다.
	// Sets the detailed information of the game for each language.
	function setGameDetails(
		uint gameId,
		string calldata language,
		string calldata title,
		string calldata summary,
		string calldata description,
		string calldata titleImageURL,
		string calldata bannerImageURL) external;
	
	// 게임의 세부 정보를 반환합니다.
	// Returns the detailed information of the game.
	function getGameDetails(uint gameId, string calldata language) external view returns (
		string memory title,
		string memory summary,
		string memory description,
		string memory titleImageURL,
		string memory bannerImageURL
	);
	
	// 게임을 출시합니다.
	// Releases a game.
	function release(uint gameId) external;
	
	// 게임 출시를 취소합니다.
	// Unreleases a game.
	function unrelease(uint gameId) external;
	
	// 게임을 구매합니다.
	// Buys a game.
	function buy(uint gameId) external payable;
	
	// 특정 주소가 구매자인지 확인합니다.
	// Checks if the given address is the buyer's address.
	function checkIsBuyer(address addr, uint gameId) external view returns (bool);
	
	// 게임을 평가합니다.
	// Rates a game.
	function rate(uint gameId, uint rating, string calldata review) external;
	
	// 특정 주소가 평가자인지 확인합니다.
	// Checks if the given address is the rater's address.
	function checkIsRater(address addr, uint gameId) external view returns (bool);
	
	// 특정 평가자가 내린 평가 정보를 반환합니다.
	// Returns the rating info of the given rater.
	function getRating(address rater, uint gameId) external view returns (uint rating, string memory review);
	
	// 평가를 수정합니다.
	// Updates a rating.
	function updateRating(uint gameId, uint rating, string calldata review) external;
	
	// 평가를 삭제합니다.
	// Removes a rating.
	function removeRating(uint gameId) external;
	
	// 게임의 평가 수를 반환합니다.
	function getRatingCount(uint gameId) external view returns (uint);
	
	// 게임의 종합 평가 점수를 반환합니다.
	// 종합 평가 점수 = (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
	// Returns the overall rating of a game.
	// Overall rating = (The sum of all weighted ratings : Each rater's DC Power * Each rater's rating) / Sum of each rater's DC Power
	function getOverallRating(uint gameId) external view returns (uint);
}
