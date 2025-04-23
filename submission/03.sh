# Which tx in block 216,351 spends the coinbase output of block 216,128?
#!/bin/bash

# Step 1: Get coinbase txid from block 216128
COINBASE_TXID=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) | jq -r '.tx[0]')

# Step 2: Get all txs in block 216351
BLOCKHASH=$(bitcoin-cli -signet getblockhash 216351)
TXIDS=$(bitcoin-cli -signet getblock "$BLOCKHASH" | jq -r '.tx[]')

# Step 3: Check each tx to see if it spends the coinbase txid
for TXID in $TXIDS; do
  VIN_TXIDS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.vin[].txid')
  for INPUT_TXID in $VIN_TXIDS; do
    if [[ "$INPUT_TXID" == "$COINBASE_TXID" ]]; then
      echo "✅ Found transaction spending coinbase: $TXID"
      exit 0
    fi
  done
done

echo "❌ No transaction in block 216351 spends the coinbase output of 216128"
exit 1
