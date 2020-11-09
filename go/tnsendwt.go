package main

import (
    "fmt"
    "os"

    horizon "github.com/stellar/go/clients/horizonclient"
    "github.com/stellar/go/txnbuild"
    "github.com/stellar/go/keypair"
    "github.com/stellar/go/network"
)

func main() {

    arg := os.Args[1]
    amt := os.Args[2]
    
    client := horizon.DefaultTestNetClient

    kp, _ := keypair.Parse("SBZDGYM4ZVKB5CWAVYFL6ZJGEPP6PUZ5BKM4ZNL73ZCSZO364RDPPLNY")
    ar := horizon.AccountRequest{AccountID: kp.Address()}

    sourceAccount, err := client.AccountDetail(ar)
    if err != nil {
	os.Exit(0)
    }

    pop := txnbuild.Payment{
        Destination: arg,
        Amount:      amt,
        Asset:       txnbuild.CreditAsset{"WAGOTOKEN","GAD4PQ2NW2G2FWNC5Y7OT2RABKOFE7DWN7GXQ6GW5CQJVLVINH2LCM6K"},
    }

    ptx, err := txnbuild.NewTransaction(                                               
        txnbuild.TransactionParams{                                                   
            SourceAccount:        &sourceAccount,                                     
            IncrementSequenceNum: true,                                               
            Operations:           []txnbuild.Operation{&pop},                          
            BaseFee:              txnbuild.MinBaseFee,                                
            Timebounds:           txnbuild.NewInfiniteTimeout(),                      
        },                                                                            
    )                                                                                 
                                                                                      
    if err != nil {                                             
        os.Exit(0)                                          
    }                                                           
                                                                
    ptx, err = ptx.Sign(network.TestNetworkPassphrase, kp.(*keypair.Full))
                                                                          
    if err != nil {                                                       
        os.Exit(0)                                                        
    }                                                                     

    presult, err := client.SubmitTransaction(ptx)                                                                   
    if err != nil {                                                                                               
        fmt.Println(err)                                                                                          
		if herr2, ok := err.(*horizon.Error); ok {
			fmt.Println("Error has additional info")
			fmt.Println(herr2.ResultCodes())
			fmt.Println(herr2.ResultString())
			fmt.Println(herr2.Problem)
		}

    }                                                                                                             
                                                                                                                  
    fmt.Println(presult) 
                                                                
    ptxe, err := ptx.Base64()                                               
    fmt.Println(ptxe) 

}

