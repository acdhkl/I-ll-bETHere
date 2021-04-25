import React, { Component } from "react";
import RSVPContract from "./contracts/RSVP.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = RSVPContract.networks[networkId];
      const instance = new web3.eth.Contract(
        RSVPContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    // Creates an event with given params
    await contract.methods.createEvent("Test Event", "April 24 2020", 100, 500).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.getEventDetails(1).call();

    // Update state with the result.
    this.setState({ event: response });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    console.log(this.state.event)
    if (this.state.event) {

      return( 
      <div>
        <p>Here is the event you just created:</p>
        <p>name: {this.state.event._name}</p>
        <p>Date: {this.state.event._date}</p>
        <p>Price: {this.state.event._price}</p>
        <p>Capacity: {this.state.event._capacity}</p>
      </div>
      );
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
      </div>
    );
    
  }
}

export default App;
