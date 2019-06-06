pragma solidity ^0.5.9;

import "./DPlayStoreInterface.sol";
import "./DPlayCoinInterface.sol";
import "./Util/NetworkChecker.sol";
import "./Util/SafeMath.sol";

contract DPlayStore is DPlayStoreInterface, NetworkChecker {
	using SafeMath for uint;
	
	uint8 constant public RATING_DECIMALS = 18;
	
	Game[] public games;
	
	mapping(address => uint[]) private publisherToGameIds;
	mapping(uint => mapping(string => GameDetails)) private gameIdToLanguageToDetails;
	
	mapping(address => uint[]) private buyerToGameIds;
	mapping(uint => address[]) private gameIdToBuyers;
	
	mapping(uint => Rating[]) private gameIdToRatings;
	
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
	function create(uint price, string calldata defaultLanguage) external returns (uint) {
		
		// 게임의 가격은 최소 1DC 입니다.
		require(price >= 10 ** uint(dplayCoin.decimals()));
		
		uint createTime = now;
		
		uint gameId = games.push(Game({
			
			publisher : msg.sender,
			price : price,
			defaultLanguage : defaultLanguage,
			isPublished : false,
			
			createTime : createTime,
			lastUpdateTime : createTime
		})).sub(1);
		
		publisherToGameIds[msg.sender].push(gameId);
		
		return gameId;
	}
	
	// 게임의 가격을 변경합니다.
	function changePrice(uint gameId, uint price) external {
		
		Game storage game = games[gameId];
		
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		// 게임의 가격은 최소 1DC 입니다.
		require(price >= 10 ** uint(dplayCoin.decimals()));
		
		game.price = price;
	}
	
	// 게임의 기본 언어를 변경합니다.
	function changeDefaultLanguage(uint gameId, string calldata defaultLanguage) external {
		
		Game storage game = games[gameId];
		
		// 게임의 배포자인 경우에만
		require(game.publisher == msg.sender);
		
		game.defaultLanguage = defaultLanguage;
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
		
		Game memory game = games[gameId];
		
		// 생성된 게임 정보여야 합니다.
		require(game.publisher != address(0x0));
		
		// 이미 구매한 경우에는 재구매할 수 없습니다.
		require(checkIsBuyer(gameId) != true);
		
		// 보유 DC량이 게임 가격보다 높아야 합니다.
		require(dplayCoin.balanceOf(msg.sender) >= game.price);
		
		// 구매자로 등록합니다.
		buyerToGameIds[msg.sender].push(gameId);
		gameIdToBuyers[gameId].push(msg.sender);
		
		// DC를 전송합니다.
		dplayCoin.transferFrom(msg.sender, game.publisher, game.price);
	}
	
	// 구매자인지 확인합니다.
	function checkIsBuyer(uint gameId) public returns (bool) {
		
		uint[] memory gameIds = buyerToGameIds[msg.sender];
		for (uint i = 0; i < gameIds.length; i += 1) {
			if (gameIds[i] == gameId) {
				return true;
			}
		}
		
		return false;
	}
	
	// 게임을 평가합니다.
	function rate(uint gameId, uint rating, string calldata review) external {
		
		Game memory game = games[gameId];
		
		// 생성된 게임 정보여야 합니다.
		require(game.publisher != address(0x0));
		
		// 이미 평가한 경우에는 재평가할 수 없습니다.
		require(checkIsRater(gameId) != true);
		
		// 점수는 10점 이하여야 합니다.
		require(rating <= 10 * 10 ** uint(RATING_DECIMALS));
		
		// 평가를 등록합니다.
		gameIdToRatings[gameId].push(Rating({
			rater : msg.sender,
			rating : rating,
			review : review
		}));
	}
	
	// 평가자인지 확인합니다.
	function checkIsRater(uint gameId) public returns (bool) {
		
		Rating[] memory ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater == msg.sender) {
				return true;
			}
		}
		
		return false;
	}
	
	// 내가 내린 평가 정보를 반환합니다.
	function getMyRating(uint gameId) external returns (uint rating, string memory review) {
		
		Rating[] memory ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater == msg.sender) {
				return (
					ratings[i].rating,
					ratings[i].review
				);
			}
		}
	}
	
	// 평가를 수정합니다.
	function updateRating(uint gameId, uint rating, string calldata review) external {
		
		Rating[] storage ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater == msg.sender) {
				ratings[i].rating = rating;
				ratings[i].review = review;
			}
		}
	}
	
	// 평가를 삭제합니다.
	function removeRating(uint gameId) external {
		
		Rating[] storage ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater == msg.sender) {
				delete ratings[i];
				return;
			}
		}
	}
	
	// 게임의 종합 평가 점수를 반환합니다.
	// 종합 평가 점수 = (모든 평가의 합: 평가자 A의 DC Power * 평가자 A의 평가 점수) / 모든 평가자의 DC Power
	function getRating(uint gameId) public view returns (uint) {
		
		uint totalPower = 0;
		uint totalRating = 0;
		
		Rating[] memory ratings = gameIdToRatings[gameId];
		for (uint i = 0; i < ratings.length; i += 1) {
			if (ratings[i].rater != address(0x0)) {
				
				uint power = dplayCoin.getPower(ratings[i].rater);
				
				totalPower = totalPower.add(power);
				totalRating = totalRating.add(power.mul(ratings[i].rating));
			}
		}
		
		return totalPower == 0 ? 0 : totalRating.div(totalPower);
	}
	
	function checkAreSameString(string memory str1, string memory str2) internal pure returns (bool) {
		return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
	}
	
	function checkKeyword(uint gameId, string memory language, string memory keyword) internal view returns (bool) {
		
		Game memory game = games[gameId];
		
		GameDetails memory gameDetails = gameIdToLanguageToDetails[gameId][language];
		GameDetails memory defaultLanguageGameDetails = gameIdToLanguageToDetails[gameId][game.defaultLanguage];
		
		return
			checkAreSameString(gameDetails.keyword1, keyword) == true ||
			checkAreSameString(gameDetails.keyword2, keyword) == true ||
			checkAreSameString(gameDetails.keyword3, keyword) == true ||
			checkAreSameString(gameDetails.keyword4, keyword) == true ||
			checkAreSameString(gameDetails.keyword5, keyword) == true ||
			checkAreSameString(defaultLanguageGameDetails.keyword1, keyword) == true ||
			checkAreSameString(defaultLanguageGameDetails.keyword2, keyword) == true ||
			checkAreSameString(defaultLanguageGameDetails.keyword3, keyword) == true ||
			checkAreSameString(defaultLanguageGameDetails.keyword4, keyword) == true ||
			checkAreSameString(defaultLanguageGameDetails.keyword5, keyword) == true;
	}
	
	// 키워드에 해당하는 게임의 숫자를 가져옵니다.
	function getGameCountByKeyword(string calldata language, string calldata keyword) external view returns (uint) {
		
		uint gameCount = 0;
		
		for (uint i = 0; i < games.length; i += 1) {
			if (checkKeyword(i, language, keyword) == true) {
				gameCount += 1;
			}
		}
		
		return gameCount;
	}
	
	// 게임 ID들을 최신 순으로 가져옵니다.
	function getGameIdsNewest(uint count) external view returns (uint[] memory) {
		
		uint[] memory gameIds = new uint[](count);
		uint j = count;
		
		for (uint i = games.length - 1; i >= 0; i -= 1) {
			
			// 정상적인 게임 정보인지
			if (games[i].publisher != address(0x0)) {
				
				j -= 1;
				gameIds[j] = i;
				
				if (j == 0) {
					break;
				}
			}
		}
		
		return gameIds;
	}
	
	// 게임 ID들을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	function getGameIdsByRating(uint ratingCount, uint count) external view returns (uint[] memory) {
		
		uint[] memory gameIds = new uint[](count);
		
		for (uint i = 0; i < games.length; i += 1) {
			
			// 평가 수가 ratingCount 이상인 경우에만
			if (gameIdToRatings[i].length >= ratingCount) {
				
				uint rating = getRating(i);
				
				uint j = count - 1;
				for (; j >= 0; j -= 1) {
					if (getRating(gameIds[j]) <= rating) {
						gameIds[j] = gameIds[j - 1];
					} else {
						break;
					}
				}
				
				gameIds[j] = i;
			}
		}
		
		return gameIds;
	}
	
	// 키워드에 해당하는 게임 ID들을 최신 순으로 가져옵니다.
	function getGameIdsByKeywordNewest(string calldata language, string calldata keyword, uint count) external view returns (uint[] memory) {
		
		uint[] memory gameIds = new uint[](count);
		uint j = count;
		
		for (uint i = games.length - 1; i >= 0; i -= 1) {
			
			if (
			// 정상적인 게임 정보인지
			games[i].publisher != address(0x0) &&
			
			// 키워드에 해당하는지
			checkKeyword(i, language, keyword) == true) {
				
				j -= 1;
				gameIds[j] = i;
				
				if (j == 0) {
					break;
				}
			}
		}
		
		return gameIds;
	}
	
	// 키워드에 해당하는 게임 ID들을 높은 점수 순으로 가져오되, 평가 수로 필터링합니다.
	function getGameIdsByKeywordAndRating(string calldata language, string calldata keyword, uint ratingCount, uint count) external view returns (uint[] memory) {
		
		uint[] memory gameIds = new uint[](count);
		
		for (uint i = 0; i < games.length; i += 1) {
			
			if (
			// 평가 수가 ratingCount 이상인 경우에만
			gameIdToRatings[i].length >= ratingCount &&
			
			// 키워드에 해당하는지
			checkKeyword(i, language, keyword) == true) {
				
				uint rating = getRating(i);
				
				uint j = count - 1;
				for (; j >= 0; j -= 1) {
					if (getRating(gameIds[j]) <= rating) {
						gameIds[j] = gameIds[j - 1];
					} else {
						break;
					}
				}
				
				gameIds[j] = i;
			}
		}
		
		return gameIds;
	}
}