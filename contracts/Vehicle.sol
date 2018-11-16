contract Vehicle {
    uint public _VIN;
    uint[] _vehicleParts;
    string _color;
    address _owner;

    constructor (uint VIN, uint[] vehicleParts, string color, address owner) public {
        _VIN = VIN;
        _vehicleParts = vehicleParts;
        _color = color;
        _owner = owner;
    }

}