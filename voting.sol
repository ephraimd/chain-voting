// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "cryptography.sol";
import "conversion.sol";

contract ElectionsEngine {

    struct Candidate {
        string id;
        string name;
        string party;
        uint256 votes;
        uint nonce; //used to check if a voter object is initialised
    }

    struct Election {
        uint256 id;
        string title;
        uint256 votesCasted;
        bool active;
    }

    struct Voter {
        string name;
        address addr;
        bool allowed;
        uint256 votesCasted;
        uint nonce; //used to check if a voter object is initialised
    }

    mapping (uint => Election) public electionsIdMap;
    mapping (address => Voter) public votersAddressMap;
    mapping (uint => mapping (string => Candidate)) public electionCandidatesMap;

    modifier onlyVoter() {
        Voter memory voter = votersAddressMap[msg.sender];
        require(voter.nonce != 0, "This address is not a registered voter"); //uninitialised voter means its non existent
        _;
    }

    modifier onlyAllowedVoter () {
        Voter memory voter = votersAddressMap[msg.sender];
        require(voter.allowed, "This registered voter is currently not allowed to vote");
        _;
    }

    function castVote(uint electionId, string memory candidateId) view  public onlyVoter onlyAllowedVoter returns (bool) {
        Election memory election = electionsIdMap[electionId];
        require(election.id != 0, "No election matches the supplied electionId");

        Candidate memory candidate = electionCandidatesMap[electionId][candidateId];
        require(candidate.nonce != 0, "No candidate with the supplied id has been registered for this election");

        candidate.votes++;
        election.votesCasted++;
        return  true;
    }

    function addVoter(
        string memory voterName,
        bool allowed,
        address addr
    ) public returns (Voter memory) {
        Voter memory voter = Voter({
            name: voterName,
            addr: addr,
            votesCasted: 0,
            allowed: allowed,
            nonce: 1
        });

        votersAddressMap[voter.addr] = voter;
        return voter;
    }
    //652 p, 270 g,

    function addElection(string memory title, bool _active) public returns(Election memory){

        Election memory election = Election({
            id: random(),
            title: title,
            votesCasted: 0,
            active: _active
        });
        
        electionsIdMap[election.id] = election;
        return election;
    }

    function addCandidate(uint electionId, string memory name, string memory party) public returns(Candidate memory){
        //in solidity, repeating code saves money, literally 😅. So follwoing DRY principle may not be a good idea
        require(electionsIdMap[electionId].id != 0, "No election matches the supplied electionId");

        Candidate memory candidate = Candidate({
            id: itoa(random()),
            name: name,
            party: party, 
            votes: 0,
            nonce: 1 
        });

        electionCandidatesMap[electionId][candidate.id] = candidate;
        return candidate;
    }
}
