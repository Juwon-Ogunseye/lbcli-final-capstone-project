# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get the raw transaction data
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis (handle scientific notation)
OUTPUTS_SATS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add | (. * 100000000 | tostring | split(".")[0])')

# Initialize inputs total
INPUTS_SATS=0

# Process each input
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    vout=$(echo "$vin" | jq -r '.vout')
    
    # Skip coinbase inputs
    if [ "$prev_txid" == "null" ]; then
        continue
    fi
    
    # Get previous output value
    value=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1 | jq -r ".vout[$vout].value")
    
    # Convert to satoshis and add to total
    INPUTS_SATS=$((INPUTS_SATS + $(echo "$value * 100000000" | bc | awk '{printf "%.0f", $1}')))
done

# Calculate fee (handle case where inputs = 0)
if [ "$INPUTS_SATS" -eq 0 ]; then
    FEE_SATS=0
else
    FEE_SATS=$((INPUTS_SATS - OUTPUTS_SATS))
fi

# Output ONLY the fee number with no extra characters
echo $FEE_SATS