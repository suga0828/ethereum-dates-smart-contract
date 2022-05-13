//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract ETHDates is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1100 1100' preserveAspectRatio='xMinYMin meet'><g><g fill='";
    string private complementSvg = "'><path d='M 549.95 411.6 L 223.85 559.9 L 549.95 752.5 L 875.85 559.9 L 549.95 411.6 Z' fill-opacity='0.6' /><path d='M 223.85 559.9 L 549.95 752.5 L 549.95 18.9 L 223.85 559.9 Z' fill-opacity='0.45' /><path d='M 549.95 18.9 L 549.95 752.6 L 875.85 559.9 L 549.95 18.9 Z' fill-opacity='0.8' /><path d='M 223.85 621.7 L 549.95 1081.1 L 549.95 814.4 L 223.85 621.7 Z' fill-opacity='0.45' /><path d='M 549.95 814.4 L 549.95 1081.1 L 876.15 621.7 L 549.95 814.4 Z' fill-opacity='0.8' /></g><text style='font-family: sans-serif; font-size: 10em; stroke: #6a6a6a50; stroke-width: 0.06em; word-spacing: .1em;' fill='";

    string private midComplement = "' x='50%' y='70%' dominant-baseline='middle' text-anchor='middle'>";
    string private endSvg = "</text></g></svg>";

    string[] private numberDays = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];
    string[] private months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    string[] private numberYears = ["70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69"];

    mapping(string => string) private backgroundColors;
    mapping(string => string) private textColors;

    constructor() ERC721 ("ETHDates", "DDMMMYY") {
        backgroundColors["black"] = "#121212";
        textColors["black"] = "#121212";
        
        backgroundColors["purple-gray"] = "#454a76";
        textColors["purple-gray"] = "#454a76";

        backgroundColors["blue-grey"] = "#2c4563";
        textColors["blue-grey"] = "#3a4d66";

        backgroundColors["gray"] = "#747474";
        textColors["gray"] = "#606060";

        backgroundColors["green"] = "#1f8322";
        textColors["green"] = "#2e8f47";

        backgroundColors["yellow"] = "#b07807";
        textColors["yellow"] = "#896417";

        backgroundColors["red"] = "#ab250d";
        textColors["red"] = "#9b311d";

        backgroundColors["skyblue"] = "#087396";
        textColors["skyblue"] = "#166b87";

        backgroundColors["purple"] = "#9f097f";
        textColors["purple"] = "#891870";
    }

    function pickRandomColors(uint256 tokenId) internal view returns (string memory backgroundColor, string memory textColor) {
        uint256 rand = random(string(abi.encodePacked(block.number, block.timestamp, msg.sender, Strings.toString(tokenId))));
        rand = rand % 100;

        // 1% 
        if (rand <= 1) {
            return (backgroundColors["blue"], textColors["blue"]);
        }

        // 5% 
        if (rand <= 6) {
            return (backgroundColors["grey"], textColors["grey"]);
        }

        // 9%
        if (rand <= 15) {
            return (backgroundColors["darkblue"], textColors["darkblue"]);
        }
        if (rand <= 24) {
            return (backgroundColors["green"], textColors["green"]);
        }

        // 12% 
        if (rand <= 36) {
            return (backgroundColors["yellow"], textColors["yellow"]);
        }
        if (rand <= 48) {
            return (backgroundColors["orange"], textColors["orange"]);
        }
        if (rand <= 60) {
            return (backgroundColors["red"], textColors["red"]);
        }
        if (rand <= 72) {
            return (backgroundColors["purple"], textColors["purple"]);
        }

        // 28%
        return (backgroundColors["black"], textColors["black"]);
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT(string memory _day, string memory _month, string memory _year) public {
        require(true, "ERC721URIStorage: URI query for nonexistent token");

        uint256 newItemId = _tokenIds.current();

        string memory date = string(abi.encodePacked(_day, " ", _month, " ", _year));
        (string memory backgroundColor, string memory textColor) = pickRandomColors(newItemId);

        string memory finalSvg = string(abi.encodePacked(baseSvg, backgroundColor, complementSvg, textColor, midComplement, date, endSvg));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        date,
                        '", "description": "An Ethereum logo to remember those important dates forever.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "attributes": [{"trait_type": "Background", "value": "',
                        backgroundColor,
                        '"}]}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json));

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        console.log(finalTokenUri);

        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }

    function totalSupply() public view virtual returns (uint256) {
      return _tokenIds.current();
  }
}
