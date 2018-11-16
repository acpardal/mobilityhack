pragma solidity ^0.4.23;
import "./Vehicle.sol";

contract owned {
    constructor() { owner = msg.sender; }
    address owner;

    modifier onlyOwner() { // Modifier
        require(
            msg.sender == owner,
            "Only owner can call this."
        );
        _;
    }
}

contract VehicleFactory is owned {

    event Transfer(address indexed from, address indexed to, address vehicle);

    mapping(address => address) public _vehiclesToOwners;
    mapping(address => address) public _ownersToVehicles;

    function createVehicle(uint VIN, uint[] vehicleParts, string color, address to) public onlyOwner returns (address vehicle) {
        address vehicleAdd = new Vehicle(VIN, vehicleParts, color, to);
        _vehiclesToOwners[vehicleAdd] = to;
        _ownersToVehicles[to] = vehicleAdd;
        return vehicleAdd;
    }

    function transfer(address to) public returns (bool ok) {
        require(_ownersToVehicles[to] != address(0), "to already has a vehicle");
        address vehicle = _ownersToVehicles[msg.sender];
        _ownersToVehicles[msg.sender] = address(0);
        _ownersToVehicles[to] = vehicle;
        emit Transfer(msg.sender, to, vehicle);
        return true;
    }
}