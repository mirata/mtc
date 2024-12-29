class Hunter1 : MarathonActor
{
    Default
    {
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
        scale .45;
        //YScale 0.45;
    }

    States
    {
        Spawn:
            HUNT E 10 A_Look;
            Loop;
        See:
            HUNT A 0 TargetBobs();
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
            HUNT K -1 ACS_Execute(779,0,0,0,0);
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
            HUNT P -1 ACS_Execute(779,0,0,0,0);
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
            HUNT P -1 ACS_Execute(779,0,0,0,0);
            Stop;
    }
}

class Hunter2 : Hunter1
{
    Default
    {
        //$Title "Hunter Major"
        health 220;
        Translation "128:151=[59,91,59]:[26,40,26]", "152:159=[97,137,97]:[26,40,26]", "12:15=[26,40,26]:[0,0,0]";
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

class Hunter3 : Hunter1
{
    Default
    {
        //$Title "Hunter Boss"
        health 1800;
        radius 25;
        height 96;
        scale .7;
        Translation "128:151=[22,59,101]:[8,22,37]", "152:159=[36,95,163]:[8,22,37]", "12:15=[8,22,37]:[0,0,0]";
    }

    states
    {
        Missile:
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",80,11,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",80,11,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",80,11,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",80,11,random(-1,1),8,random(-1,1));
            HUNT F 6 Bright A_FaceTarget;
            HUNT G 3 Bright A_SpawnProjectile("HunterShot",80,11,random(-1,1),8,random(-1,1));
            HUNT E 3;
            goto See;
        Death:
            HUNT H 5 A_FaceTarget;
            HUNT H 1 A_CheckFloor("Death2");
            Wait;
        Death2:
            HUNT L 0 Bright A_Explode(192,192);
            HUNT L 0 Bright A_StartSound("HUNTBOOM");
            HUNT L 5 Bright A_NoBlocking;
            HUNT L 1 Bright A_CheckFloor("Death3");
            Wait;
        Death3:
            HUNT M 5 Bright;
            HUNT M 1 Bright A_CheckFloor("Death4");
            Wait;
        Death4:
            HUNT N 5 Bright;
            HUNT N 1 Bright A_CheckFloor("Death5");
            Wait;
        Death5:
            HUNT O 5 Bright;
            HUNT O 1 Bright A_CheckFloor("Death6");
            Wait;
        Death6:
            HUNT P 1;
            HUNT P -1 ACS_Execute(779,0,0,0,0);
            Stop;
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
        scale .375;
        damage 2;
        Decal "BaronScorch";
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