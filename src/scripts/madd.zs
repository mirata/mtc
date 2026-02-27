class Madd : MarathonAlly
{
  Default
  {
      //marathon scale factor 6
      //$Title "Defense Drone"
      //$Angled
      //$Category "Marathon Monsters"
      MarathonActor.preferredFloatHeight 0;
      obituary "%o fell victim to friendly fire.";
      health 150;
      radius 24;
      height 32;
      mass 600;
      speed 6;
      Translation "192:207=[0,176,201]:[5,14,15]", "48:63=[255,231,22]:[20,18,2]", "64:79=[179,110,26]:[14,8,2]", "80:95=[240,240,240]:[15,15,15]", "176:191=[255,0,18]:[20,0,1]", "112:119=[254,244,149]:[254,224,37]", "120:131=[254,221,21]:[254,42,1]", "132:143=[231,38,1]:[39,0,0]";
      painchance 0;
      seesound "";
      painsound "";
      deathsound "SPNKR2";
      activesound "";
      attacksound "MAGNUM1";
      MONSTER;
      +FLOORCLIP;
      +SPAWNFLOAT;
      +NOBLOOD;
      +FLOAT;
      +NOGRAVITY;
      +FRIENDLY;
      +DONTGIB;
      +NOSPLASHALERT;
      scale 0.45;
      //YScale 0.5
      damagefactor "fire", 0.0;
      Decal "BulletChip";
  }

  States
  {
    Spawn:
      MADD A 3 A_Look;
      loop;
    See:
      MADD A 3 A_Chase;
      loop;
    Missile:
      MADD A 1 A_FaceTarget;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      goto See;
    Death:
      MADD C 0 bright A_SpawnItem("MADDBoom1");
      MADD C 3 bright A_StartSound("ASSAULT3");
      MADD DEF 3 bright;
      MADD G 0 bright A_SpawnItem("MADDBoom1");
      MADD G 3 bright A_StartSound("ASSAULT3");
      MADD HI 3 bright;
      MADD J 0 bright A_SpawnItem("MADDBoom1");
      MADD J 3 bright A_StartSound("ASSAULT3");
      MADD K 3 bright A_NoBlocking;
      MADD L 0 bright A_SpawnItem("MADDBoom2");
      MADD L 3 bright A_Scream;
      MADD M -1 bright ACS_Execute(779,0,0,0,0);
      stop;
  }
}

class MADDBoom1 : Actor
{
  Default
  {
    Projectile;
    +EXTREMEDEATH;
    speed 1;
  }

  States
  {
    Spawn:
      TNT1 A 0;
      TNT1 A 0 A_Explode(64,64);
      Stop;
  }
}

class MADDBoom2 : Actor
{
  Default
  {
    Projectile;
    +EXTREMEDEATH;
    speed 1;
  }

  States
  {
    Spawn:
      TNT1 A 0;
      TNT1 A 0 A_Explode(96,96);
      Stop;
  }
}

class BadMadd : MarathonActor
{
  Default
  {  
    //$Title "Beserk Defense Drone"
    //$Angled
        MarathonActor.friendlyHud true;
    //$Category "Marathon Monsters"
    MarathonActor.preferredFloatHeight 0;
    obituary "%o didn't beware of low flying defense drones.";
    health 150;
    radius 24;
    height 32;
    mass 600;
    speed 6;
    Translation "192:207=[97,137,97]:[7,10,7]", "48:63=[255,231,22]:[20,18,2]", "64:79=[179,110,26]:[14,8,2]", "80:95=[240,240,240]:[15,15,15]", "176:191=[255,0,18]:[20,0,1]", "112:119=[254,244,149]:[254,224,37]", "120:131=[254,221,21]:[254,42,1]", "132:143=[231,38,1]:[39,0,0]";
    painchance 0;
    seesound "";
    painsound "";
    deathsound "SPNKR2";
    activesound "";
    attacksound "MAGNUM1";
    MONSTER;
    +FLOORCLIP;
    +SPAWNFLOAT;
    +NOBLOOD;
    +FLOAT;
    +NOGRAVITY;
    +FRIENDLY;
    +DONTGIB;
    +NOSPLASHALERT;
    -FRIENDLY;
    scale 0.45;
    //YScale 0.5
    damagefactor "fire", 0.0;
    Decal "BulletChip";
  }

  States
  {
    Spawn:
      MADD A 3 A_Look;
      loop;
    See:
    
    See:
      MADD A 0 TargetPlayerAllies();
      MADD A 3 A_Chase;
      loop;

    Missile:
      MADD A 0 A_Jump(64,"Missile2");
      MADD A 1 A_FaceTarget;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      MADD B 2 bright A_CustomBulletAttack(1.5,1.5,1,4,"marathonpuff",0,0);
      MADD A 2;
      goto See;
    Missile2:
      MADD A 0;
      MADD A 2 A_FaceTarget;
      MADD B 2 bright A_CustomMissile("marathongrenade",20,0,random(-1,1),8,random(-1,1));
      goto see;
    Death:
      MADD C 0 bright A_SpawnItem("MADDBoom1");
      MADD C 3 bright A_StartSound("ASSAULT3");
      MADD DEF 3 bright;
      MADD G 0 bright A_SpawnItem("MADDBoom1");
      MADD G 3 bright A_StartSound("ASSAULT3");
      MADD HI 3 bright;
      MADD J 0 bright A_SpawnItem("MADDBoom1");
      MADD J 3 bright A_StartSound("ASSAULT3");
      MADD K 3 bright A_NoBlocking;
      MADD L 0 bright A_SpawnItem("MADDBoom2");
      MADD L 3 bright A_Scream;
      MADD M -1 bright ACS_Execute(779,0,0,0,0);
      stop;
  }
}