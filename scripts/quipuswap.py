#!/usr/local/bin/python3

from matplotlib import pyplot as plt
from pytezos import pytezos

pytezos = pytezos.using(shell='mainnet')

contracts = dict(
    kusd=('KT1K4EwTpbvYN9agJdjpyJm4ZZdhpUNKB3F6', 18),
    wrap=('KT1FG63hhFtMEEEtmBSX2vuFmP87t9E7Ab4t', 8)
)

ADDRESS = 0
DECIMALS = 1


def get_price(ticker, block_id='head'):
  contract = pytezos.contract(contracts[ticker][ADDRESS])
  storage = contract.using(block_id=block_id).storage()['storage']
  tezos_pool = float(storage['tez_pool']) / 10 ** 6
  token_pool = float(storage['token_pool']) / 10 ** contracts[ticker][DECIMALS]
  price = tezos_pool / token_pool
  return price


if __name__ == '__main__':
  import sys
  if len(sys.argv) == 1:
    for ticker in contracts:
      price = get_price(ticker)
      print(f'{ticker} : {price:,.2f} ꜩ')
  else:
    ticker = sys.argv[1]
    price = get_price(ticker)
    print(f'{ticker} : {price:,.2f} ꜩ')
