# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get raw transaction with input details
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis
OUTPUTS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add * 100000000 | floor')

# Calculate total inputs in satoshis
INPUTS=0
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    [[ "$prev_txid" == "null" ]] && continue  # Skip coinbase inputs
    
    vout=$(echo "$vin" | jq -r '.vout')
    value=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1 | jq -r ".vout[$vout].value")
    INPUTS=$(echo "$INPUTS + ($value * 100000000)/1" | bc)
done

# Calculate fee (inputs - outputs)
FEE=$((INPUTS - OUTPUTS))

# Print only the fee amount with no extra characters
echo $FEE