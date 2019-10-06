pragma solidity ^0.5.9;

interface DPlayStoreInterface {
	
	// Events
	// 이벤트
    event Transfer(address indexed from, address indexed to, uint indexed gameId);
    event ChangePrice(uint indexed gameId, uint price);
    event ChangeGameInfo(uint indexed gameId, string gameURL, bool isWebGame, string defaultLanguage);
    event Release(uint indexed gameId);
    event Unrelease(uint indexed gameId);
    event Buy(uint indexed gameId, address indexed buyer);
    
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
	function transfer(address to, uint gameId) external;
	
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
	function buy(uint gameId) external;
	
	// Checks if the given address is the buyer's address.
	// 특정 주소가 구매자인지 확인합니다.
	function checkIsBuyer(address addr, uint gameId) external view returns (bool);
	
	// Gets the IDs of the games bought by the given buyer.
	// 특정 구매자가 구매한 게임 ID들을 가져옵니다.
	function getBoughtGameIds(address buyer) external view returns (uint[] memory);
}
