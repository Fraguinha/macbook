# Binance price data
DATA=$(curl -sfL 'https://www.binance.com/api/v3/ticker/price' | jq --raw-output ".[] | \
select(.symbol == \"XTZBUSD\"), \
select(.symbol == \"BTCBUSD\"), \
select(.symbol == \"ETHBUSD\"), \
select(.symbol == \"EURBUSD\") | .")

# Tezos
XTZ_BUSD=$(echo $DATA | jq --raw-output 'select(.symbol == "XTZBUSD") | .price')

# Other
BTC_BUSD=$(echo $DATA | jq --raw-output 'select(.symbol == "BTCBUSD") | .price')
ETH_BUSD=$(echo $DATA | jq --raw-output 'select(.symbol == "ETHBUSD") | .price')

# Euro
EUR_BUSD=$(echo $DATA | jq --raw-output 'select(.symbol == "EURBUSD") | .price')

# Status
echo $(python -c "print('ꜩ : %.2f €' % ($XTZ_BUSD / $EUR_BUSD))")
echo '---'
echo $(python -c "print('₿ : %.2f €' % ($BTC_BUSD / $EUR_BUSD))")
echo $(python -c "print('Ξ : %.2f €' % ($ETH_BUSD / $EUR_BUSD))")
