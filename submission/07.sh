# what is the coinbase tx in this block 243,834
#!/bin/bash

BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243834)
COINBASE_TX=$(bitcoin-cli -signet getblock "$BLOCK_HASH" | jq -r '.tx[0]')
echo "$COINBASE_TX"
