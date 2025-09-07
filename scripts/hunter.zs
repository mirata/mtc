class Hunter1 : MarathonActor
{
    Default
    {
        //marathon scale factor 7
        //$Title "Hunter"
        //$Angled
        //$Category "Marathon Monsters"
        MONSTER;
        +FLOORCLIP;
        +NOBLOOD;
        +DONTGIB;
        +NOSPLASHALERT;
        obituary "%o became a trophy for a hunter.";
        hitobituary "%o became a trophy for a hunter.";
        health 110;
        radius 13;
        height 51;
        mass 1000;
        speed 7;
        painchance 0;
        seesound "SPIDSEE";
        painsound "";
        attacksound "";
        deathsound "HUNTDEAD";
        activesound "PFHOR";
        damagefactor "fire", 0.0;
        scale 0.4375;
        Translation "48:55=[251,175,139]:[189,103,67]", "112:127=[0,255,0]:[0,10,0]", "55:63=[189,103,67]:[30,15,9]", "64:71=[191,123,75]:[119,79,43]", "71:79=[119,79,43]:[43,35,15]", "128:135=[200,172,156]:[110,85,78]", "135:139=[110,85,78]:[79,55,51]", "139:143=[79,55,51]:[19,11,11]", "144:151=[97,137,97]:[46,71,46]", "151:159=[46,71,46]:[7,10,7]", "208:215=[255,231,22]:[152,138,13]", "215:223=[152,138,13]:[35,32,3]", "192:207=[0,149,170]:[0,27,31]", "4:4=[255,231,22]:[255,231,22]";
        //YScale 0.45;
    }

    States
    {
        Spawn:
            HUNT E 10 A_Look;
            Loop;
        See:
            HUNT A 0 TargetPlayerAllies();
            HUNT AABBCCDD 3 A_Chase;
            Loop;
        Missile:
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT E 3;
            goto See;
        Death:
            HUNT H 5 A_FaceTarget;
            HUNT H 1 A_CheckFloor("Death2");
            Wait;
        Death2:
            HUNT I 5 A_NoBlocking;
            HUNT I 1 A_CheckFloor("Death3");
            Wait;
        Death3:
            HUNT J 5;
            HUNT J 1 A_CheckFloor("Death4");
            Wait;
        Death4:
            HUNT K 1 A_Scream;
            HUNT K -1 RemoveOnLava;
            Stop;
        XDeath:
            HUNT H 5 A_FaceTarget;
            HUNT H 1 A_CheckFloor("XDeath2");
            Wait;
        XDeath2:
            HUNT L 0 Bright A_Explode(64,64);
            HUNT L 0 Bright A_StartSound("HUNTBOOM");
            HUNT L 5 Bright A_NoBlocking;
            HUNT L 1 Bright A_CheckFloor("XDeath3");
            Wait;
        XDeath3:
            HUNT M 5 Bright;
            HUNT M 1 Bright A_CheckFloor("XDeath4");
            Wait;
        XDeath4:
            HUNT N 5 Bright;
            HUNT N 1 Bright A_CheckFloor("XDeath5");
            Wait;
        XDeath5:
            HUNT O 5 Bright;
            HUNT O 1 Bright A_CheckFloor("XDeath6");
            Wait;
        XDeath6:
            HUNT P 1;
            HUNT P -1 RemoveOnLava;
            Stop;
        Death.Crush:
            HUNT H 5 A_FaceTarget;
            HUNT H 1 A_CheckFloor("Death.Crush2");
            Wait;
        Death.Crush2:
            HUNT L 0 Bright A_Explode(64,64);
            HUNT L 0 Bright A_StartSound("HUNTBOOM");
            HUNT L 5 Bright A_NoBlocking;
            HUNT L 1 Bright A_CheckFloor("Death.Crush3");
            Wait;
        Death.Crush3:
            HUNT M 5 Bright;
            HUNT M 1 Bright A_CheckFloor("Death.Crush4");
            Wait;
        Death.Crush4:
            HUNT N 5 Bright;
            HUNT N 1 Bright A_CheckFloor("Death.Crush5");
            Wait;
        Death.Crush5:
            HUNT O 5 Bright;
            HUNT O 1 Bright A_CheckFloor("Death.Crush6");
            Wait;
        Death.Crush6:
            HUNT P 1;
            HUNT P -1 RemoveOnLava;
            Stop;
    }
}

class Hunter2 : Hunter1
{
    Default
    {
        //$Title "Hunter Major"
        health 220;
        Translation "48:55=[251,175,139]:[189,103,67]", "112:127=[0,255,0]:[0,10,0]", "55:63=[189,103,67]:[30,15,9]", "64:71=[191,123,75]:[119,79,43]", "71:79=[119,79,43]:[43,35,15]", "128:135=[97,137,97]:[52,79,52]", "135:139=[52,79,52]:[29,45,29]", "139:143=[29,45,29]:[7,10,7]", "144:151=[179,110,26]:[106,65,16]", "151:159=[106,65,16]:[14,8,2]", "208:215=[255,231,22]:[152,138,13]", "215:223=[152,138,13]:[35,32,3]", "192:207=[0,149,170]:[0,27,31]", "4:4=[255,231,22]:[255,231,22]";
    }

    States
    {
        Missile:
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",56,4,random(-1,1),8,random(-1,1));
            HUNT E 3;
            goto See;
    }
}

class HunterShot : Actor
{
    Default
    {
        +NOGRAVITY;
        +FORCEXYBILLBOARD;
        Projectile;
        height 7;
        radius 7;
        speed 10;
        seesound "HUNTFIRE";
        deathsound "HUNTHIT";
        //renderstyle translucent;
        alpha 1;
        scale 0.375;
        damage 2;
        Decal "BaronScorch";
        Translation "48:55=[251,175,139]:[189,103,67]", "112:127=[0,255,0]:[0,10,0]", "55:63=[189,103,67]:[30,15,9]", "64:71=[191,123,75]:[119,79,43]", "71:79=[119,79,43]:[43,35,15]", "128:135=[200,172,156]:[110,85,78]", "135:139=[110,85,78]:[79,55,51]", "139:143=[79,55,51]:[19,11,11]", "144:151=[97,137,97]:[46,71,46]", "151:159=[46,71,46]:[7,10,7]", "208:215=[255,231,22]:[152,138,13]", "215:223=[152,138,13]:[35,32,3]", "192:207=[0,149,170]:[0,27,31]", "4:4=[255,231,22]:[255,231,22]";
    }

    States
    {
        Spawn:
            HUNT Q 1 Bright;
            Loop;
        Death:
            HUNT RSTU 2 Bright;
            Stop;
    }
}