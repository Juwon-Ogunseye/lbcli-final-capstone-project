# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7
#!/bin/bash
#!/bin/bash

# Get the scriptSig for input 0
SCRIPT_SIG=$(bitcoin-cli -signet getrawtransaction d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7 1 | jq -r '.vin[0].scriptSig.asm')

# Extract the public key (last element in scriptSig)
PUBKEY=$(echo "$SCRIPT_SIG" | awk '{print $NF}')

# Output the public key (for autograder)
echo "$PUBKEY"
