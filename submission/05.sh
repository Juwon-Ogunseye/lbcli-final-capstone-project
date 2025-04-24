# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get transaction with full details
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis (truncated)
OUTPUTS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add * 100000000 | floor')

# Calculate total inputs in satoshis
INPUTS=0
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    vout=$(echo "$vin" | jq -r '.vout')
    
    # Skip coinbase inputs
    if [ "$prev_txid" != "null" ]; then
        # Get previous output value
        prev_tx_data=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1)
        value=$(echo "$prev_tx_data" | jq -r ".vout[$vout].value")
        # Convert to satoshis and add (using awk for reliable conversion)
        value_sats=$(echo "$value" | awk '{printf "%.0f", $1 * 100000000}')
        INPUTS=$((INPUTS + value_sats))
    fi
done

# Calculate fee (inputs - outputs)
FEE=$((INPUTS - OUTPUTS))

# Print only the fee amount with no extra characters
echo $FEE