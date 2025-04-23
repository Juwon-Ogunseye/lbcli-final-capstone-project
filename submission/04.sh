# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7
#!/bin/bash

TXID="d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7"

# Get the witness data for input 0
PUBKEY=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.vin[0].txinwitness[-1]')

# Verify we got a valid public key
if [[ -z "$PUBKEY" || "$PUBKEY" == "null" ]]; then
    echo "❌ Error: Could not extract public key from witness data"
    exit 1
else
    echo "$PUBKEY"
    exit 0
fi
