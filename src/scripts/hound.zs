class Hound1 : MarathonActor
{
    Default
    {
        //marathon scale factor 7
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

class HoundBBoom : Actor
{
    Default
    {
        +EXTREMEDEATH;
        speed 1;
    }

    States
    {
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_Explode(128,128);
            Stop;
    }
}