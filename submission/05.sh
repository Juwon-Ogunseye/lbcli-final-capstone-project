# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
#!/bin/bash

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get the transaction data
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis (rounded down)
OUTPUTS_SATS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add * 100000000 | floor')

# Calculate total inputs in satoshis
INPUTS_SATS=0
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    vout=$(echo "$vin" | jq -r '.vout')
    
    # Skip if coinbase input
    if [[ "$prev_txid" == "null" ]]; then
        continue
    fi
    
    # Get previous output value and convert to satoshis
    value=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1 | jq -r ".vout[$vout].value")
    value_sats=$(echo "$value * 100000000" | bc | awk '{printf "%.0f", $1}')
    INPUTS_SATS=$((INPUTS_SATS + value_sats))
done

# Calculate fee (inputs - outputs)
FEE_SATS=$((INPUTS_SATS - OUTPUTS_SATS))

# Output ONLY the fee number (no decimals, no text)
echo "$FEE_SATS"