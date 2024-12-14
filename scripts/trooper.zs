class Trooper1 : Actor
{
  Default
  {
    //$Title "Trooper"
    //$Angled
    //$Category "Marathon Monsters"
    MONSTER;
    +NOSPLASHALERT;
    +DONTGIB;
    +FLOORCLIP;
    obituary "%o was shot by a trooper.";
    hitobituary "%o was shot by a trooper.";
    health 45;
    radius 10;
    height 56;
    mass 100;
    speed 5;
    painchance 0;
    Translation "112:127=[4,198,101]:[0,32,27]", "199:207=[9,191,206]:[0,98,130]", "240:247=[1,69,88]:[0,0,0]";
    seesound "PFHOR";
    painsound "";
    attacksound "ASSAULT1";
    deathsound "PFHORDIE";
    activesound "PFHOR";
    bloodcolor "ff ff 33";
    Decal "BulletChip";
    scale .4;
    //YScale 0.4;
  }

  States
  {
    Spawn:
      TROP E 10 A_Look;
      loop;
    See:
      TROP ABCD 3 A_Chase;
      loop;
    Missile:
      TROP E 1 A_Jump(32,"Missile2");
      TROP E 2 A_FaceTarget;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      goto See;
    Missile2:
      TROP E 3 A_FaceTarget;
      TROP F 3 bright A_CustomMissile("TrooperGrenade",22,0,random(-5,5),8,random(-5,5));
      TROP E 3;
      goto See;
    Death:
      TROP G 0 A_FaceTarget;
      TROP G 8 A_Scream;
      TROP G 1 A_CheckFloor("Death2");
      wait;
    Death2:
      TROP H 8 A_NoBlocking;
      TROP H 1 A_CheckFloor("Death3");
      wait;
    Death3:
      TROP I 8;
      TROP I 1 A_CheckFloor("Death4");
      wait;
    Death4:
      TROP J 1 A_Playsound("Splat");
      TROP J -1 ACS_Execute(779,0,0,0,0);
      stop;
    Death.Crush:
      TROP G 0 A_FaceTarget;
      TROP G 8 A_PlaySound("PFHORBURN");
      TROP G 1 A_CheckFloor("Death.Crush2");
      wait;
    Death.Crush2:
      TROP H 8 A_NoBlocking;
      TROP H 1 A_CheckFloor("Death.Crush3");
      wait;
    Death.Crush3:
      TROP I 8;
      TROP I 1 A_CheckFloor("Death.Crush4");
      wait;
    Death.Crush4:
      TROP J 1 A_Playsound("Splat");
      TROP J -1 ACS_Execute(779,0,0,0,0);
      stop;
    Burn:
      BURN A 5 bright A_PlaySound("PFHORBURN");
      BURN A 1 bright A_CheckFloor("Burn2");
      wait;
    Burn2:
      BURN B 5 bright A_NoBlocking;
      BURN B 1 bright A_CheckFloor("Burn3");
      wait;
    Burn3:
      BURN C 5 bright;
      BURN C 1 bright A_CheckFloor("Burn4");
      wait;
    Burn4:
      BURN D 5 bright;
      BURN D 1 bright A_CheckFloor("Burn5");
      wait;
    Burn5:
      BURN E -1 ACS_Execute(779,0,0,0,0);
      stop;
    Death.LavaFire:
      BURN A 0 bright A_NoBlocking;
      BURN A 5 bright A_Playsound("PFHORBURN");
      BURN A 1 bright A_Checkfloor("Death.LavaFire1");
      wait;
    Death.LavaFire1:
      BURN B 5 bright;
      BURN B 1 bright A_Checkfloor("Death.LavaFire2");
      wait;
    Death.LavaFire2:
      BURN C 5 bright;
      BURN C 1 bright A_Checkfloor("Death.LavaFire3");
      wait;
    Death.LavaFire3:
      BURN D 5 bright;
      BURN D 1 bright A_Checkfloor("Death.LavaFire4");
      wait;
    Death.LavaFire4:
      BURN E -1 ACS_Execute(779,0,0,0,0);
      stop;
  }
}
class Trooper2 : Trooper1
{
  Default
  {
    //$Title "Trooper Major"
    health 85;
    Translation "112:127=[161,0,100]:[0,0,0]";
  }

  States
  {
    Missile:
      TROP E 1 A_Jump(48,"Missile2");
      TROP E 2 A_FaceTarget;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      TROP F 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      TROP E 2;
      goto See;
    Missile2:
      TROP E 3 A_FaceTarget;
      TROP F 3 bright A_CustomMissile("TrooperGrenade",22,0,random(-5,5),8,random(-5,5));
      TROP E 3;
      TROP F 3 bright A_CustomMissile("TrooperGrenade",22,0,random(-5,5),8,random(-5,5));
      TROP E 3;
      goto See;
  }
}

class TrooperGrenade : Actor
{
  Default
  {
    -DEHEXPLOSION;
    -NOGRAVITY;
    -DOOMBOUNCE;
    +FORCEXYBILLBOARD;
    +EXTREMEDEATH;
    -ROCKETTRAIL;
    seesound "ASSAULT1";
    deathsound "ASSAULT3";
    Decal "Scorch";
    gravity 1;
    damagetype "None";
    scale .75;
    //YScale 0.75;
    damage 4;
  }

  States
  {
    spawn:
      TGRN A 1 bright;
      loop;
    death:
      GREN A 0 A_Nogravity;
      GREN A 1 bright A_explode(32,32,1);
      GREN BCDEFG 4 bright;
      stop;
  }
}