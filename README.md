crypto
======

crypto is a utiity for keeping track of all your cryptocurrency accounts. It aims to do the following

* Log transactions
* Provide account statements
* Provide detailed transaction history

in order that:

* You understand where your money is
* You can provide records for tax purposes


Usage:
======

Firstly set up some accounts

$ crypto new account --name barclays --currencies GBP     --type bank
$ crypto new account --name kraken   --currencies GBP,BTC --type exchange
$ crypto new account --name ledger   --currencies BTC,ETH --type wallet

Then trade

$ crypto new txn --from barclays.GBP=200 --to bitbargain.GBP
$ crypto new txn --from kraken.GBP=150 --to kraken.BTC=0.08

# some transactions have fees associated with them

$ crypto new txn --from kraken.BTC=0.08 --to ledger.BTC=0.078              # implicit fees of 0.0002 BTC
$ crypto new txn --from kraken.BTC=0.08 --to ledger.BTC --fees.BTC=0.002   # extra fees paid at source (kraken)

Output transaction history

# crypto list txn                       # all transactions
# crypto list txn --account  barclays   # all barclays transactions
# crypto list txn --currency BTC        # all bitcoin transactions

Output pnl sheet

# crypto list pnl   # profit-and-loss
 


