class Hound1 : MarathonActor
{
    Default
    {
        scale 0.3125; //with proper scale it should probably be 0.375 vertical due to the vertical warp
        //$Title "Hound Minor"
        //$Angled
        //$Category "Marathon Monsters"
        MONSTER;
        +FLOAT;
        +NOGRAVITY;
        +DONTGIB;
        +NOSPLASHALERT;
        health 1;
        radius 13;
        height 16;
        mass 100;
        speed 8;
        painchance 200;
        seesound "HOUNDSEE";
        attacksound "";
        painsound "";
        deathsound "HOUNDDIE";
        activesound "";
        scale 0.5;
        //YScale 0.5;
        BloodColor "Yellow";
        Translation "48:63=[255,231,22]:[20,18,2]", "64:79=[179,110,26]:[14,8,2]", "80:95=[240,240,240]:[15,15,15]", "96:111=[193,198,234]:[15,15,15]", "128:135=[255,211,155]:[129,85,33]", "136:143=[116,76,30]:[22,14,6]", "144:151=[97,137,97]:[46,71,46]", "152:159=[41,63,41]:[7,10,7]", "32:47=[255,0,18]:[20,0,1]", "176:191=[255,0,18]:[20,0,1]";
    }

    States
    {
        Spawn:
            HOUN A 10 A_Look;
            Loop;
        See:
            HOUN A 0 TargetPlayerAllies();
            HOUN AABB 3 A_Chase;
            Loop;
        Pain:
            HOUN A 3;
            HOUN A 3 A_Pain;
            goto See;
        Melee:
            HOUN A 3 A_FaceTarget;
            HOUN A 1 A_Die;
            Goto See;
        Death:
            // TNT1 A 0 A_SpawnItem("HoundBBoom");
            HOUN C 0 Bright A_Explode(64,64);
			HOUN C 5 Bright A_Scream;
			HOUN DEF 5 Bright A_NoGravity;
			Stop;
    }
}

class Hound2 : Hound1
{
    Default
    {
        //$Title "Hound Major"
        health 1;
        Translation "48:63=[57,228,139]:[2,15,8]", "64:71=[255,211,155]:[129,85,33]", "71:79=[116,76,30]:[22,14,6]", "96:111=[240,240,240]:[15,15,15]", "80:95=[193,198,234]:[15,15,15]", "128:135=[255,211,155]:[129,85,33]", "136:143=[116,76,30]:[22,14,6]", "144:151=[199,171,155]:[107,79,75]", "152:159=[107,79,75]:[19,11,11]", "32:47=[161,0,100]:[20,0,1]", "176:191=[161,0,100]:[20,0,1]";
    }
}
