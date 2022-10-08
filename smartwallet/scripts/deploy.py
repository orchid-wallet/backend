from brownie import *

def main():
    deployer_acc = accounts[0]

    return SmartWallet.deploy({'from': deployer_acc})




if __name__ == "_main_":
    main()