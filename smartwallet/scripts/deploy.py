from brownie import *

def main():
    #set up EOA accounts we are using
    deployer_acc = accounts[0]
    successor_acc = accounts[5]

    #deploy smart contract wallet
    active_contract = SmartWallet.deploy(successor_acc, {'from': deployer_acc})

    #test transfer function by adding ETH then transferring to smartwalelt owner
    print("contract balance: {}".format(active_contract.getBalance()))
    accounts[0].transfer(active_contract, "1 ether")
    print("contract balance after deposit: {}".format(active_contract.getBalance()))

    active_contract.withdrawAmount(5e17, {'from': deployer_acc})
    print("contract balance after withdraw: {}".format(active_contract.getBalance()))

    print("~~~~~~~~~~~~~SUCCESS~~~~~~~~~~~~~~")
    return 0




if __name__ == "_main_":
    main()