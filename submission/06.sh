# Only one tx in block 243,821 signals opt-in RBF. What is its txid?
#!/bin/bash

#!/bin/bash

BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243821)
TXIDS=$(bitcoin-cli -signet getblock "$BLOCK_HASH" | jq -r '.tx[]')

for TXID in $TXIDS; do
  # Get input sequences one by one
  INPUT_COUNT=$(bitcoin-cli -signet getrawtransaction "$TXID" true | jq '.vin | length')
  
  for ((i=0; i<INPUT_COUNT; i++)); do
    SEQ=$(bitcoin-cli -signet getrawtransaction "$TXID" true | jq ".vin[$i].sequence")
    
    if [ "$SEQ" -lt 4294967294 ]; then
      echo "$TXID"
      exit 0
    fi
  done
done

# If none match, exit with failure (autograder-style)
exit 1

