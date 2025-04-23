# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7
#!/bin/bash

# Transaction ID
TXID="d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7"

# Extract and print the public key from input 0
bitcoin-cli -signet getrawtransaction "$TXID" true \
  | jq -r '.vin[0].scriptSig.asm' \
  | awk '{print $2}'
