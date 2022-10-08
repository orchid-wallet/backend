from brownie import *

def main():
    #set up EOA accounts we are using
    deployer_acc = accounts.load("mumbai_bogota")

    #deploy smart contract wallet
    return SmartWallet.deploy(deployer_acc, {'from': deployer_acc})




if __name__ == "_main_":
    main()