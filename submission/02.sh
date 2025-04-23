# How many new outputs were created by block 243,825?
#!/bin/bash

# Step 1: Get block hash for block height 243825
BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243825)

# Step 2: Get list of transactions in that block
TXIDS=$(bitcoin-cli -signet getblock "$BLOCK_HASH" | jq -r '.tx[]')

# Step 3: Loop through transactions and sum vout count
TOTAL_OUTPUTS=0
for TXID in $TXIDS; do
  OUTPUTS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq '.vout | length')
  TOTAL_OUTPUTS=$((TOTAL_OUTPUTS + OUTPUTS))
done

# Step 4: Print ONLY the number
echo $TOTAL_OUTPUTS
