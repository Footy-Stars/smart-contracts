<<<<<<< Updated upstream
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
=======
// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
>>>>>>> Stashed changes

import {Script, console2} from "forge-std/Script.sol";
import {MatchMaking} from "../src/MatchMaking.sol";
import {PlayerConfig} from "../src/PlayerConfig.sol";
import {Halo2Verifier} from "../src/Verifier.sol";

contract DeployScript is Script {
    MatchMaking mmContract;
    PlayerConfig pcContract;
    Halo2Verifier verifierContract;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        mmContract = new MatchMaking();
        // mmContract = MatchMaking(0x62125dB2DA783f390CcE30cc354f97c316C62208);
        // mmContract.quickMatch{value: 100}();
        // vm.stopBroadcast();
        // vm.startBroadcast(vm.envUint("PRIVATE_KEY2"));
        // mmContract.quickMatch{value: 100}();
        // mmContract.finishMatch(4, 2, 5, 5);

        pcContract = new PlayerConfig();
        verifierContract = new Halo2Verifier();

        vm.stopBroadcast();
    }
}
