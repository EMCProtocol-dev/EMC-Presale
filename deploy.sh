dfx deploy --network test emc_presale --argument="(\"br5f7-7uaaa-aaaaa-qaaca-cai\")"

dfx canister  call --network test emc_presale balanceOf "(principal \"b77ix-eeaaa-aaaaa-qaada-cai\")" 

dfx canister  call --network test emc_presale saleTo "(record{chainID = 98:nat; chainName=\"Polygon\"; txnID=\"facketxnIDxxxxxxxxxxx\"; emcReceiver=principal \"bwosr-ydysf-xl5um-oot3j-v5keg-d2pge-7a6zd-qfi5l-gmchj-z72d3-kqe\"; emcAmount=10000000000:nat})" 

dfx canister  call --network test emc_presale saleTo "(record{chainID = 98:nat; chainName=\"Polygon\"; txnID=\"facketxnIDxxxxxxxxxxx\"; emcReceiver=principal \"4oafp-qx7h6-x4ble-gbmam-25cu2-nbemp-6ycel-n2upw-7754w-rd5id-6qe\"; emcAmount=10000000000:nat})" 

dfx canister  call --network test emc_presale getOwner


dfx canister  call --network test emc_presale withdrawTo "(principal \"sktsg-s43ta-fpvji-e35m3-5muep-dfkux-mlws2-wxzq3-otn7i-33uka-yqe\")"

dfx canister  call --network test emc_presale presaleEMCTransferID "(record{chainID = 98:nat; chainName=\"Polygon\"; txnID=\"facketxnIDxxxxxxxxxxx\"; emcReceiver=principal \"4oafp-qx7h6-x4ble-gbmam-25cu2-nbemp-6ycel-n2upw-7754w-rd5id-6qe\"; emcAmount=10000000000:nat})" 



#deploy on IC

dfx identity use emc-developer-eric

dfx canister create emc_presale --network ic
#emc_presale canister created on network ic with canister id: bvojc-yyaaa-aaaam-abm6a-cai

dfx build --network ic

dfx deploy --network ic emc_presale --argument="(\"aeex5-aqaaa-aaaam-abm3q-cai\")"
#emc_presale: https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=bvojc-yyaaa-aaaam-abm6a-cai


#chain IDs
# IPC 10000
