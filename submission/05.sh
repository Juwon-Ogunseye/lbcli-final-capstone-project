# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get transaction with previous output information
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis (truncate decimals)
OUTPUTS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add * 100000000 | trunc')

# Initialize inputs total
INPUTS=0

# Process each input
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    vout=$(echo "$vin" | jq -r '.vout')
    
    # Skip coinbase inputs
    if [ "$prev_txid" != "null" ]; then
        # Get previous output value and convert to satoshis
        value=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1 | jq -r ".vout[$vout].value")
        INPUTS=$(echo "$INPUTS + ($value * 100000000)/1" | bc)
    fi
done

# Calculate and print fee (inputs - outputs)
echo $((INPUTS - OUTPUTS))