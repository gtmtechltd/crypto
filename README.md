crypto
======

crypto is a utiity for keeping track of all your cryptocurrency accounts. It aims to do the following

* Log transactions
* Provide account statements
* Provide detailed transaction history

in order that:

* You understand where your money is
* You can provide records for tax purposes


Setup:
======

First install ruby/rubygems. Then install this

```
    gem install gtmtech-crypto
```


Usage:
======

Firstly set up some accounts

```
    $ crypto account add --name barclays --currencies GBP     --type bank
    $ crypto account add --name kraken   --currencies GBP,BTC --type exchange
    $ crypto account add --name ledger   --currencies BTC,ETH --type wallet
```

Then trade

```
    $ crypto txn add --from barclays.GBP=200 --to bitbargain.GBP
    $ crypto txn add --from kraken.GBP=150 --to kraken.BTC=0.08
```

some transactions have fees associated with them

```
    $ crypto txn add --from kraken.BTC=0.08 --to ledger.BTC=0.078              # implicit fees of 0.0002 BTC
    $ crypto txn add --from kraken.BTC=0.08 --to ledger.BTC --fees.BTC=0.002   # extra fees paid at source (kraken)
```

Output transaction history

```
    $ crypto txn list                       # all transactions
    $ crypto txn list --account  barclays   # all barclays transactions
    $ crypto txn list --currency BTC        # all bitcoin transactions
```

Output pnl sheet

```
    $ crypto pnl   # profit-and-loss
```

Profiles
========

You can keep track of different user profiles, using the CRYPTO_PROFILE environment variable:

```
    $ export CRYPTO_PROFILE=antony
    
    $ crypto account list
``` 

Building
========

Install chruby and ruby-build

* OSX: https://gist.github.com/andrewroycarter/6815905

Install version 2.0.0 of ruby using chruby

```
       $ ruby-install ruby 2.0.0
    or $ ruby-build ruby 2.0.0
```

Build the gem

```
    $ ./build.sh
```

Disclaimer
==========

Please see LICENSE.TXT for usage of this software. 

