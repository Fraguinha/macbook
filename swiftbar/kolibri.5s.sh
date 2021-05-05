# Configurations
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# Variables
BOUGHT='2610.5'
OVEN_ADDRESS='KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM'
KOLIBRI_ADDRESS='KT1Ty2uAmF5JxWyeGrVpk17MEyzVB8cXs8aJ'

# Price
PRICE=$(curl -sX GET 'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=eur,usd')

EUR=$(echo $PRICE | jq --raw-output '.tezos.eur')
USD=$(echo $PRICE | jq --raw-output '.tezos.usd')

# Kolibri
KOLIBRI_STORAGE=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$KOLIBRI_ADDRESS/storage")

OVEN_CONTRACT=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$OVEN_ADDRESS")
OVEN_STORAGE=$(curl -sX GET "https://api.tzkt.io/v1/contracts/$OVEN_ADDRESS/storage")

KOLIBRI_INTEREST=$(echo $KOLIBRI_STORAGE | jq --raw-output '.interestIndex')
KOLIBRI_STABILITY=$(echo $KOLIBRI_STORAGE | jq --raw-output '.stabilityFee')

OVEN=$(echo $OVEN_CONTRACT | jq --raw-output '.balance')
KUSD=$(echo $OVEN_STORAGE | jq --raw-output '.borrowedTokens')
OVEN_INTEREST=$(echo $OVEN_STORAGE | jq --raw-output '.interestIndex')
OVEN_FEE=$(echo $OVEN_STORAGE | jq --raw-output '.stabilityFeeTokens')

# Status
python3 -c "\
value=($BOUGHT*$USD);
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
percentage=value/debt*100-100;
print(f'K$ : {percentage:,.2f} %')"

echo "---"
echo "Protocol"

python3 -c "\
initial=$KOLIBRI_STABILITY/10**18+1;
apr=1;
for i in range(365*24*60):
    apr=apr*initial;
apr=(apr-1)*100;
print(f'Rate: {apr:,.2f} %')"
python3 -c "\
debt=($KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**18)/10**18;
print(f'Debt: {debt:,.2f} $')"
python3 -c "\
interest=($KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**18-$KUSD)/10**18;
print(f'Interest: {interest:,.2f} $')"
python3 -c "\
borrowed=$KUSD/10**18;
print(f'Borrowed: {borrowed:,.2f} $')"
python3 -c "\
value=($OVEN/10**6*$USD);
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
percentage=(debt/(value/2))*100;
print(f'Collateral use: {percentage:,.2f} % | {\"color=darkgreen,green\" if percentage <= 40 else \"color=darkorange,orange\" if 60 <= percentage < 80 else \"color=darkred,red\" if percentage >= 80 else \"\" }')"

echo "---"
echo "Loan"

python3 -c "\
print(f'Bought: {$BOUGHT:,.2f} ꜩ')"
python3 -c "\
value=$BOUGHT*$EUR;
print(f'Value: {value:,.2f} €')"
python3 -c "\
value=$BOUGHT*$USD;
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
diff=(value-debt)*($EUR/$USD);
print(f'{\"Profit\" if diff >= 0 else \"Loss\"}: {diff:,.2f} € | color={\"darkgreen,green\" if diff >= 0 else \"darkred,red\"}')"
python3 -c "\
value=($BOUGHT*$USD);
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
percentage=value/debt*100-100;
print(f'Percentage: {percentage:,.2f} % | color={\"darkgreen,green\" if percentage >= 0 else \"darkred,red\"}')"

echo "---"
echo "Risk"

python3 -c "\
price=$USD;
print(f'Price: {price:,.2f} $')"
python3 -c "\
xtz=($OVEN/10**6);
value=($OVEN/10**6*$USD);
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
price=(2*debt/xtz);
margin=$USD-price;
percentage=(debt/(value/2))*100;
print(f'Margin: {margin:,.2f} $ | {\"color=darkgreen,green\" if percentage <= 40 else \"color=darkorange,orange\" if 60 <= percentage < 80 else \"color=darkred,red\" if percentage >= 80 else \"\" }')"
python3 -c "\
xtz=($OVEN/10**6);
debt=$KOLIBRI_INTEREST*10**18/$OVEN_INTEREST*($KUSD+$OVEN_FEE)/10**36;
price=(2*debt/xtz);
print(f'Liquidation: {price:,.2f} $')"
