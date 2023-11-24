# Internal Wallet Transactional System API

## About
Internal Wallet Transactional System API

## Installation

1. For docker use
+ Install docker compose and docker engine https://docs.docker.com/compose/install/

+ Modify docker-compose.override.yml for development environment

+ Build images

```
docker compose build
```

+ Run docker services

```
docker compose up -d
```

+ Check if services running

```
docker compose ps
```

Should return list of running-status containers (services). If any services's with exited status, please check the error by rerun docker compose services as:

```
docker compose up
```
See the logs in the terminal for errors

## Seed Data Test
By default system is generated some seed data for development
i: 0..9
email: "user#{i}@localhost.email", password: "Aa@123456"

## Usage

API endpoint:
ACTION | Endpoint                           | Parameters
-------------------------------------------------------------------------------------------------
POST    /api/v1/login                       | body params: { "user": { "email": "user8@localhost.email", "password": "Aa@123456" } }

DELETE  /api/v1/logout                      | <none>

GET     /api/v1/users/:user_id/wallets      | query params: user_id

GET     /api/v1/wallets/:wallet_id/balances | query params: wallet_id

GET     /api/v1/wallets/:wallet_id/transaction_statuses | query params: wallet_id, job_id

POST    /api/v1/wallets/:wallet_id/deposits | query params: wallet_id; body params: { "amount": 215.5555 }

POST   /api/v1/wallets/:wallet_id/withdrawals | query params: wallet_id; body params: { "amount": 215.5555 }

POST    /api/v1/wallets/:wallet_id/transfers | query params: wallet_id; body params: {"amount": 25.5, "target_wallet_id": "082cafe4-96e6-477d-946b-eb6999a4f8ae"}


