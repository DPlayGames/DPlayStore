pragma solidity ^0.5.9;

import "./DPlayStoreInterface.sol";
import "./DPlayCoinInterface.sol";
import "./Util/NetworkChecker.sol";
import "./Util/SafeMath.sol";

contract DPlayStore is DPlayStoreInterface, NetworkChecker {
	using SafeMath for uint;
	
	Game[] public games;
	
	mapping(address => uint[]) private publisherToGameIds;
	mapping(uint => string[]) private gameIdToLanguages;
	mapping(uint => mapping(string => GameDetails)) private gameIdToLanguageToDetails;
	
	DPlayCoinInterface private dplayCoin;
	
	constructor() NetworkChecker() public {
		if (network == Network.Mainnet) {
			//TODO: dplayCoin = DPlayCoinInterface(0x49f1CaA1E50275CdF84eA4896b584f748153Eee2);
		} else if (network == Network.Kovan) {
			dplayCoin = DPlayCoinInterface(0x8079bA69E89237a4B739fF57337109fDAbD8CCa0);
		} else if (network == Network.Ropsten) {
			//TODO: dplayCoin = DPlayCoinInterface(0x8d536d404Ee307Dd6FF8599F1Af1ff76AfCde69d);
		} else if (network == Network.Rinkeby) {
			//TODO: dplayCoin = DPlayCoinInterface(0x32A7A93353C2CF233Ad2899A5ca081ac7492e602);
		} else {
			revert();
		}
	}
	
	// 새 게임을 생성합니다.
	function create(uint price) external returns (uint) {
		
		// 게임의 가격은 최소 1DC 입니다.
		require(price >= 10 ** uint(dplayCoin.decimals()));
		
		uint createTime = now;
		
		uint gameId = games.push(Game({
			
			publisher : msg.sender,
			price : price,
			isPublished : false,
			
			createTime : createTime,
			lastUpdateTime : createTime
		})).sub(1);
		
		publisherToGameIds[msg.sender].push(gameId);
		
		return gameId;
	}
	
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
		string calldata keyword5) external {
		
		Game storage game = games[gameId];
		
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		gameIdToLanguageToDetails[gameId][language] = GameDetails({
			
			title : title,
			summary : summary,
			downloadURL : downloadURL,
			
			description : description,
			titleImageURL : titleImageURL,
			bannerImageURL : bannerImageURL,
			
			keyword1 : keyword1,
			keyword2 : keyword2,
			keyword3 : keyword3,
			keyword4 : keyword4,
			keyword5 : keyword5
		});
		
		game.lastUpdateTime = now;
	}
	
	// 게임 정보를 반환합니다.
	function getGameInfo(uint gameId, string calldata language) external view returns (
		
		address publisher,
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
	) {
		Game memory game = games[gameId];
		GameDetails memory gameDetails = gameIdToLanguageToDetails[gameId][language];
		
		return (
			game.publisher,
			game.price,
			game.isPublished,
			
			gameDetails.title,
			gameDetails.summary,
			gameDetails.downloadURL,
			
			gameDetails.description,
			gameDetails.titleImageURL,
			gameDetails.bannerImageURL,
			
			gameDetails.keyword1,
			gameDetails.keyword2,
			gameDetails.keyword3,
			gameDetails.keyword4,
			gameDetails.keyword5
		);
	}
	
	// 게임을 출시합니다.
	function publish(uint gameId) external {
		
		Game storage game = games[gameId];
		
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.isPublished = true;
		
		emit Publish(gameId);
	}
	
	// 게임 출시를 취소합니다.
	function unpublish(uint gameId) external {
		
		Game storage game = games[gameId];
		
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.isPublished = false;
		
		emit Unpublish(gameId);
	}
	
	// 게임을 구매합니다.
	function buy(uint gameId) external payable {
		
	}
	
	/*// 게임을 평가합니다.
	function rate(uint gameId, uint rating) external {
		
	}*/
}