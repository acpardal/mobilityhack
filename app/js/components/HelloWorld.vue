<template>

  <div class="hello">
    <h3>Welcome to Embark!</h3>
    <div id="queryBalance">
      <h3>Create Vehicle with VIN</h3>
      <input placeholder="enter VIN: e.g 0x123" v-model="VIN"/>
      <button @click="createVehicle(VIN)">Create Vehicle</button>
      <div class="result">{{result}}</div>
    </div>
  </div>
</template>

<script>

import VehicleFactory from 'Embark/contracts/VehicleFactory';
import Vehicle from 'Embark/contracts/Vehicle';

export default {
  name: 'HelloWorld',
  data () {
    return {
      VIN: undefined,
      result: undefined,
      userAddress: undefined
    }
  },
  created() {
    EmbarkJS.onReady((error) => {
      if (error) {
        console.error('Error while connecting to web3', error);
        return;
      }
      web3.eth.getAccounts((err, accounts) => {
        this.userAddress = accounts[0];
      });
    });
  },
  methods: {
    createVehicle(newVIN) {
      let {userAddress} = this;
      VehicleFactory.methods.createVehicle(newVIN, [1,2], 'black', userAddress)
      .send({from: ''+userAddress, gas:5000000})
      .on('receipt', (receipt) => {

          VehicleFactory.methods._ownersToVehicles(userAddress).call().then(vehicleAddress=>{
            Vehicle.options.address = vehicleAddress;
            Vehicle.methods._VIN().call().then((value) => {
              this.result = value;
            })
          })
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
