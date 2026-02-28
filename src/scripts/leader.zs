class Leader : MarathonActor
{
    Default
    {
        //marathon scale factor 7
        //$Title "Cyborg Leader"
        //$Angled
        //$Category "Marathon Monsters"
        MONSTER;
        +DONTGIB;
        +NOSPLASHALERT;
        health 100;
        radius 13;
        height 16;
        mass 10000;
        speed 0;
        painchance 200;
        seesound "";
        attacksound "";
        painsound "";
        deathsound "";
        activesound "";
        scale 0.5;
        //YScale 0.5;
        BloodColor "Yellow";
        Translation "96:103=[193,198,234]:[97,99,117]", "104:111=[87,89,104]:[15,15,15]", "128:135=[225,221,195]:[142,137,105]", "136:143=[127,122,94]:[20,20,15]", "32:47=[161,0,100]:[12,0,8]", "176:191=[255,0,0]:[8,8,8]", "48:55=[255,231,22]:[137,124,12]", "56:63=[122,111,11]:[20,18,2]", "64:71=[255,211,155]:[151,99,39]", "72:79=[135,88,35]:[22,14,6]";
    }

    States
    {
        Spawn:
            LEAD A 10 A_Look;
            Loop;
        Pain:
            LEAD B 3 A_Pain;
            goto Spawn;
        Death:
            // TNT1 A 0 A_SpawnItem("HoundBBoom");
			LEAD C 0 A_NoBlocking;
            LEAD CDEF 5;
			LEAD F -1;
            Stop;
    }
}