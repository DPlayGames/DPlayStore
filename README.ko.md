# DPlay Store
DPlay 게임 판매 스토어

## 계약 주소
- Mainnet: 0x6AbD63da2f98dD181B30eedd0377e74DF503e55B
- Kovan: 0x8C2E9938DBd456ac12329fC9cC566bCF0D6269B8
- Ropsten: 0x81Eba90B7765fda1AF6aEA03db2491cff4a243Cf
- Rinkeby: 0x01DA6dAdCE4662ecB32A544D8dD6f2796Ae986a6

## 테스트 여부
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-no-red.svg) `event Transfer(address indexed from, address indexed to, uint indexed gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `event ChangePrice(uint indexed gameId, uint price)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `event ChangeGameInfo(uint indexed gameId, string gameURL, bool isWebGame, string defaultLanguage)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `event Release(uint indexed gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `event Unrelease(uint indexed gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `event Buy(uint indexed gameId, address indexed buyer)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getGameCount() external view returns (uint)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function newGame(uint price, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external returns (uint gameId)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function checkIsPublisher(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getPublishedGameIds(address publisher) external view returns (uint[] memory)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function transfer(address to, uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getGameInfo(uint gameId) external view returns (address publisher, bool isReleased, uint price, string memory gameURL, bool isWebGame, string memory defaultLanguage, uint createTime, uint lastUpdateTime, uint releaseTime)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function changePrice(uint gameId, uint price) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function changeGameInfo(uint gameId, string calldata gameURL, bool isWebGame, string calldata defaultLanguage) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function setGameDetails(uint gameId, string calldata language, string calldata title, string calldata summary, string calldata description, string calldata titleImageURL, string calldata bannerImageURL) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getGameDetails(uint gameId, string calldata language) external view returns (string memory title, string memory summary, string memory description, string memory titleImageURL, string memory bannerImageURL)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function release(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function unrelease(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function buy(uint gameId) external`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function checkIsBuyer(address addr, uint gameId) external view returns (bool)`
- ![테스트 여부](https://img.shields.io/badge/테스트%20여부-yes-brightgreen.svg) `function getBoughtGameIds(address buyer) external view returns (uint[] memory)`

## 라이센스
[MIT](LICENSE)