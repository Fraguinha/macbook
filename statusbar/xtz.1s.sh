# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# CoinGecko price data
DATA=$(curl -X GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos%2Cbitcoin%2Cethereum&vs_currencies=eur' -H 'accept: application/json')

# Currencies
XTZ=$(echo $DATA | jq --raw-output ".tezos.eur")
BTC=$(echo $DATA | jq --raw-output ".bitcoin.eur")
ETH=$(echo $DATA | jq --raw-output ".ethereum.eur")

# Status
python3 -c "print('ꜩ : %.2f €' % ($XTZ))"
echo "---"
python3 -c "print('₿ : %.2f €' % ($BTC))"
python3 -c "print('Ξ : %.2f €' % ($ETH))"
