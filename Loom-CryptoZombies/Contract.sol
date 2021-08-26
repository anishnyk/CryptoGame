// Pragma solidity version is mandatory
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    // Events are like triggers - used to denote some action occurrence
    // This can then be listened for and used in front-end app
    event NewZombie(uint zombieId, string name, uint dna);

    // State variables are permanently stored in the blockchain
    // uint - unsigned integer can only take positive values
    // Can they be modified later?
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // Struct is the Solidity eq. of a class
    struct Zombie {

        // Each zombie has a name and a DNA
        string name;
        uint dna;
    }

    // 2 types of arrays - fixed length v/s dynamic length
    // public Arrays get a getter method automatically so other apps can find the value
    Zombie[] public zombies;

    // Function definition to create zombies - eq. to setter method
    // Takes 2 parameters name & dna to set values
    // string paramaters need to be stored in memory and are passed by reference
    // values change as the value changes within the function
    // Same for Structs & arrays
    // Public functions are accessible by any other function in the blockchain v/s private functions only accessible by functions within contract 
    // Note - naming convention of function arguments and private function names
    function _createZombie(string memory _name, uint _dna) private {
        
        // New instance of Zombie struct is being created using arguments to the function
        // The new instance is then pushed to the end of the zombies array 
        // arrays.push returns a uint of the length of the array
        uint id = zombies.push( Zombie(_name, _dna) ) - 1;

        // The event created above is being fired within the function to denote new zombie being created
        emit NewZombie(id, _name, _dna);
    }


    // New function to genereate DNA for zombies being spawned
    // 2 types of functions - view (doesn't change any variable values) v/s pure (might change values but depends on arguments alone)
    // Return type needs to be mentioned in function definition
    function _generateRandomDna(string memory _str) private view returns (uint) {

        // keccak256 hash function used to map a byte to a random 256 bit hexadecimal number
        // encodePacked function used to pack variables to bytes, which is expected by keccak256
        // This then needs to be typecasted to uint from 256-bit hexa
        // DNA needs to be a 16-digit integer - modulus operation takes the right-most 16 digits  
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // Function to create random zombies using the previous private functions and a name string
    // Generates DNA using name and creates zombie using the name and generated DNA
    function createRandomZombie(string memory _name) public {

        uint randDna = _generateRandomDna( _name );
        _createZombie(_name, randDna);
    }

    
}
