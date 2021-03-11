# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

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
python3 -c "print('ꜩ : %.2f €' % ($XTZ_BUSD / $EUR_BUSD))"
echo '---'
python3 -c "print(f'₿ : {$BTC_BUSD/$EUR_BUSD:>15.02f} € | href=https://www.binance.com/en/trade/BTC_BUSD')"
python3 -c "print(f'Ξ : {$ETH_BUSD/$EUR_BUSD:>15.02f} € | href=https://www.binance.com/en/trade/ETH_BUSD')"
python3 -c "print(f'ꜩ : {$XTZ_BUSD/$EUR_BUSD:>15.02f} € | href=https://www.binance.com/en/trade/XTZ_BUSD')"
