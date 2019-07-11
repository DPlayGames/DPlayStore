pragma solidity ^0.5.9;

interface DPlayStoreInterface {
	
	// Events
	// 이벤트
    event ChangePrice(uint indexed gameId, uint price);
    event ChangeGameInfo(uint indexed gameId, string gameURL, bool isWebGame, string defaultLanguage);
    event Release(uint indexed gameId);
    event Unrelease(uint indexed gameId);
    event Buy(uint indexed gameId, address indexed buyer);
    event Rate(uint indexed gameId, address indexed rater, uint rating, string review);
    event UpdateRating(uint indexed gameId, address indexed rater, uint rating, string review);
    event RemoveRating(uint indexed gameId, address indexed rater);
    
    // Game info
    // 게임 정보
	struct Game {
		address	publisher;
		bool	isReleased;
		uint	price;
		string	gameURL;
		bool	isWebGame;
		string	defaultLanguage;
		uint	createTime;
		uint	lastUpdateTime;
		uint	releaseTime;
	}
	
	// Game Details (Needed for each language.)
	// 게임 세부 정보 (언어별로 필요합니다.)
	struct GameDetails {
		string	title;
		string	summary;
		string	description;
		string	titleImageURL;
		string	bannerImageURL;
	}
	
	// Rating info
	// 평가 정보
	struct Rating {
		address	rater;
		uint	rating;
		string	review;
	}
	
	function ratingDecimals() external view returns (uint8);
	
	// Returns the number of games.
	// 게임의 개수를 반환합니다.
	function getGameCount() external view returns (uint);
	
	// Creates a new game.
	// 새 게임을 생성합니다.
	function newGame(uint price, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external returns (uint gameId);
	
	// Checks if the given address is the publisher's address.
	// 특정 주소가 배포자인지 확인합니다.
	function checkIsPublisher(address addr, uint gameId) external view returns (bool);
	
	// Gets the IDs of the games published by the given publisher.
	// 특정 배포자가 배포한 게임 ID들을 가져옵니다.
	function getPublishedGameIds(address publisher) external view returns (uint[] memory);
	
	// Transfers the game.
	// 게임을 이전합니다.
	function transferGame(address to, uint gameId) external;
	
	// Returns the info of a game.
	// 게임의 정보를 반환합니다.
	function getGameInfo(uint gameId) external view returns (
		address publisher,
		bool isReleased,
		uint price,
		string memory gameURL,
		bool isWebGame,
		string memory defaultLanguage,
		uint createTime,
		uint lastUpdateTime,
		uint releaseTime
	);
	
	// Changes the price of a game.
	// 게임의 가격을 변경합니다.
	function changePrice(uint gameId, uint price) external;
	
	// Changes the info of a game.
	// 게임의 정보를 변경합니다.
	function changeGameInfo(uint gameId, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external;
	
	// Sets the detailed information of the game for each language.
	// 언어별로 게임의 세부 정보를 추가합니다.
	function setGameDetails(
		uint gameId,
		string calldata language,
		string calldata title,
		string calldata summary,
		string calldata description,
		string calldata titleImageURL,
		string calldata bannerImageURL) external;
	
	// Returns the detailed information of the game.
	// 게임의 세부 정보를 반환합니다.
	function getGameDetails(uint gameId, string calldata language) external view returns (
		string memory title,
		string memory summary,
		string memory description,
		string memory titleImageURL,
		string memory bannerImageURL
	);
	
	// Releases a game.
	// 게임을 출시합니다.
	function release(uint gameId) external;
	
	// Unreleases a game.
	// 게임 출시를 취소합니다.
	function unrelease(uint gameId) external;
	
	// Buys a game.
	// 게임을 구매합니다.
	function buy(uint gameId) external payable;
	
	// Checks if the given address is the buyer's address.
	// 특정 주소가 구매자인지 확인합니다.
	function checkIsBuyer(address addr, uint gameId) external view returns (bool);
	
	// Gets the IDs of the games bought by the given buyer.
	// 특정 구매자가 구매한 게임 ID들을 가져옵니다.
	function getBoughtGameIds(address buyer) external view returns (uint[] memory);
	
	// Rates a game.
	// 게임을 평가합니다.
	function rate(uint gameId, uint rating, string calldata review) external;
	
	// Checks if the given address is the rater's address.
	// 특정 주소가 평가자인지 확인합니다.
	function checkIsRater(address addr, uint gameId) external view returns (bool);
	
	// Gets the game IDs rated by the given rater.
	// 특정 평가자가 평가한 게임 ID들을 가져옵니다.
	function getRatedGameIds(address rater) external view returns (uint[] memory);
	
	// Returns the rating info of the given rater.
	// 특정 평가자가 내린 평가 정보를 반환합니다.
	function getRating(address rater, uint gameId) external view returns (uint rating, string memory review);
	
	// Updates a rating.
	// 평가를 수정합니다.
	function updateRating(uint gameId, uint rating, string calldata review) external;
	
	// Returns the number of ratings of a game.
	// 게임의 평가 수를 반환합니다.
	function getRatingCount(uint gameId) external view returns (uint);
	
	// Returns the overall rating of a game.
	// Overall rating = (The sum of all weighted ratings : Each rater's DC Power * Each rater's rating) / Sum of each rater's DC Power
	// 게임의 종합 평가 점수를 반환합니다.
	// 종합 평가 점수 = (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
	function getOverallRating(uint gameId) external view returns (uint);
}
