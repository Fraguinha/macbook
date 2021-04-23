# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# Variables
WALLET_ADDRESS='tz1VjYmQHw4QE6tYTQLLfWNjqkUNwMC7YPoF'
OVEN_ADDRESS='KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM'
BOUGHT='2610.5'

# Price
PRICE=$(curl -sX GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=eur,usd')

EUR=$(echo $PRICE | jq --raw-output '.tezos.eur')
USD=$(echo $PRICE | jq --raw-output '.tezos.usd')

# Wallet
WALLET=$(curl -sX GET "https://api.tzkt.io/v1/accounts/$WALLET_ADDRESS")
XTZ=$(echo $WALLET | jq --raw-output '.balance')

# Kolibri
MINTER_ADDRESS='KT1Ty2uAmF5JxWyeGrVpk17MEyzVB8cXs8aJ'
MINTER_STORAGE=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$MINTER_ADDRESS/storage")

OVEN=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$OVEN_ADDRESS")
OVEN_STORAGE=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$OVEN_ADDRESS/storage")

MINTER_INTEREST=$(echo $MINTER_STORAGE | jq --raw-output '.interestIndex')
MINTER_STABILITY=$(echo $MINTER_STORAGE | jq --raw-output '.stabilityFee')

OVEN=$(echo $OVEN | jq --raw-output '.balance')
KUSD=$(echo $OVEN_STORAGE | jq --raw-output '.borrowedTokens')
OVEN_INTEREST=$(echo $OVEN_STORAGE | jq --raw-output '.interestIndex')
OVEN_FEE=$(echo $OVEN_STORAGE | jq --raw-output '.stabilityFeeTokens')

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
echo "Kolibri"
python3 -c "\
print(f'Oven: {$OVEN/10**6:,.2f} ꜩ | href=\'https://tzkt.io/$OVEN_ADDRESS/rewards\'')"
python3 -c "\
value=$OVEN/10**6*$EUR;
print(f'Value: {value:,.2f} €')"
echo "---"
python3 -c "\
print(f'Bought: {$BOUGHT:,.2f} ꜩ')"
python3 -c "\
value=$BOUGHT*$EUR;
print(f'Value: {value:,.2f} €')"
python3 -c "\
value=$BOUGHT*$USD;
debt=$MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
diff=(value-debt)*($EUR/$USD);
print(f'{\"Profit\" if diff >= 0 else \"Loss\"}: {diff:,.2f} € | color={\"darkgreen,green\" if diff >= 0 else \"darkred,red\"}')"
python3 -c "\
value=($BOUGHT*$USD);
debt=$MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
percentage=value/debt*100-100;
print(f'Percentage: {percentage:,.2f} % | color={\"darkgreen,green\" if percentage >= 0 else \"darkred,red\"}')"
echo "---"
python3 -c "\
initial=$MINTER_STABILITY/10**18+1;
apr=1;
for i in range(365*24*60):
    apr=apr*initial;
apr=(apr-1)*100;
print(f'Rate: {apr:,.2f} %')"
python3 -c "\
debt=($MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**18)/10**18;
print(f'Debt: {debt:,.2f} $')"
python3 -c "\
interest=($MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**18-$KUSD)/10**18;
print(f'Interest: {interest:,.2f} $')"
python3 -c "\
borrowed=$KUSD/10**18;
print(f'Borrowed: {borrowed:,.2f} $')"
python3 -c "\
value=($OVEN/10**6*$USD);
debt=$MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
percentage=(debt/(value/2))*100;
print(f'Collateral use: {percentage:,.2f} % | {\"color=darkgreen,green\" if percentage <= 40 else \"color=darkorange,orange\" if 60 <= percentage < 80 else \"color=darkred,red\" if percentage >= 80 else \"\" }')"
python3 -c "\
xtz=($OVEN/10**6);
debt=$MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
price=(2*debt/xtz);
print(f'Liquidation: {price:,.2f} $')"
python3 -c "\
xtz=($OVEN/10**6);
value=($OVEN/10**6*$USD);
debt=$MINTER_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
price=(2*debt/xtz);
delta=$USD-price;
percentage=(debt/(value/2))*100;
print(f'Margin: {delta:,.2f} $ | {\"color=darkgreen,green\" if percentage <= 40 else \"color=darkorange,orange\" if 60 <= percentage < 80 else \"color=darkred,red\" if percentage >= 80 else \"\" }')"
echo "---"
echo "Stats"
echo "CoinGecko | href='https://www.coingecko.com/en/coins/tezos'"
