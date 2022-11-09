const fetch = require('node-fetch');
const globalStep = 100;

const getNumberViewsFor = (contract) => {
  const address = contract.address;
  return fetch("https://api.tzkt.io/v1/contracts/" + address + "/views")
      .then((response) => response.json())
    // filter contracts that has views
    .then((views) => views.length);      
};

const getContracts = (at) =>
  fetch(
    "https://api.tzkt.io/v1/contracts?offset=" + at + "&limit=" + globalStep
  )
    .then((response) => {
      return response.json();
    })
    .then((contracts) => {
      return console.log("get at", at);
      const promises = contracts.map(getNumberViewsFor);
      return Promise.all(promises);
    })
    .then((viewsNumber) => viewsNumber.reduce((a, b) => a + b, 0))
    .catch((error) => {
      console.log(error);
      return 0;
    });

const getContractsAddress = (at) =>
  fetch(
    "https://api.tzkt.io/v1/contracts?offset=" + at + "&limit=" + globalStep
  )
    .then((response) => {
      return response.json();
    })
    .then((contracts) => {
        return contracts.map((c) => {
        // all contracts addresses
        console.log ("all contracts: ")
        return console.log(c.address);
        c.address;
      });
    })
    .catch((error) => {
      console.log(error);
      return 0;
    });

const createRange = (limit) => {
  const result = [];
  let offset = 0;
  const step = globalStep;
  while (offset <= limit + step) {
    result.push(offset);
    offset = offset + step;
  }
  return result;
};

fetch("https:api.tzkt.io/v1/contracts/count")
    .then((response) => response.json())
    .then((limit) => {
        console.log("limit", limit);
        const steps = createRange(limit);
        const promises = steps.map(getContractsAddress);
        return Promise.all(promises);
    })
    .then((address) =>
     // number of addresses of contract has views
     console.log(address.length));