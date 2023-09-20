// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract decentralizedIdentity {
    struct Identity {
        address userAddress;
        string name;
        uint256 birthdate;
        string publicKey; 
        address[] verifiers;
        address[] issuers;
        bool isVerified;
        bool isIssued;
    }

    mapping(address => Identity) public identities;

    modifier onlyUser() {
        require(identities[msg.sender].userAddress == msg.sender, "Only the user can perform this action");
        _;
    }

    modifier onlyVerifier() {
        require(isVerifier(msg.sender), "Only verifiers can perform this action");
        _;
    }

    modifier onlyIssuer() {
        require(isIssuer(msg.sender), "Only issuers can perform this action");
        _;
    }

    function createIdentity(string memory _name, uint256 _birthdate, string memory _publicKey) external {
        require(identities[msg.sender].userAddress == address(0), "Identity already exists");
        
        Identity storage newIdentity = identities[msg.sender];
        newIdentity.userAddress = msg.sender;
        newIdentity.name = _name;
        newIdentity.birthdate = _birthdate;
        newIdentity.publicKey = _publicKey;
    }

    function addVerifier(address _verifier) external onlyUser {
        identities[msg.sender].verifiers.push(_verifier);
    }

    function removeVerifier(address _verifier) external onlyUser {
        address[] storage verifiers = identities[msg.sender].verifiers;
        for (uint256 i = 0; i < verifiers.length; i++) {
            if (verifiers[i] == _verifier) {
                verifiers[i] = verifiers[verifiers.length - 1];
                verifiers.pop();
                break;
            }
        }
    }

    function addIssuer(address _issuer) external onlyUser {
        identities[msg.sender].issuers.push(_issuer);
    }

    function removeIssuer(address _issuer) external onlyUser {
        address[] storage issuers = identities[msg.sender].issuers;
        for (uint256 i = 0; i < issuers.length; i++) {
            if (issuers[i] == _issuer) {
                issuers[i] = issuers[issuers.length - 1];
                issuers.pop();
                break;
            }
        }
    }

    function verifyIdentity(address _userAddress) external onlyVerifier {
        identities[_userAddress].isVerified = true;
    }

    function issueCredential(address _userAddress) external onlyIssuer {
        identities[_userAddress].isIssued = true;
    }

    function isVerifier(address _address) public view returns (bool) {
        return (identities[_address].userAddress != address(0) && identities[_address].isVerified);
    }

    function isIssuer(address _address) public view returns (bool) {
        return (identities[_address].userAddress != address(0) && identities[_address].isVerified);
    }
}
