# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Sum inputs (UTXOs spent)
INPUTS_SATS=0
for TXID_VOUT in $(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.vin[] | .txid + " " + (.vout|tostring)'); do
    TXID_PREV=$(echo "$TXID_VOUT" | awk '{print $1}')
    VOUT=$(echo "$TXID_VOUT" | awk '{print $2}')
    VALUE=$(bitcoin-cli -signet getrawtransaction "$TXID_PREV" 1 | jq -r ".vout[$VOUT].value")
    INPUTS_SATS=$(echo "$INPUTS_SATS + ($VALUE * 100000000)" | bc)
done

# Sum outputs (recipient amounts)
OUTPUTS_SATS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '[.vout[].value] | add * 100000000 | floor')

# Calculate fee (inputs - outputs)
FEE_SATS=$(echo "$INPUTS_SATS - $OUTPUTS_SATS" | bc)

# Print ONLY the fee in satoshis (for autograder)
echo "$FEE_SATS"