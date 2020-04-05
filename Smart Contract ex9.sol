pragma solidity ^0.4.24;
// pragma experimental ABIEncoderV2;

contract CoinToss{
    
    struct Player {
        address addr;
        uint number;
        string role;
    }
    
    uint betAmount;
    Player flipper;
    bool flipperExist = false;
    Player better;
    bool betterExist = false;
    
    Player[2] private players;  // only 2 players
    uint8 count = 0;
    string winner = "";
    uint256 betShelfLife;

    constructor() public {}
    
    function registerPlayers (uint guess) public payable {
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
            require(msg.value == betAmount, "Wrong betting amount");
            betShelfLife = now + 3 hours;
            better = players[count];
            players[count].role = "better";
            betterExist = true;
            
        }
        
        count ++;
        
    }
    
    function setBet(uint amount) private {
        require(msg.sender == flipper.addr);
        betAmount = amount;
    }
    
    function flipCoin () payable external onlyFlipper{
        require (better.addr != address(0), "A better is required");
        
        uint flip = flipper.number%2;
        uint bet = better.number%2;
        
        if (flip == bet) {
            // better wins
            better.addr.transfer(address(this).balance);
            winner = "better wins";
        } else {
            // flipper wins
            flipper.addr.transfer(address(this).balance);
            winner = "flipper wins";
        }
        
        emit showWinner(winner);
        count = 0;
        winner = "";
        betShelfLife = 0;
        
    }
    
    function withdrawBet() public payable{
        require(now >= betShelfLife, "Cannot withdraw when contract has not expired");
        require(msg.sender != flipper.addr);
        
        msg.sender.transfer(address(this).balance);
    }
    
    event showWinner(string w);
    
    modifier onlyFlipper () {
        require(msg.sender == flipper.addr);
        _;
    }
    
    modifier notExpired() {
        require(now < betShelfLife);
        _;
    }
    
    // fallback function
    function() public payable {
        //sample fallback
        }
}