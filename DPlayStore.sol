pragma solidity ^0.5.9;

import "./DPlayStoreInterface.sol";
import "./DPlayCoinInterface.sol";
import "./Util/NetworkChecker.sol";
import "./Util/SafeMath.sol";

contract DPlayStore is DPlayStoreInterface, NetworkChecker {
	using SafeMath for uint;
	
	Game[] private games;
	
	mapping(address => uint[]) private publisherToGameIds;
	mapping(uint => mapping(string => GameDetails)) private gameIdToLanguageToDetails;
	
	mapping(address => uint[]) private buyerToGameIds;
	mapping(uint => address[]) private gameIdToBuyers;
	
	DPlayCoinInterface private dplayCoin;
	
	constructor() NetworkChecker() public {
		
		// Loads the DPlay Coin smart contract.
		// DPlay Coin 스마트 계약을 불러옵니다.
		if (network == Network.Mainnet) {
			//TODO
		} else if (network == Network.Kovan) {
			dplayCoin = DPlayCoinInterface(0xfFF1528013478fc286ABBBE8071D5404b082Be5D);
		} else if (network == Network.Ropsten) {
			//TODO
		} else if (network == Network.Rinkeby) {
			//TODO
		} else {
			revert();
		}
	}
	
	// Returns the number of games.
	// 게임의 개수를 반환합니다.
	function getGameCount() external view returns (uint) {
		return games.length;
	}
	
	// Creates a new game
	// 새 게임을 생성합니다.
	function newGame(uint price, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external returns (uint) {
		
		// The price of game must be free, 1DC or more.
		// 게임의 가격은 무료이거나 1DC 이상이여야 합니다.
		require(price == 0 || price >= 10 ** uint(dplayCoin.decimals()));
		
		uint createTime = now;
		
		uint gameId = games.push(Game({
			publisher		: msg.sender,
			isReleased		: false,
			price			: price,
			gameURL			: gameURL,
			isWebGame		: isWebGame,
			defaultLanguage	: defaultLanguage,
			createTime		: createTime,
			lastUpdateTime	: createTime,
			releaseTime		: 0
		})).sub(1);
		
		publisherToGameIds[msg.sender].push(gameId);
		
		return gameId;
	}
	
	// Checks if the given address is the publisher.
	// 특정 주소가 배포자인지 확인합니다.
	function checkIsPublisher(address addr, uint gameId) external view returns (bool) {
		return games[gameId].publisher == addr;
	}
	
	// Gets the IDs of the game published by the given publisher.
	// 특정 배포자가 배포한 게임 ID들을 가져옵니다.
	function getPublishedGameIds(address publisher) external view returns (uint[] memory) {
		return publisherToGameIds[publisher];
	}
	
	// Transfers the game.
	// 게임을 이전합니다.
	function transfer(address to, uint gameId) external {
		
		Game storage game = games[gameId];
		
		// Only the publisher can transfer the game.
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		// Removes the Game ID from the old publisher's list of game IDs.
		// 기존 배포자의 게임 ID 목록에서 게임 ID를 제거합니다.
		for (uint i = 0; i < publisherToGameIds[msg.sender].length - 1; i += 1) {
			if (publisherToGameIds[msg.sender][i] == gameId) {
				
				for (; i < publisherToGameIds[msg.sender].length - 1; i += 1) {
					publisherToGameIds[msg.sender][i] = publisherToGameIds[msg.sender][i + 1];
				}
				
				break;
			}
		}
		publisherToGameIds[msg.sender].length -= 1;
		
		// Registers the new publisher.
		// 새 배포자를 등록합니다.
		game.publisher = to;
		publisherToGameIds[to].push(gameId);
		
		emit Transfer(msg.sender, to, gameId);
	}
	
	// Returns the info of the game.
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
	) {
		
		Game memory game = games[gameId];
		
		return (
			game.publisher,
			game.isReleased,
			game.price,
			game.gameURL,
			game.isWebGame,
			game.defaultLanguage,
			game.createTime,
			game.lastUpdateTime,
			game.releaseTime
		);
	}
	
	// Changes the price of the game.
	// 게임의 가격을 변경합니다.
	function changePrice(uint gameId, uint price) external {
		
		Game storage game = games[gameId];
		
		// The prices of free games cannot be changed.
		// 무료 게임은 가격을 변경할 수 없습니다.
		require(game.price > 0);
		
		// Only the publisher of the game can change its price.
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		// The price must be at least 1DC.
		// 게임의 가격은 1DC 이상이여야 합니다.
		require(price >= 10 ** uint(dplayCoin.decimals()));
		
		game.price = price;
		
		emit ChangePrice(gameId, price);
	}
	
	// Changes the info of the game.
	// 게임의 정보를 변경합니다.
	function changeGameInfo(uint gameId, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external {
		
		Game storage game = games[gameId];
		
		// The sender must be the publisher.
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.gameURL = gameURL;
		game.isWebGame = isWebGame;
		game.defaultLanguage = defaultLanguage;
		
		emit ChangeGameInfo(gameId, gameURL, isWebGame, defaultLanguage);
	}
	
	// Sets the detailed information of the game for each language.
	// 언어별로 게임의 세부 정보를 입력합니다.
	function setGameDetails(
		uint gameId,
		string calldata language,
		string calldata title,
		string calldata summary,
		string calldata description,
		string calldata titleImageURL,
		string calldata bannerImageURL) external {
		
		// The sender must be the publisher.
		// 게임의 배포자인 경우에만
		require(games[gameId].publisher == msg.sender);
		
		gameIdToLanguageToDetails[gameId][language] = GameDetails({
			title : title,
			summary : summary,
			description : description,
			titleImageURL : titleImageURL,
			bannerImageURL : bannerImageURL
		});
		
		games[gameId].lastUpdateTime = now;
	}
	
	// Returns the detailed information of the game.
	// 게임의 세부 정보를 반환합니다.
	function getGameDetails(uint gameId, string calldata language) external view returns (
		string memory title,
		string memory summary,
		string memory description,
		string memory titleImageURL,
		string memory bannerImageURL
	) {
		
		GameDetails memory gameDetails = gameIdToLanguageToDetails[gameId][language];
		
		return (
			gameDetails.title,
			gameDetails.summary,
			gameDetails.description,
			gameDetails.titleImageURL,
			gameDetails.bannerImageURL
		);
	}
	
	// Releases a game.
	// 게임을 출시합니다.
	function release(uint gameId) external {
		
		Game storage game = games[gameId];
		
		// The sender must be the publisher.
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.isReleased = true;
		
		// Saves the released time if the game was released for the first time.
		// 최초 출시인 경우에만 출시 시간 저장
		if (game.releaseTime == 0) {
			game.releaseTime = now;
		}
		
		emit Release(gameId);
	}
	
	// Unreleases a game.
	// 게임 출시를 취소합니다.
	function unrelease(uint gameId) external {
		
		Game storage game = games[gameId];
		
		// The sender must be the publisher.
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.isReleased = false;
		
		emit Unrelease(gameId);
	}
	
	// Buys the game.
	// 게임을 구매합니다.
	function buy(uint gameId) external {
		
		Game memory game = games[gameId];
		
		// The game information must be normal.
		// 정상적인 게임 정보여야 합니다.
		require(game.publisher != address(0x0));
		
		// Cannot buy a free game.
		// 무료 게임은 구매할 수 없습니다.
		require(game.price > 0);
		
		// Cannot rebuy if the game was already bought.
		// 이미 구매한 경우에는 재구매할 수 없습니다.
		require(checkIsBuyer(msg.sender, gameId) != true);
		
		// The balance must be higher than the price of the game.
		// 보유 DC량이 게임 가격보다 높아야 합니다.
		require(dplayCoin.balanceOf(msg.sender) >= game.price);
		
		// Registers the sender as a buyer.
		// 구매자로 등록합니다.
		buyerToGameIds[msg.sender].push(gameId);
		gameIdToBuyers[gameId].push(msg.sender);
		
		// Transmits the payment.
		// DC를 전송합니다.
		dplayCoin.transferFrom(msg.sender, game.publisher, game.price);
		
		emit Buy(gameId, msg.sender);
	}
	
	// Checks if the given address is the buyer's address.
	// 특정 주소가 구매자의 주소인지 확인합니다.
	function checkIsBuyer(address addr, uint gameId) public view returns (bool) {
		
		uint[] memory gameIds = buyerToGameIds[addr];
		for (uint i = 0; i < gameIds.length; i += 1) {
			if (gameIds[i] == gameId) {
				return true;
			}
		}
		
		return false;
	}
	
	// Gets the IDs of the game bought by the given buyer.
	// 특정 구매자가 구매한 게임 ID들을 가져옵니다.
	function getBoughtGameIds(address buyer) external view returns (uint[] memory) {
		return buyerToGameIds[buyer];
	}
}
