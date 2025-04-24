# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

#!/bin/bash

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

TX_JSON=$(bitcoin-cli -signet getrawtransaction "$TXID" true)

TOTAL_OUTPUT=0
for value in $(echo "$TX_JSON" | jq -r '.vout[].value'); do
  SATOSHIS=$(echo "$value * 100000000" | bc | cut -d'.' -f1)
  TOTAL_OUTPUT=$((TOTAL_OUTPUT + SATOSHIS))
done
TOTAL_INPUT=0
for i in $(echo "$TX_JSON" | jq -c '.vin[]'); do
  VIN_TXID=$(echo "$i" | jq -r '.txid')
  VIN_VOUT=$(echo "$i" | jq -r '.vout')
  INPUT_TX=$(bitcoin-cli -signet getrawtransaction "$VIN_TXID" true)
  VALUE=$(echo "$INPUT_TX" | jq -r ".vout[$VIN_VOUT].value")
  SATOSHIS=$(echo "$VALUE * 100000000" | bc | cut -d'.' -f1)
  TOTAL_INPUT=$((TOTAL_INPUT + SATOSHIS))
done
FEE=$((TOTAL_INPUT - TOTAL_OUTPUT))

echo $FEE
