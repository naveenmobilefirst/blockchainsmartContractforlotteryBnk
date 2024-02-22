// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }
    //checking whether use already existed or not
    function alreadyEntered() view private returns(bool){
        for (uint i=0;i<players.length;i++){
            if(players[i]==msg.sender){
                return true;
            }
            return false;
        }
    }
    // checking conditions to enter the lottery
    function enter() payable public {
        require(msg.sender!=manager,"Manager cannot Enter");
        require(alreadyEntered() == false,"Player already entered");
        require(msg.value >=1 ether,"Minimum amount must be payed");
        players.push(payable(msg.sender));
    }

    function random() view private returns(uint) {
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));

    }

    function pickWinner() public {
        require(msg.sender == manager,"Only Manager can pick winner");
        uint index = random()%players.length;// Winner index position
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);
        players = new address payable[](0); 

    }

    function getPlayer() view public returns(address payable[]  memory){
        return players;
    }

}
