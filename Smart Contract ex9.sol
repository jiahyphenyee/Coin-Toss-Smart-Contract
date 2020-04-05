pragma solidity ^0.4.24;

contract CoinToss{
    
    struct Player {
        address addr;
        uint number;
        string role;
    }
    
    uint256 betAmount;
    Player flipper;
    bool flipperExist = false;
    Player better;
    bool betterExist = false;
    
    Player[2] private players;  // only 2 players
    uint8 count = 0;

    constructor() public {}
    
    function registerPlayers (uint guess) public payable {
        emit showCount(count);
        require (msg.sender != address(0));
        require (msg.value > 0, "Nil betting amount not allowed.");
        require (count < 2, "No more than 2 players");
        
        players[count] = Player(msg.sender, guess, "");
    
        // assign roles to players
        if (!flipperExist) {
            flipper = players[count];
            players[count].role = "flipper";
            flipperExist = true;
            setBet(msg.value);
            
        } else if (!betterExist) {
            
            better = players[count];
            players[count].role = "better";
            betterExist = true;
            
        }
        
        count ++;
        
    }
    
    function setBet(uint amount) public payable{
        require (msg.sender == flipper.addr);
        
        betAmount = amount;
    }
    
    function flipCoin () public payable {
        require (msg.sender == flipper.addr);
        require (better.addr != address(0), "A better is required");
        
        uint flip = flipper.number%2;
        uint bet = better.number%2;
        
        if (flip == bet) {
            // better wins
            better.addr.transfer(address(this).balance);
        } else {
            // flipper wins
            flipper.addr.transfer(address(this).balance);
        }
        
        count = 0;
        
    }
    
    event showCount(uint8 c);
    
    // fallback function
    function() public payable {
        //sample fallback
        }
}