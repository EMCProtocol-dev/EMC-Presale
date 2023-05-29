/**
 * Module     : types.mo
 * Copyright  : 2021 EMC Team
 * License    : Apache 2.0 with LLVM Exception
 * Maintainer : EMC Team <dev@emc.app>
 * Stability  : Experimental
 */

import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Text "mo:base/Text";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import emc_token_dip20 "emc_token_dip20";
import Bool "mo:base/Bool";

shared (msg) actor class EmcPresale(
    token : Text
) = self {

    public type PresaleRecord = {
        chainID : Nat;
        chainName : Text;
        txnID : Text;
        emcReceiver : Principal;
        emcAmount : Nat;
    };

    // returns tx index or error msg
    public type PresaleReceipt = {
        #Ok : Nat;
        #Error : {
            #InsufficientBalance;
            #TransferedAlready;
            #TransferFailed;
        };
    };

    private var owner : Principal = msg.caller;
    private var tokenCanister : emc_token_dip20.Token = actor (token);
    private stable var presaleRecordEntries : [(Text, Nat)] = [];
    private var presaleRecords = HashMap.HashMap<Text, Nat>(1, Text.equal, Text.hash);

    public shared (msg) func saleTo(presaleRecord : PresaleRecord) : async PresaleReceipt {
        assert (msg.caller == owner);
        let presaleText = Nat.toText(presaleRecord.chainID) # presaleRecord.txnID;
        switch (presaleRecords.get(presaleText)) {
            case (?record) {
                return #Error(#TransferedAlready);
            };
            case null {
                //transfer token
                let res = await tokenCanister.transfer(presaleRecord.emcReceiver, presaleRecord.emcAmount);
                switch (res) {
                    case (#Ok(txnID)) {
                        presaleRecords.put(presaleText, txnID);
                        return #Ok(txnID);
                    };
                    case (#Err(#InsufficientBalance)) {
                        return #Error(#InsufficientBalance);
                    };
                    case (#Err(other)) {
                        return #Error(#TransferFailed);
                    };
                };
            };
        };
    };

    public shared (msg) func balanceOf(account : Principal) : async Nat {
        await tokenCanister.balanceOf(account);
    };

    public shared (msg) func selfBalance() : async Nat {
        await tokenCanister.balanceOf(Principal.fromActor(self));
    };

    public shared (msg) func withdrawTo(account : Principal) : async Nat {
        assert (msg.caller == owner);
        let restEMC = await tokenCanister.balanceOf(Principal.fromActor(self));
        let res = await tokenCanister.transfer(account, restEMC);
        switch (res) {
            case (#Ok(txnID)) {
                return restEMC;
            };
            case (#Err(#InsufficientBalance)) {
                return 0;
            };
            case (#Err(other)) {
                return 0;
            };
        };
    };

    public shared query (msg) func getOwner() : async Principal {
        owner;
    };

    public shared query (msg) func presaleEMCTransferID(presaleRecord:PresaleRecord) : async Nat {
        let presaleText = Nat.toText(presaleRecord.chainID) # presaleRecord.txnID;
        switch (presaleRecords.get(presaleText)) {
            case (?txnID) {
                return txnID;
            };
            case null {
                return 0;
            }
        }
    };

    system func preupgrade() {
        presaleRecordEntries := Iter.toArray(presaleRecords.entries());
    };

    system func postupgrade() {
        presaleRecords := HashMap.fromIter<Text, Nat>(presaleRecordEntries.vals(), 1, Text.equal, Text.hash);
        presaleRecordEntries := [];
    };

};
