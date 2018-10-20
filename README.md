Goal:
Build a cryptocurrency market simulation to use in training ML to trade and play the market

# V1
[x] Implement a cryptocurrency blockchain - AlphaCoin
[x] Full Ledger is JSON body of each block
[x] One miner takes current ledger and credits itself with 1000 coins (1 k coin)
[x] Use hostname as ledger account name

# One Chain File to Rule Them All
[x] Implement dockerized miners that all compete for longest chain and share that chain amongst each other (shared file determines chain, use a seed)
[x] Manually tuned difficulty to ~1 minute for 3 miners
[x] Look at file timestamp to see if chain changed before claiming block
[x] Claim lock, Write chain, Unlock chain

# Hard Fork Time!
[x] Introduce 2 other chains using exact same code (BravoCoin, CharlieCoin)
[x] Allow an agent to mine multiple chains (miner looks at current balance and mines its most preferred chain - balancer - go for lowest balance)

# Basic Balancing Trading and Provisional “Clearing House”
Each Miner now has a Trader that works on its behalf
Trader A is unbalanced: checks offers, nothing good, creates order: price * volume
Trader B takes best open offer that satisfies goals (closest to balancing that’s the oldest open offer), locks it, marks it done, and “signs” both halves of transaction and queues them into actual trades
Next block mined on each will confirm the trade on each ledger
Miners put transactions into the next block and complete them

# Scale
Scale miner count and difficulty by 10x

# Simple Greedy Trader
Take top trade that maximizes total asset count

# Market Greedy Trader Strategy
Market Greedy Miner wants to find trades that increase portfolio “value”
Checks most recently closed trades for current market value of assets
AlphaCoin, BravoCoin to Alpha, CharlieCoin to Alpha
Using those market values, it seeks to complete top trade that will increase its total valuation

# Monitoring
Watch the full ledger
Monitor Process also displays trade book stats
Expect greedy trader to slowly accumulate the most resources as supply is roughly 1:1:1, and greedy is always making trades that favor coins in higher demand
Expect miners to keep rotating mining
Expect trading to keep exchange rates close to 1:1
Expect similar behavior with more miners and similar difficulty
See what happens when trade orders are split up

# V2+

# Difficulty Tuning
Upgrade difficulty
Tune mining based on how much time was between blocks, 1, 2, 4 minutes each
21 miners means, 3 on alpha, 6 on bravo, 12 on charlie

# Introduce New Strategies to Ecosystem
Upgrade valuation strategies for mining/trader pairs
Miners choose to mine based on highest relative value in market instead of balancing
Balancers
Greedy
Random
Trader choose to trade based on different valuation strategies
Arbitrage - look for pairs to be under/over valued compared to other 2
HODL - no trading
All are worth the same - make top trade that improve total holdings
Look at current spot price - make top trade to improve total valuation
Look at moving average - 2,4,8,16,32,64,128 back
Watch “fake news publisher” - every minute add a bullish, bearish to each
Wild Card - current values randomly shift ((-10, 10).to_a.pluck)%

# Improved Clearing House
Upgrade shared file of orders to a separate system
Go from one book of “trade orders” to separate books
Separate trade order into a buy and a sell
Partial order filling?
Filling multiple orders at once
Spot pricing
Cancelling an order
FIFO fulfilling orders at same pricepoint

# Networked Miners
Upgrade mechanisms to communicate the current chain
Introduce a mechanism to publish longest chain and everyone agrees on longest chain
Introduce a bootstrapping process for getting into the mining pool
Introduce a way to propagate transfers
Set up docker on multiple machines and test over LAN
buy more raspberry pis and swarm?

# Malicious Agents
Upgrade to trustless system where all transactions are signed
Protect chain - miners agree to ignore malicious agent chain based on signatures
Rogue miners that try to deceive the system should be locked out

# Artificially Intelligent Traders
Apply ML to the market rates and introduce an AI strategy agent that should nash equilibrium

# Volume
Scale up to many coins
Scale up to many miners
Tweak difficulties

# Whales
Give each agent an external value in a non chain ledger (fiat reserves)
Have whale do interesting things
Buy up many orders
Introduce a whale that buys up a massive share of one resource from various parties using that value
See how much a huge influx disrupts market equilibrium
