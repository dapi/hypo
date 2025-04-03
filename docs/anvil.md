```
anvil -f https://binance.safeblock.cc --chain-id 56 --accounts 3 --base-fee 0 --auto-impersonate --no-storage-caching --no-rate-limit --disable-default-create2-deployer --no-mining --transaction-block-keeper 64 --prune-history 50 --mnemonic "gate boat total sign print jaguar cache dutch gate universe expect tooth" --port 18545

Флаги:

-f <указать url адрес к ноде (nodex)>
--chain-id выставляется в зависимости от сети

arbitrum - 42161
avalanche - 43114
base - 8453
binance - 56
ethereum - 1
optimism - 10
polygon - 137

--base-fee задает пользователь в интерфейсе, по умолчанию 0
--mnemonic задает пользователь, по умолчанию можешь использовать строку которую я написал
--accounts выбирает пользователь кол-во кошельков которые будут с балансом

Интерфейс пользователя:

- выбор сети которые мы поддерживаем, выпадающий список(обязательное)
- base-fee, комиссия сети, число (по умолчанию 0)
- mnemonic набор слов, возможная длина 12, 15, 18, 21, 24
- accounts кол-во аккаунтов, число, максимум 10, по умолчанию 3, можно установить 0

После создания нужно отобразить список кошельков с балансом, для этого нужно из мнемоники сгенерировать первые Х адресов и приватные ключи (вместо Х кол-во accounts которые указал пользователь)

пример:

Account 0: 
  - Address: 0xE2D71fD4c77693483e1581B02D9e0e5DC7923FF0
  - Private Key: 0x790832408fccbe4fd54fa4b4111149a4cb1a09af25deadbb0c4e6b06305c1fba

Account 1: 
  - Address: 0xE2D71fD4c77693483e1581B02D9e0e5DC7923FF0
  - Private Key: 0x790832408fccbe4fd54fa4b4111149a4cb1a09af25deadbb0c4e6b06305c1fba
```
