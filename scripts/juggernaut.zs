class Juggernaut : Actor
{
  Default
  {
    //$Title "Juggernaut"
    //$Angled
    //$Category "Marathon Monsters"
    MONSTER;
    +NOSPLASHALERT;
    +DONTGIB;
    +FLOAT
    +NOGRAVITY
    +DONTOVERLAP
    +SPAWNFLOAT
    obituary "%o was nuked by a Juggernaut.";
    hitobituary "%o was nuked by a Juggernaut.";
    health 10;
    radius 64;
    height 128;
    mass 100;
    speed 7;
    painchance 0;
    seesound "";
    painsound "";
    deathsound "JUGWARN";
    activesound "";
    bloodcolor "ff ff 33";
    scale 1.4;
    //YScale 0.4;
  }

  // void Explode(){
  //   Actor spawnedActor = Spawn("ZombieMan", self.pos);
  //   spawnedActor.Destroy(self);
  // }
  
  States
  {
    Spawn:
      JUGG A -1;
      Stop;
    Spawn:
      JUGG A 6 A_Look;
      Loop;
    See:
      JUGG A 3 A_Chase;
      Loop;
    Melee:
      JUGG A 6 A_FaceTarget;
      // WASP F 6 A_CustomMeleeAttack(random(5,12),"WASPSPIT","WASPSPIT");
      Goto See;
    Missile:
      JUGG A 6 A_FaceTarget;
      //WASP F 6 A_CustomMissile("SpitBall",4,0,random(-1,1),8,random(-1,1))
      Goto See;
    Death:
      JUGG A 0 A_Gravity;
      JUGG A 0 A_NoBlocking;
      JUGG A 0 A_ChangeVelocity(0, 0, -0.1, CVF_RELATIVE);
      // FBMB F 30 A_PlaySound("JUGWARN", CHAN_BODY, 1, true);
      JUGG D 30 A_Scream;
      Loop;
    Crash:
      JUGG A 0 A_PlaySound("JUGDIE");
      TNT1 A 0 A_Explode(500, 512);
      Stop;
  }
}