class UprightWaste : Actor
{
    Default
    {
        //$Title "Upright Waste"
        //$Category "Marathon Objects"
        +SOLID;
        Radius 16;
        Height 48;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
        BARL A -1;
        Stop;
    }
}
class SidewaysWaste : Actor
{
    Default
    {
        //$Title "Sideways Waste"
        //$Category "Marathon Objects"
        Radius 24;
        Height 32;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
        BARL B -1;
        Stop;
    }
}

class UprightCylinder : Actor
{
    Default
    {
        //$Title "Upright Cylinder"
        //$Category "Marathon Objects"
        Radius 8;
        Height 48;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
        POLE A -1;
        Stop;
    }
}

class SidewaysCylinder : Actor
{
    Default
    {
        //$Title "Sideways Cylinder"
        //$Category "Marathon Objects"
        Radius 24;
        Height 20;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
        POLE B -1;
        Stop;
    }
}

class Paper : Actor
{
    Default
    {
        //$Title "Paper"
        //$Category "Marathon Objects"
        Radius 1;
        Height 1;
        -SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            PAPR A 0;
            PAPR A 0 A_Jump(192,"Spawn2","Spawn3");
            PAPR A -1;
            Stop;
        Spawn2:
            PAPR B -1;
            Stop;
        Spawn3:
            PAPR C -1;
            Stop;
    }
}

// class TornPaper : Actor
// {
//     Default
//     {
//         Radius 1;
//         Height 1;
//         -SOLID;
//         scale 0.5;
//         //YScale 0.5;
//     }

//     States
//     {
//         Spawn:
//             PAPR A -1;
//             Stop;
//     }
// }

// class MultiplePaper : Actor
// {
//     Default
//     {
//         Radius 1;
//         Height 1;
//         -SOLID;
//         scale 0.5;
//         //YScale 0.5
//     }

//     States
//     {
//         Spawn:
//             PAPR A -1;
//             Stop;
//     }
// }

class SatelliteDish : Actor
{
    Default
    {
        //$Title "Satellite Dish"
        //$Category "Marathon Objects"
        Radius 48;
        Height 96;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            DISH A -1;
            Stop;
    }
}

class EscapePod : Actor
{
    Default
    {
        //$Title "Mirata"
        //$Category "Marathon Objects"
        Radius 24;
        Height 104;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            EPOD A -1;
            Stop;
    }
}

class BioCrate : Actor
{
    Default
    {
        //$Title "Bio Crate"
        //$Category "Marathon Objects"
        Radius 16;
        Height 32;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
        POWR A -1;
        Stop;
    }
}

class PfhorMotherShip : Actor
{
    Default
    {
        //$Title "Pfhor Ship"
        //$Category "Pfhor Objects"
        Radius 1;
        Height 1;
        -SOLID; // skybox item
        +NOGRAVITY;
        Scale 0.5;
    }

    States
    {
        Spawn:
            SHIP B -1 Bright;
            Stop;
    }
}

class HangingBobGutted : Actor
{
    Default
    {
        //$Title "Disected Bob"
        //$Category "Pfhor Objects"
        Radius 16;
        Height 24;
        +SOLID;
        +NOGRAVITY;
        +SPAWNCEILING;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            HANG A -1;
            Stop;
    }
}

class PfhorEgg : Actor
{
    Default
    {
        //$Title "Pfhor Egg"
        //$Category "Pfhor Objects"
        Radius 16;
        Height 48;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            PEGG A -1;
            Stop;
    }
}

class InactiveHunter : Actor
{
    Default
    {
        //$Title "Hunter Armor"
        //$Category "Pfhor Objects"
        Radius 16;
        Height 56;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            INAC A -1;
            Stop;
    }
}

class BobExperiment : Actor
{
    Default
    {
        //$Title "Examination Bob"
        //$Category "Pfhor Objects"
        Radius 1;
        Height 1;
        -SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            EXPR A -1;
            Stop;
    }
}

class OrbWithLights : Actor
{
    Default
    {
        //$Title "Electrosynth"
        //$Category "Pfhor Objects"
        Radius 1;
        Height 1;
        -SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            PORB A -1;
            Stop;
    }
}

class BlackOrb : Actor
{
    Default
    {
        //$Title "Orb"
        //$Category "Pfhor Objects"
        Radius 6;
        Height 12;
        +SOLID;
        scale 0.5;
        //YScale 0.5;
    }

    States
    {
        Spawn:
            PORB B -1;
            Stop;
    }
}

class TheMarathon : Actor
{
    Default
    {
        //$Title "The Marathon"
        //$Category "Pfhor Objects"
        Radius 1;
        Height 1;
        -SOLID; // skybox item
        +NOGRAVITY;
        Scale 0.5;
    }

    States
    {
        Spawn:
            SHIP A -1 Bright;
            Stop;
    }
}

class PfhorCargoShip : Actor
{
    Default
    {
        //$Title "Alien Ship"
        //$Category "Pfhor Objects"
        Radius 1;
        Height 1;
        -SOLID; // skybox item
        +NOGRAVITY;
        Scale 0.5;
    }

    States
    {
        Spawn:
            SHIP C -1 Bright;
            Stop;
    }
}

class DeadBob1 : Actor
{
    Default
    {
        //$Title "Dead Bob Crew"
        //$Category "Marathon Objects"
        -SOLID;
        radius 12;
        height 56;
        mass 100;
        scale 0.5;
        //YScale 0.5;
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[0,255,0]:[0,20,0]";
    }

    States
    {
        Spawn:
            BOBB I -1;
            Stop;
    }
}

class DeadBob2 : DeadBoB1
{
    Default
    {
        //$Title "Dead Bob Science"
        //$Category "Marathon Objects"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[0,176,201]:[0,30,34]";
    }
}

class DeadBob3 : DeadBoB1
{
    Default
    {
        //$Title "Dead Bob Security"
        //$Category "Marathon Objects"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[246,37,0]:[36,5,0]";
    }
}

class DeadBob4 : DeadBoB1
{
    Default
    {
        //$Title "Dead Bob Engineering"
        //$Category "Marathon Objects"
        Translation "64:79=[149,76,46]:[31,19,19]", "112:127=[255,231,22]:[21,19,0]";
    }
}