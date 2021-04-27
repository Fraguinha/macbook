# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# Variables
WALLET_ADDRESS='tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF'

# Price
PRICE=$(curl -sX GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=eur,usd')

EUR=$(echo $PRICE | jq --raw-output '.tezos.eur')
USD=$(echo $PRICE | jq --raw-output '.tezos.usd')

# Wallet
WALLET=$(curl -sX GET "https://api.tzkt.io/v1/accounts/$WALLET_ADDRESS")
XTZ=$(echo $WALLET | jq --raw-output '.balance')

# Status
python3 -c "\
print(f'ꜩ : {$EUR:,.2f} €')"

echo "---"
echo "Wallet"

python3 -c "\
print(f'Tezos: {$XTZ/10**6:,.2f} ꜩ | href=\'https://tzkt.io/$WALLET_ADDRESS/rewards\'')"
python3 -c "\
value=$XTZ/10**6*$EUR;
print(f'Value: {value:,.2f} €')"

echo "---"
echo "Dex"

echo "QuipuSwap | href='https://quipuswap.com/swap'"
echo "Dexter | href='https://app.dexter.exchange'"

echo "---"
echo "DeFi"

echo "Kolibri | href='https://kolibri.finance'"

echo "---"
echo "Stats"

echo "CoinGecko | href='https://www.coingecko.com/en/coins/tezos'"
