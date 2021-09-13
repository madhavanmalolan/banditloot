// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";



interface Loot { 
    function ownerOf(uint tokenId) external returns(address);
}


contract BanditLootGold is ERC20 {
    address owner;
    Loot loot = Loot(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
    Loot mloot = Loot(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);
    constructor(address creator) ERC20("BanditLootGold","BGLD"){
        owner = msg.sender;
        _mint(creator, 1000 * 1e18);
    }
    
    mapping(uint => bool) isAirdropClaimed;
    function claimAirdrop(uint lootNumber) public {
        if((loot.ownerOf(lootNumber) == msg.sender) && (!isAirdropClaimed[lootNumber])){
            _mint(msg.sender, 1000 * 1e18);
            isAirdropClaimed[lootNumber] = true;
        }
    }
    function mint(address to, uint value) external {
        require(msg.sender == owner, "Only BanditLoot Contract can mint");
        _mint(to, value);
    }
}




contract BanditLoot is ERC721URIStorage {
        struct Armor {
            string armorType;
            string[] armorList;
        }
    
        Loot loot = Loot(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
        Loot mloot = Loot(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

        string[] private weapons = [
        "Warhammer",
        "Quarterstaff",
        "Maul",
        "Mace",
        "Club",
        "Katana",
        "Falchion",
        "Scimitar",
        "Long Sword",
        "Short Sword",
        "Ghost Wand",
        "Grave Wand",
        "Bone Wand",
        "Wand",
        "Grimoire",
        "Chronicle",
        "Tome",
        "Book"
    ];
    
    string[] private chestArmor = [
        "Divine Robe",
        "Silk Robe",
        "Linen Robe",
        "Robe",
        "Shirt",
        "Demon Husk",
        "Dragonskin Armor",
        "Studded Leather Armor",
        "Hard Leather Armor",
        "Leather Armor",
        "Holy Chestplate",
        "Ornate Chestplate",
        "Plate Mail",
        "Chain Mail",
        "Ring Mail"
    ];
    
    string[] private headArmor = [
        "Ancient Helm",
        "Ornate Helm",
        "Great Helm",
        "Full Helm",
        "Helm",
        "Demon Crown",
        "Dragon's Crown",
        "War Cap",
        "Leather Cap",
        "Cap",
        "Crown",
        "Divine Hood",
        "Silk Hood",
        "Linen Hood",
        "Hood"
    ];
    
    string[] private waistArmor = [
        "Ornate Belt",
        "War Belt",
        "Plated Belt",
        "Mesh Belt",
        "Heavy Belt",
        "Demonhide Belt",
        "Dragonskin Belt",
        "Studded Leather Belt",
        "Hard Leather Belt",
        "Leather Belt",
        "Brightsilk Sash",
        "Silk Sash",
        "Wool Sash",
        "Linen Sash",
        "Sash"
    ];

    string[] private handArmor = [
        "Holy Gauntlets",
        "Ornate Gauntlets",
        "Gauntlets",
        "Chain Gloves",
        "Heavy Gloves",
        "Demon's Hands",
        "Dragonskin Gloves",
        "Studded Leather Gloves",
        "Hard Leather Gloves",
        "Leather Gloves",
        "Divine Gloves",
        "Silk Gloves",
        "Wool Gloves",
        "Linen Gloves",
        "Gloves"
    ];
    


    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getWeapon(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "WEAPON", weapons);
    }
    
    function getChest(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "CHEST", chestArmor);
    }
    
    function getHead(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "HEAD", headArmor);
    }
    
    function getWaist(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "WAIST", waistArmor);
    }
    
    function getHand(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "HAND", handArmor);
    }
    

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[11] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getWeapon(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getChest(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getHead(tokenId);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = getWaist(tokenId);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = getHand(tokenId);

        parts[10] = '</text></svg>';


        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        output = string(abi.encodePacked(output, parts[9], parts[10]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "Loot is randomized adventurer gear generated and stored on chain. Stats, images, and other functionality are intentionally omitted for others to interpret. Feel free to use Loot in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    
    function random2(uint max, uint salt) view public returns(uint){
        return uint(keccak256(abi.encodePacked(block.coinbase, salt))) % max;
    }
    
    function pluckIndex(uint tokenId, string memory keyPrefix, uint sourceArrayLength) internal pure returns(uint256){
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        return rand % sourceArrayLength;
    }
    
    function greatness(uint index) internal pure returns(uint) {
        if(index % 21 >= 19)
            return 3;
        if(index % 21 >= 14)
            return 2;
        return 1;
    }
    
    event BanditDefeated(uint tokenId, address defeatedBy, int score);
    event PlayerDefeated(address player, uint banditLootId, int score);
    mapping(uint => bool) banditDefeated;
    uint lootBox = 0;
    
    function getArmors(uint tokenId, uint banditLootId) internal view returns(uint[4] memory, uint[4] memory, uint[4] memory) {
                
        uint[4] memory playerArmors;
        uint[4] memory banditArmors;
        uint[4] memory arrayLengths;
        
        //headArmor
        playerArmors[0] = pluckIndex(tokenId, "HEAD", headArmor.length);
        banditArmors[0] = pluckIndex(banditLootId, "HEAD", headArmor.length);
        arrayLengths[0] = headArmor.length;

        
        //chestArmor
        playerArmors[1] = pluckIndex(tokenId, "CHEST", chestArmor.length);
        banditArmors[1] = pluckIndex(banditLootId, "CHEST", chestArmor.length);
        arrayLengths[1] = chestArmor.length;

        
        //handArmor
        playerArmors[2] = pluckIndex(tokenId, "HAND", handArmor.length);
        banditArmors[2] = pluckIndex(banditLootId, "HAND", handArmor.length);
        arrayLengths[2] = handArmor.length;
        
        //waistArmor
        playerArmors[3] = pluckIndex(tokenId, "WAIST", waistArmor.length);
        banditArmors[3] = pluckIndex(banditLootId, "WAIST", waistArmor.length);
        arrayLengths[3] = waistArmor.length;
        
        return (playerArmors, banditArmors, arrayLengths);
    }
    
    function fight(uint256 tokenId, uint256 accuracyBoosterInBanditGold) public returns(string memory){
        require(loot.ownerOf(tokenId) == msg.sender || mloot.ownerOf(tokenId) == msg.sender, "You must be the owner of the loot to play");
        require(banditLootGold.allowance(msg.sender, address(this)) >= accuracyBoosterInBanditGold, "Accuracy Booster needs approval first");
        require(!banditDefeated[tokenId], "Bandit already defeated");
        banditLootGold.transferFrom(msg.sender, address(this), accuracyBoosterInBanditGold);
        lootBox += accuracyBoosterInBanditGold;
        
        
        uint banditLootId = 1300000 + random2(1300000, 0);
        
        uint playerScore = 0;
        uint banditScore = 0;
        
        //weapon
        uint playerWeapon = pluckIndex(tokenId, "WEAPON", weapons.length);
        uint banditWeapon = pluckIndex(banditLootId, "WEAPON", weapons.length);

        uint[4] memory playerArmors;
        uint[4] memory banditArmors;
        uint[4] memory arrayLengths;
        (playerArmors, banditArmors, arrayLengths) = getArmors(tokenId, banditLootId);
        
        uint totalAccuracy = 0;

        for(uint i = 0; i < 4; i+= 1){
            uint accuracy = 0;
            if(1000000 - (random2(1000, i)*random2(accuracyBoosterInBanditGold, i)/1e18) > 0)
                accuracy = 1000000 - (random2(1000, i)*random2(accuracyBoosterInBanditGold, i)/1e18);
            totalAccuracy += accuracy;
            banditScore += 10 + (((playerArmors[i] + banditWeapon)%arrayLengths[i]) * accuracy * 10)/1000000;
            playerScore += 10 + (((banditArmors[i] + playerWeapon)%arrayLengths[i]) * accuracy * 10)/1000000 - greatness(banditArmors[i]);
        }

        if(banditScore > playerScore){
            emit PlayerDefeated(msg.sender, banditLootId, 0);
            return string(abi.encodePacked("You lost to bandit#",toString(banditLootId)));
        }

        _safeMint(msg.sender, banditLootId);

        uint earnings = 0;
        banditLootGold.mint(msg.sender, (playerScore - banditScore) * 1e18);
        earnings += (playerScore - banditScore) * 1e18;
        banditLootGold.transfer(address(this), lootBox);
        earnings += lootBox;
        lootBox = 0;
        
        emit BanditDefeated(banditLootId, msg.sender, int(playerScore - banditScore));
        
        return string(abi.encodePacked("You earned ",toString(earnings), " bandit gold and bandit loot #", toString(banditLootId)));
        
    }
    
    

    BanditLootGold banditLootGold;
    
    constructor() ERC721("BanditLoot", "B-LOOT") {
        banditLootGold = new BanditLootGold(msg.sender);
    }
    
    function getBanditGoldAddress() public view returns(address) {
        return address(banditLootGold);
    }
}


/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
