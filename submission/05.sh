# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get the raw transaction hex
RAW_TX=$(bitcoin-cli -signet getrawtransaction "$TXID")

# Decode to get the full details
DECODED=$(bitcoin-cli -signet decoderawtransaction "$RAW_TX")

# Get the blockhash to check confirmation status
BLOCKHASH=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.blockhash')

# Get the actual fee from the block
if [ "$BLOCKHASH" != "null" ]; then
    FEE_SATS=$(bitcoin-cli -signet getblock "$BLOCKHASH" | jq -r ".tx[] | select(.txid == \"$TXID\") | .fee * 100000000 | floor")
else
    # Fallback to mempool if not confirmed
    FEE_SATS=$(bitcoin-cli -signet getmempoolentry "$TXID" | jq -r '.fees.base * 100000000 | floor')
fi

# Output only the fee amount
echo "$FEE_SATS"