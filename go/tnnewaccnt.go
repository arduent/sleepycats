package main

import (
    "fmt"
    "os"
    "encoding/json"
    "net/http"

    horizon "github.com/stellar/go/clients/horizonclient"
    "github.com/stellar/go/txnbuild"
    "github.com/stellar/go/keypair"
    "github.com/stellar/go/network"
)

func main() {

    client := horizon.DefaultTestNetClient

    type AccntDetails struct {
        SK string
        PK string
    }

    asset := txnbuild.CreditAsset{Code: "WAGOTOKEN", Issuer: "GAD4PQ2NW2G2FWNC5Y7OT2RABKOFE7DWN7GXQ6GW5CQJVLVINH2LCM6K"}

    kp, _ := keypair.Parse("SBZDGYM4ZVKB5CWAVYFL6ZJGEPP6PUZ5BKM4ZNL73ZCSZO364RDPPLNY")
    A := keypair.MustRandom()
    addressA := A.Address()

    resp, err := http.Get("https://friendbot.stellar.org/?addr=" + addressA)
    if err != nil {
	fmt.Println(err)
	os.Exit(0)
    }
    resp.Body.Close()

    ar := horizon.AccountRequest{AccountID: kp.Address()}
    srcAccount,err := client.AccountDetail(ar)
    if err != nil {
        fmt.Println(err)
        os.Exit(0)
    }

    aAccount,err := client.AccountDetail(horizon.AccountRequest{AccountID: addressA})
    if err != nil {
        fmt.Println(err)
        os.Exit(0)
    }

    beginTransaction := txnbuild.BeginSponsoringFutureReserves{
        SourceAccount: &srcAccount,
        SponsoredID:   addressA,
    }
    changeTrust := txnbuild.ChangeTrust{
        Line:  &asset,
        Limit: txnbuild.MaxTrustlineLimit,
    }
    endTransaction := txnbuild.EndSponsoringFutureReserves{}

    tx, err := txnbuild.NewTransaction(
        txnbuild.TransactionParams{
            SourceAccount:        &aAccount,
            IncrementSequenceNum: true,
            Operations:           []txnbuild.Operation{&beginTransaction,&changeTrust,&endTransaction},
            BaseFee:              txnbuild.MinBaseFee,
            Timebounds:           txnbuild.NewInfiniteTimeout(),
        },
    )

    tx, err = tx.Sign(network.TestNetworkPassphrase, A)

    if err != nil {
        if prob := horizon.GetError(err); prob != nil {
            fmt.Printf("  problem: %s\n", prob.Problem.Detail)
            fmt.Printf("  extras: %s\n", prob.Problem.Extras["result_codes"])
        }
    }

    if err != nil {
        os.Exit(0)
    }

    tx, err = tx.Sign(network.TestNetworkPassphrase, kp.(*keypair.Full)) 

    if err != nil {
	fmt.Println("sig2")
	fmt.Println(err) 
        os.Exit(0) 
    } 

    _, clierr := client.SubmitTransaction(tx)

    if clierr != nil {
        fmt.Println(clierr)
	os.Exit(0)
    }

    det := AccntDetails{
        SK: A.Seed(),
	PK: addressA,
    }

    prettyJSON, _ := json.MarshalIndent(det,"","    ")
    fmt.Printf("%s\n",string(prettyJSON))

}

