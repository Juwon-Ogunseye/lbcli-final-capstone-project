# How many new outputs were created by block 243,825?
#!/bin/bash

# Block hash for block 243825
BLOCK_HASH="000000b024f11595795f0be5974229f786df389c8b92e92b61890e9e3c6b8d8a"

# Get the list of transaction IDs in that block
TXIDS=$(bitcoin-cli -signet getblock $BLOCK_HASH | jq -r '.tx[]')

TOTAL_OUTPUTS=0

# Loop through each txid and count its vout entries
for TXID in $TXIDS; do
    OUT_COUNT=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq '.vout | length')
    TOTAL_OUTPUTS=$((TOTAL_OUTPUTS + OUT_COUNT))
done

echo "Total outputs in block 243825: $TOTAL_OUTPUTS"
