# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get the transaction fee directly using the simplest method
FEE_BTC=$(bitcoin-cli -signet gettransaction "$TXID" | jq -r '.fee')

# Convert to satoshis and print just the number
echo $(($(echo "$FEE_BTC * 100000000" | bc | awk '{printf "%.0f", $1}')))