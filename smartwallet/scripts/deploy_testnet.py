from brownie import *

def main():
    #set up EOA accounts we are using
    deployer_acc = accounts.load("mumbai_bogota")

    #deploy smart contract wallet
    deployed_contract = SmartWallet.deploy(deployer_acc, {'from': deployer_acc})

    #deployed_contract = SmartWallet.at("0x4EacCF9900AEA894b9c8C8E745C965dc59c8D525")

    request_id = deployed_contract.TRANSFER_REQUEST_ID()
    request_queries = deployed_contract.requestQueries(request_id)

    print(request_queries)
    validatorAdress = "0xb1e86C4c687B85520eF4fd2a0d14e81970a15aFB"
    circuit_id = "credentialAtomicQuerySig"
    value_array = [0]*64
    value_array[0] = 1
    print(value_array)


    query_as_dict = {"schema" : 226278358248531717314681006190884971985,
                     "slotIndex": 1,
                     "operator": 1,
                     "value": value_array,
                     "circuitId": circuit_id,
                     }
    query_as_list = [226278358248531717314681006190884971985, 1, 1, value_array, circuit_id]
    
    deployed_contract.setZKPRequest(request_id, validatorAdress, query_as_list, {'from': deployer_acc})

    return




if __name__ == "_main_":
    main()