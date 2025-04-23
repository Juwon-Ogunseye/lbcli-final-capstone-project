# Which tx in block 216,351 spends the coinbase output of block 216,128?
# Step 1: Get coinbase txid from block 216128
COINBASE_TXID=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) | jq -r '.tx[0]')

# Step 2: Get all txs in block 216351
BLOCK_TXS=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216351) | jq -r '.tx[]')

# Step 3: Loop through and check if any tx inputs spend the coinbase txid
for TXID in $BLOCK_TXS; do
  VIN=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.vin[].txid')
  for INPUT in $VIN; do
    if [[ "$INPUT" == "$COINBASE_TXID" ]]; then
      echo "✅ This tx spends the coinbase: $TXID"
    fi
  done
done
