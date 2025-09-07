class Hulk1 : MarathonActor
{
    Default
    {
        //marathon scale factor 10
        //$Title "Hulk"
        //$Angled
        //$Category "Marathon Monsters"
        MarathonActor.hurtByLava true;
        MONSTER;
        +NOSPLASHALERT;
        +FLOORCLIP;
        +DONTGIB;
        obituary "%o was squashed by a Hulk.";
        health 1500;
        radius 48;
        height 84;
        mass 1000;
        speed 8;
        painchance 80;
        Translation "201:208=[1,210,230]:[0,83,106]";
        seesound "";
        painsound "";
        deathsound "HULKDEAD";
        activesound "";
        Translation "201:207=[0,176,201]:[0,68,77]", "240:246=[0,54,62]:[0,0,0]";
        BloodColor "00 B0 C9";
        Scale 0.625;
        //YScale 0.75;
        MeleeRange 64;
        DamageFactor "fire", 0.0;
    }

    States
    {
        Spawn:
            HULK A 10 A_Look;
            Loop;
        See:
            HULK A 0 TargetPlayerAllies();
            HULK BBCCDDEE 4 A_Chase;
            Loop;
        Melee:
            HULK F 5 A_FaceTarget;
            HULK F 0 A_StartSound("HULKATTK");
            HULK G 5 A_FaceTarget;
            HULK H 5 A_FaceTarget;
            HULK I 5 A_CustomMeleeattack(random(32,96),"PFHORAT2","NONE","normal",1);
            goto See;
        Pain:
            HULK A 3;
            HULK A 3;
            goto See;
        Death:
            HULK J 12 A_Scream;
            HULK J 1 A_CheckFloor("Death1");
            Wait;
        Death1:
            HULK K 12 A_NoBlocking;
            HULK K 1 A_CheckFloor("Death2");
        Death2:
            HULK L -1 ACS_Execute(779,0,0,0,0);
            Stop;
    }
}
class Hulk2 : Hulk1
{
    Default
    {    
        //$Title "Hulk Major"
        health 2250;
        speed 12;
        BloodColor "39 E4 8B";
        Translation "201:207=[57,228,139]:[8,73,39]", "240:246=[6,59,31]:[0,0,0]", "84:111=80:107", "253:254=[0,0,0]:[208,30,0]", "43:47=[151,22,0]:[18,2,0]", "112:127=[0,176,201]:[0,0,0]";
    }

    States
    {
        Melee:
            HULK F 5 A_FaceTarget;
            HULK F 0 A_StartSound("HULKATTK");
            HULK G 5 A_FaceTarget;
            HULK H 5 A_FaceTarget;
            HULK I 5 A_CustomMeleeattack(random(48,144),"PFHORAT2","NONE","normal",1);
            goto See;
    }
}