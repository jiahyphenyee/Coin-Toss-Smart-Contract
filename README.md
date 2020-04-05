# Coin-Toss-Smart-Contract
Exercise 9 from https://github.com/pszal/teaching/blob/master/2020_50.037-Blockchain-Technology/9_Exercises.md

## Running the Coin Toss protocol
1. Deploy the contract.
2. Alice calls `registerPlayers` function with input param of a self-chosen random number. Include some ETH to place a bet.
3. Bob calls `registerPlayers` with his own chosen input number and also the same betting amount that Alice has specified.
4. Alice then calls the `flipCoin` function to generate the outcome and reveal the winner.
5. If Alice does not `flipCoin` within the bet expiration period of 3 hours from the time Bob places his bet, Bob can call to `withdrawBet` and receive the total bet winnings.

## Deciding the winner
Flip = (Alice's input number + Bob's input number) % 2
Bet = Bob's input number % 2

If Flip == Bet, Bob wins. Otherwise, Alice wins.
