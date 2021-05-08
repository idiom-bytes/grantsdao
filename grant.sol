pragma solidity >=0.7.0 <0.8.0;

// Grant
// GrantFactory
contract Grant {
    
    event GrantUpdated(address grant);
    event MilestoneReached(address grant);
    event GrantCompleted(address grant);
    event GrantExpired(address grant);

    address owner;
    address[] team;
    byte32 name;
    byte32 kpi;
    uint kpiTarget;
    uint kpiProgress;
    uint256 balance;
    uint tsStart;
    uint tsEnd;

    
    // TODO - Implement variable contract tsLength
    initialize(bytes32 memory grantName, bytes32 memory kpi, uint memory kpiTarget) {
        grants.push(Grant({
            name: grantName,
            kpi: kpi,
            kpiTarget: kpiTarget,
            kpiProgress: 0,
            owner: msg.sender,
            tsStart: now,
            tsEnd: now + (90*24*3600) // 3 months
        }));
        
        emit GrantLaunched();
    }
    
    // TODO - Implement multisig validators "grant oracles"
    function updateKPI(uint memory kDelta) public {
        owner = msg.sender;
        grants[owner]
    }
    
    /// signature methods.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }
}
