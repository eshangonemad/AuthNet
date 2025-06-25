// SPDX-License-Identifier: CC-BY-NC-ND-4.0
// This Solidity code is provided AS-IS without any kind of warranty to the end-user, or any user for that matter. This code should be used only after understanding what it does.
// The Creator of this Solidity code is in no way responsible for any action carried out by the end-user. Any instructions enclosed within the github repository or this code is to be carried out by the user
// only after completely understanding the risks and problems that may be caused by this program/code/script.

// This program is under Copyright protection by the original owner
// Program Authored by
// @eshangonemad -- https://github.com/eshangonemad

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract AuthBlock {
    // Starting a mapping to allow us to link CertID to certification details
    mapping(bytes32 => string) public certsList; 

    function IssueCert(
        address RecipientPAddress,
        string memory IssuerName,
        string memory RecipientName,
        string memory Certname,
        uint256 ExpiryTime
    ) public returns (bytes32) {
        address IssuerPAddress = msg.sender;

        bytes32 hashedCertData = keccak256(
            // We are using block.timestamp to kind of help us generate uniquely identifiying IDs (atleast thats the idea)
            abi.encodePacked(IssuerPAddress, block.timestamp , RecipientPAddress)
        );

        string memory numerica = string(
            abi.encodePacked(
                IssuerName, "!", Strings.toHexString(uint160(IssuerPAddress), 20), "!", Certname,"!",
                RecipientName, "!", Strings.toHexString(uint160(RecipientPAddress), 20), "!",
                Strings.toString(ExpiryTime)
                // Returns string in this following order
                // Issuing Authority ! Issuer Address ! Certification Name ! Recipient Name ! Recipient Address ! Expiry Time
            )
        );

        certsList[hashedCertData] = numerica; 
        return hashedCertData;
    }
    // This function can be launched to get the encoded string that links the CertID to the Certification Details using the pre-declared mapping
    function GetCert(bytes32 CertId) public view returns (string memory) {
        return certsList[CertId]; 
    }
}
