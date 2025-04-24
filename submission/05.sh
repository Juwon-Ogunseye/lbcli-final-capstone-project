# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
#!/bin/bash

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Initialize variables
INPUTS_SATS=0
OUTPUTS_SATS=0

# Get transaction details
TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID" 1)

# Sum inputs (UTXOs spent)
for VIN in $(echo "$TX_DATA" | jq -r '.vin[] | .txid + " " + (.vout|tostring)'); do
    TXID_PREV=$(echo "$VIN" | awk '{print $1}')
    VOUT=$(echo "$VIN" | awk '{print $2}')
    
    # Skip coinbase inputs (they have empty txid)
    if [[ "$TXID_PREV" == "0000000000000000000000000000000000000000000000000000000000000000" ]]; then
        continue
    fi
    
    PREV_TX_DATA=$(bitcoin-cli -signet getrawtransaction "$TXID_PREV" 1)
    VALUE=$(echo "$PREV_TX_DATA" | jq -r ".vout[$VOUT].value")
    VALUE_SATS=$(echo "$VALUE * 100000000" | bc | awk '{printf "%.0f", $1}')
    INPUTS_SATS=$((INPUTS_SATS + VALUE_SATS))
done

# Sum outputs (recipient amounts)
OUTPUTS_SATS=$(echo "$TX_DATA" | jq -r '[.vout[].value] | add * 100000000 | floor')

# Calculate fee (inputs - outputs)
FEE_SATS=$((INPUTS_SATS - OUTPUTS_SATS))

# Print ONLY the fee in satoshis
echo "$FEE_SATS"