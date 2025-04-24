# How many new outputs were created by block 243,825?

BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243825)
TXIDS=$(bitcoin-cli -signet getblock "$BLOCK_HASH" | jq -r '.tx[]')
TOTAL_OUTPUTS=0
for TXID in $TXIDS; do
  OUTPUTS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq '.vout | length')
  TOTAL_OUTPUTS=$((TOTAL_OUTPUTS + OUTPUTS))
done
echo $TOTAL_OUTPUTS
