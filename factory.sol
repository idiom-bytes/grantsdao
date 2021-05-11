// TODO - Implement validator (I.e. Multisig that authorizes Grant KPI updates)
// struct Validator {
//  byte32 name;
// }
// mapping(address => Validator) public validators;
contract GrantFactory {
    event GrantCreated(address grant, address owner, bytes32 name, bytes32 kpi, uint target, uint balance, uint expiration);
    
    address public owner;
    mapping(address => Grant) public getGrant;
    address[] public allGrants;
    
    constructor(address _owner) public {
        owner = _owner;
    }
    
    function createGrant(address grantOwner, bytes32 name, bytes32 kpi, uint balance, uint target) external returns (address grant) {
        require(msg.sender == owner, 'DAO: Only owner');
        
        bytes memory bytecode = type(Grant).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(grantOwner, grantName));
        assembly {
            grant := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IGrant(grant).initialize(grantOwner, grantName, kpi, kpiTarget);
        
        getGrant[grant] = grant;
        allGrants.push(grant);
        emit GrantCreated(grant, grantOwner, name, kpi, target, balance, IGrant(grant).getExpiration() );
    }
}
