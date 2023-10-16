#!/usr/bin/env python3

import os
from datetime import datetime

import grequests
from dateutil import relativedelta

# Secrets

with open(f'{os.environ["HOME"]}/.secret.conf', "r") as f:
    secret = f.read().strip().split("\n")
    secret = [var for var in secret if var and var[0] != "#"]
    secret = [var.split("=") for var in secret]
    SECRET = {x: y[1:-1] for x, y in secret}

# Constants

TEZOS_DECIMALS = 10**6
TZBTC_DECIMALS = 10**8

try:
    # API Calls

    urls = [
        # fng
        "https://api.alternative.me/fng/",
        # quotes
        "https://api.tzkt.io/v1/quotes/last",
        # wallet
        f'https://api.tzkt.io/v1/accounts/{SECRET["TEZOS_ADDRESS"]}',
        # lb
        "https://api.tzkt.io/v1/contracts/KT1TxqZ8QtKvLu3V3JH7Gx58n7Co8pgtpQU5/storage",
    ]

    requests = (grequests.get(url) for url in urls)
    results = [res.json() for res in grequests.map(requests)]

    [fng, quotes, wallet, lb] = results

    # Investment Durations

    now = datetime.now()

    investment_start = datetime.strptime(SECRET["TEZOS_DATE"], "%d/%m/%Y")

    investment_duration = relativedelta.relativedelta(now, investment_start)
    investment_days = (now - investment_start).days

    # Exchange Rates

    eur_in_usd = 1 / quotes["eur"] * quotes["usd"]
    usd_in_eur = 1 / quotes["usd"] * quotes["eur"]

    # Crypto Prices

    xtz_in_btc = round(
        (int(lb["tokenPool"]) / TZBTC_DECIMALS) / (int(lb["xtzPool"]) / TEZOS_DECIMALS),
        TZBTC_DECIMALS,
    )
    btc_in_xtz = 1 / xtz_in_btc

    btc_in_usd = btc_in_xtz * quotes["usd"]
    btc_in_eur = btc_in_xtz * quotes["eur"]

    # Assets

    xtz = wallet["balance"]
    wallet_value = xtz / TEZOS_DECIMALS * quotes["eur"]

    # Investment

    total_value = wallet_value

    pnl = total_value - int(SECRET["TEZOS_PRINCIPAL"])
    percentage = pnl / int(SECRET["TEZOS_PRINCIPAL"]) * 100
    yearly = percentage / (investment_days / 365)

    # Output

    print(f'ꜩ : {quotes["eur"]:,.2f} € ({quotes["usd"]:,.2f} $)')
    print("---")
    print("Quotes")
    print(f"Bitcoin: {xtz_in_btc:,.8f} ฿")
    print(f'Ethereum: {quotes["eth"]:,.6f} Ξ')
    print("---")
    print("Statistics")
    print(f'{fng["data"][0]["value_classification"]}: {fng["data"][0]["value"]}')
    print("---")
    print("Wallet")
    print(f'Tezos: {wallet["balance"]/TEZOS_DECIMALS:,.2f} ꜩ')
    print(f"Value: {wallet_value:,.2f} €")
    print("---")
    print("Investment")
    print(f"Value: {total_value:,.2f} €")
    print(f'{"Profit" if pnl >= 0 else "Loss"}: {pnl:,.2f} €')
    print(f"Percent: {percentage:,.2f} %")
    print(f"Yearly: {yearly:,.2f} %")
    print(
        f"Length: {investment_duration.years}y {investment_duration.months}m {investment_duration.days}d"
    )

except Exception as e:
    print(e)
