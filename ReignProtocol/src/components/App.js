import React, { Component } from 'react'
import Web3 from 'web3'
import USH from '../abis/USH.json'
import ReignCoin from '../abis/ReignCoin.json'
import ReignCoin from '../abis/ReignCoin.json'
import Navbar from './Navbar'
import Main from './Main'
import './App.css'

class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadBlockchainData() {
    const web3 = window.web3

    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    const networkId = await web3.eth.net.getId()


   // Load USH
    const USHData = USH.networks[networkId]
    if(USHData) {
      const USH = new web3.eth.Contract(USH.abi, USHData.address)
      this.setState({ USH })
      let USHBalance = await USH.methods.balanceOf(this.state.account).call()
      this.setState({ USHBalance: USHBalance.toString() })
      
    } else {
      window.alert('USH contract not deployed to detected network.')
    }

    // Load ReignCoin
    const ReignCoinData = ReignCoin.networks[networkId]
    if(ReignCoinData) {
      const ReignCoin = new web3.eth.Contract(ReignCoin.abi, ReignCoinData.address)
      this.setState({ ReignCoin })
      let ReignCoinBalance = await ReignCoin.methods.balanceOf(this.state.account).call()
      this.setState({ ReignCoinBalance: ReignCoinBalance.toString() })
    } else {
      window.alert('ReignCoin contract not deployed to detected network.')
    }

    // Load ReignCoin
    const ReignCoinData = ReignCoin.networks[networkId]
    if(ReignCoinData) {
      const ReignCoin = new web3.eth.Contract(ReignCoin.abi, ReignCoinData.address)
      this.setState({ ReignCoin })
      let stakedAmount = await ReignCoin.methods.stakedAmount(this.state.account).call()
      this.setState({ stakedAmount: stakedAmount.toString() })
      
    } else {
      window.alert('ReignCoin contract not deployed to detected network.')
    }

    this.setState({ loading: false })

  }  

    


  




  
    
  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

//Stake function
stake = (amount) => {
  this.setState({ loading: true })
  this.state.USH.methods.approve(this.state.ReignCoin._address, amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
    this.state.ReignCoin.methods.stake(amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
      this.setState({ loading: false })
    })
  })
}


//Redeem function
 redeem = (amount) => {
   this.setState({ loading: true })
    this.state.ReignCoin.methods.redeem(amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
      this.setState({ loading: false })
    })
  }
  


  constructor(props) {
    super(props)
    this.state = {
      account: '0x0',
      USH: {},
      ReignCoin: {},
      ReignCoin: {},
      USHBalance: '0',
      ReignCoinBalance: '0',
      stakedAmount: '0',
      loading: true
    }
  }

  render() {
    let content
    if(this.state.loading) {
      content = <p id="loader" className="text-center">Loading...</p>
    } else {
      content = <Main
        USHBalance={this.state.USHBalance}
        ReignCoinBalance={this.state.ReignCoinBalance}
        stakedAmount={this.state.stakedAmount}
        stake={this.stake}
        redeem={this.redeem}
      />
    }

    return (
      <div>
        <Navbar account={this.state.account} />
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 ml-auto mr-auto" style={{ maxWidth: '600px' }}>
              <div className="content mr-auto ml-auto">
                <a
                  href="#"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                </a>

                {content}

              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
