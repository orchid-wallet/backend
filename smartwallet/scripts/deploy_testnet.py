from brownie import *

def main():
    #set up EOA accounts we are using
    deployer_acc = accounts.load("mumbai_bogota")
    # my mobile dev wallet: 0x2786e104380d5Afb9E964D85F46EB6152Ef7b67E
    successor_acc = "0x2786e104380d5Afb9E964D85F46EB6152Ef7b67E"

    #deploy smart contract wallet
    #vote_threshold = 2
    #deployed_contract = SmartWallet.deploy(successor_acc, vote_threshold, {'from': deployer_acc})


    deployed_contract = SmartWallet.at("0x6Ebe504f7bda4fd60584e0BCA07B4f81b96112a5")

    request_id = deployed_contract.TRANSFER_REQUEST_ID()
    request_queries = deployed_contract.requestQueries(request_id)
    contract_state = deployed_contract.vote_state()
    print(request_queries)
    print("the state is {}".format(contract_state))

    print("the threshold is {}".format(deployed_contract.vote_threshold()))

    validatorAdress = "0xb1e86C4c687B85520eF4fd2a0d14e81970a15aFB"
    circuit_id = "credentialAtomicQuerySig"
    value_array = [0]*64
    value_array[0] = 1
    print(value_array)


    schema_int = 278334752384909982388055862178842950570

    query_as_dict = {"schema" : schema_int,
                     "slotIndex": 2,
                     "operator": 1,
                     "value": value_array,
                     "circuitId": circuit_id,
                     }
    query_as_list = [schema_int, 2, 1, value_array, circuit_id]
    
    #deployed_contract.setZKPRequest(request_id, validatorAdress, query_as_list, {'from': deployer_acc})

    return




if __name__ == "_main_":
    main()