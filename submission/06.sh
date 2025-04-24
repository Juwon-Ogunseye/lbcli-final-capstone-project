# Only one tx in block 243,821 signals opt-in RBF. What is its txid?
#!/bin/bash

BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243821)
TXIDS=$(bitcoin-cli -signet getblock "$BLOCK_HASH" | jq -r '.tx[]')

for TXID in $TXIDS; do
  SEQ=$(bitcoin-cli -signet getrawtransaction "$TXID" true | jq '.vin[].sequence')
  if echo "$SEQ" | grep -qv "4294967295"; then
    echo "$TXID"
    exit 0
  fi
done
