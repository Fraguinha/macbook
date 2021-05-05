#!/usr/local/bin/python3

import requests
from pytezos import pytezos

pytezos = pytezos.using(shell='mainnet')

# contracts
kolibri = pytezos.contract('KT1Ty2uAmF5JxWyeGrVpk17MEyzVB8cXs8aJ')
oven = pytezos.contract('KT1AKcRY2F8uZv5psx2gUm7AoTk8Cp6ei4hM')

data = dict()


def get_data():
  # kolibri
  data['kolibri_storage'] = kolibri.using(block_id='head').storage()

  # storage
  data['kolibri_stability_fee'] = float(
      data['kolibri_storage']['stabilityFee'])
  data['kolibri_interest_index'] = float(
      data['kolibri_storage']['interestIndex'])

  # oven
  data['oven_context'] = oven.using(block_id='head').context
  data['oven_storage'] = oven.using(block_id='head').storage()

  # storage
  data['oven_balance'] = float(data['oven_context'].get_balance() / 10**6)
  data['oven_fee'] = float(data['oven_storage']['stabilityFeeTokens'])
  data['oven_interest_index'] = float(data['oven_storage']['interestIndex'])
  data['oven_borrowed_tokens'] = float(data['oven_storage']['borrowedTokens'])


def get_price(currency):
  coingecko = requests.get(
      'https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=' + currency).json()
  price = float(coingecko['tezos'][currency])
  return price


def get_rate():
  if not data:
    get_data()
  initial = data['kolibri_stability_fee'] / 10**18 + 1
  apr = 1
  for _ in range(365 * 24 * 60):
    apr = apr * initial
  apr = (apr - 1) * 100
  return apr


def get_debt():
  if not data:
    get_data()
  debt = (data['kolibri_interest_index'] * 10**18 / data['oven_interest_index'] *
          (data['oven_borrowed_tokens'] + data['oven_fee']) / 10**18) / 10**18
  return debt


def get_interest():
  if not data:
    get_data()
  interest = (data['kolibri_interest_index'] * 10**18 / data['oven_interest_index'] *
              (data['oven_borrowed_tokens'] + data['oven_fee']) / 10**18 - data['oven_borrowed_tokens']) / 10**18
  return interest


def get_borrowed():
  if not data:
    get_data()
  borrowed = data['oven_borrowed_tokens'] / 10**18
  return borrowed


def get_collateral():
  if not data:
    get_data()
  value = data['oven_balance'] * get_price('usd')
  percentage = get_debt() / (value / 2) * 100
  return percentage


def get_liquidation():
  if not data:
    get_data()
  liquidation = (2 * get_debt() / data['oven_balance'])
  return liquidation


def get_margin():
  if not data:
    get_data()
  margin = get_price('usd') - get_liquidation()
  return margin


if __name__ == '__main__':
  print(f'rate : {get_rate():,.2f} %')
  print(f'debt : {get_debt():,.2f} $')
  print(f'interest : {get_interest():,.2f} $')
  print(f'borrowed : {get_borrowed():,.2f} $')
  print(f'collateral : {get_collateral():,.2f} %')
  print(f'price : {get_price("usd"):,.2f} $')
  print(f'margin : {get_margin():,.2f} $')
  print(f'liquidation : {get_liquidation():,.2f} $')
