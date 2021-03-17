# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# CoinGecko price data
DATA=$(curl -sX GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=eur,usd')
EUR=$(echo $DATA | jq --raw-output ".tezos.eur")
USD=$(echo $DATA | jq --raw-output ".tezos.usd")

# Wallet
XTZ=$(curl -sX GET 'https://api.tzstats.com/explorer/account/tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF' | jq --raw-output '.total_balance')

# Kolibri
OVEN=$(curl -sX GET 'https://api.tzstats.com/explorer/account/KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM' | jq --raw-output '.total_balance')
KUSD=$(curl -sX GET 'https://api.tzstats.com/explorer/contract/KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM/storage' | jq --raw-output '.value.borrowedTokens')
RATE=$(curl -sX GET 'https://api.tzstats.com/explorer/contract/KT1Ty2uAmF5JxWyeGrVpk17MEyzVB8cXs8aJ/storage' | jq --raw-output '.value.interestIndex')

# Status
python3 -c "print(f'ꜩ : {$EUR:,.2f} €')"
echo "---"
python3 -c "print(f'Wallet')"
python3 -c "print(f'Personal : {$XTZ:,.2f} ꜩ | href=\'https://tzkt.io/tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF/rewards\'')"
echo "---"
python3 -c "print(f'Kolibri')"
python3 -c "print(f'Oven : {$OVEN:,.2f} ꜩ | href=\'https://tzkt.io/KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM/rewards\'')"
python3 -c "print(f'kUSD : {$KUSD/10**18:,.2f} $')"
python3 -c "print(f'Stability fee : {((1*(1+.$RATE/513000)**(513000))-1)*100:.2f} %')"
python3 -c "print(f'Collateral use : {((($KUSD)/10**18)/(($OVEN*$USD)/2))*100:,.2f} %')"
