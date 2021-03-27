# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# Addresses
WALLET_ADDRESS='tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF'
MINTER_ADDRESS='KT1Ty2uAmF5JxWyeGrVpk17MEyzVB8cXs8aJ'
OVEN_ADDRESS='KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM'

# Tezos
PRICE=$(curl -sX GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=eur,usd')

EUR=$(echo $PRICE | jq --raw-output '.tezos.eur')
USD=$(echo $PRICE | jq --raw-output '.tezos.usd')

# Wallet
WALLET=$(curl -sX GET "https://api.tzstats.com/explorer/account/$WALLET_ADDRESS")

XTZ=$(echo $WALLET | jq --raw-output '.total_balance')

# Kolibri
OVEN=$(curl -sX GET "https://api.tzstats.com/explorer/account/$OVEN_ADDRESS")
OVEN_STORAGE=$(curl -sX GET "https://api.tzstats.com/explorer/contract/$OVEN_ADDRESS/storage")

OVEN=$(echo $OVEN | jq --raw-output '.total_balance')
KUSD=$(echo $OVEN_STORAGE | jq --raw-output '.value.borrowedTokens')

# Status
python3 -c "print(f'ꜩ : {$EUR:,.2f} €')"
echo "---"
echo "Wallet"
python3 -c "print(f'Personal : {$XTZ:,.2f} ꜩ | href=\'https://tzkt.io/tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF/rewards\'')"
echo "---"
echo "Kolibri"
python3 -c "print(f'Oven : {$OVEN:,.2f} ꜩ | href=\'https://tzkt.io/KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM/rewards\'')"
python3 -c "print(f'Borrowed : {$KUSD/10**18:,.2f} $')"
python3 -c "print(f'Collateral use : {((($KUSD)/10**18)/(($OVEN*$USD)/2))*100:,.2f} %')"
echo "---"
echo "Stats"
echo "CoinGecko | href='https://www.coingecko.com/en/coins/tezos'"
