# Which tx in block 216,351 spends the coinbase output of block 216,128?
#!/bin/bash

#!/bin/bash

set -e

# Step 1: Get coinbase txid from block 216128
COINBASE_TXID=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) | jq -r '.tx[0]')

# Step 2: Get all txs in block 216351
BLOCKHASH=$(bitcoin-cli -signet getblockhash 216351)
TXIDS=$(bitcoin-cli -signet getblock "$BLOCKHASH" | jq -r '.tx[]')

# Step 3: Check each tx to see if it spends the coinbase txid
for TXID in $TXIDS; do
  if bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.vin[].txid' | grep -q "$COINBASE_TXID"; then
    echo "$TXID"  # Output just the transaction ID for autograder compatibility
    exit 0
  fi
done

# If no transaction matched
exit 1
