# DPlay Store
DPlay 게임 판매 스토어

## 계약 주소
- Kovan: 0x0191f2EFAcA986Ec5dc136987E0dAC05Bc804A0C

## 테스트 여부
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event ChangePrice(uint indexed gameId, uint price)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event ChangeGameInfo(uint indexed gameId, string gameURL, bool isWebGame, string defaultLanguage)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Release(uint indexed gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Unrelease(uint indexed gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Buy(uint indexed gameId, address indexed buyer)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Rate(uint indexed gameId, address indexed rater, uint rating, string review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event UpdateRating(uint indexed gameId, address indexed rater, uint rating, string review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event RemoveRating(uint indexed gameId, address indexed rater)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function ratingDecimals() external view returns (uint8)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getGameCount() external view returns (uint)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function newGame(uint price, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external returns (uint gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function checkIsPublisher(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getPublishedGameIds(address publisher) external view returns (uint[] memory)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getGameInfo(uint gameId) external view returns (address publisher, bool isReleased, uint price, string memory gameURL,`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `bool isWebGame, string memory defaultLanguage, uint createTime, uint lastUpdateTime)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function changePrice(uint gameId, uint price) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function changeGameInfo(uint gameId, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function setGameDetails(uint gameId, string calldata language, string calldata title, string calldata summary, string calldata description, string calldata titleImageURL, string calldata bannerImageURL) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getGameDetails(uint gameId, string calldata language) external view returns (string memory title, string memory summary, string memory description, string memory titleImageURL, string memory bannerImageURL)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function release(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function unrelease(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function buy(uint gameId) external payable`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function checkIsBuyer(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getBoughtGameIds(address buyer) external view returns (uint[] memory)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function rate(uint gameId, uint rating, string calldata review) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function checkIsRater(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getRating(address rater, uint gameId) external view returns (uint rating, string memory review)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function updateRating(uint gameId, uint rating, string calldata review) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function removeRating(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getRatingCount(uint gameId) external view returns (uint)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `function getOverallRating(uint gameId) external view returns (uint)`