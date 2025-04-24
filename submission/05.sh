# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
#!/bin/bash

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Function to convert BTC to satoshis
btc_to_sats() {
    echo "$1 * 100000000" | bc | awk '{printf "%.0f", $1}'
}

# Get the transaction data
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Calculate total outputs in satoshis
OUTPUTS_SATS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add | . * 100000000 | floor')

# Calculate total inputs in satoshis
INPUTS_SATS=0
for vin in $(echo "$TX_DATA" | jq -c '.vin[]'); do
    prev_txid=$(echo "$vin" | jq -r '.txid')
    vout=$(echo "$vin" | jq -r '.vout')
    
    # Skip if coinbase input (null txid)
    if [ "$prev_txid" == "null" ]; then
        continue
    fi
    
    prev_tx_data=$(bitcoin-cli -signet getrawtransaction "$prev_txid" 1)
    value=$(echo "$prev_tx_data" | jq -r ".vout[$vout].value")
    INPUTS_SATS=$((INPUTS_SATS + $(btc_to_sats "$value")))
done

# Calculate fee
FEE_SATS=$((INPUTS_SATS - OUTPUTS_SATS))

# Output just the fee amount
echo "$FEE_SATS"