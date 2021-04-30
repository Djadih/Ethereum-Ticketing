# Ethereum-Ticketing

## Code locations

Smart Contract Repo: 
https://github.com/Djadih/Ethereum-Ticketing

React Frontend Repo: 
https://github.com/gkd248/TicketingPortal

## Code installation

Download both from git

### npm install inside of smart contract repo: 
	npm install

#### Run ganache-cli: 
	ganache-cli

## Running the code

### move to smart contract repo and migrate with truffle: 
	truffle migrate 

Then copy the contract address from console and add it to the frontend in SmartContractABI.js

### move to React frontend and deploy: 
	npm install
	npm start

Copy a private key from ganache-cli console and add this to your Metamask wallet (make sure you are using localhost:8545)

Now the website should be functional and you can create events