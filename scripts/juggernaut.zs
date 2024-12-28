class Juggernaut : MarathonActor
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
    scale 0.9;
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
      JUGG D 2 bright A_CustomBulletAttack(6,6,1,3,"marathonpuff",0,0);
      // WASP F 6 A_CustomMeleeAttack(random(5,12),"WASPSPIT","WASPSPIT");
      Goto See;
    Missile:
      JUGG A 6 A_FaceTarget;
      JUGG A 6 Bright A_CustomMissile("JuggernautMissile", 4, 0, random(-1,1), 8, random(-1,1));
      Goto See;
    Death:
      JUGG A 0 A_NoGravity;
      JUGG A 0 A_NoBlocking;
      JUGG A 0 A_ChangeVelocity(0, 0, -1, CVF_REPLACE);
      JUGG D 30 A_Scream;
      Loop;
    Crash:
      JUGG A 0 A_PlaySound("JUGDIE");
      TNT1 A 0 A_Explode(500, 512);
      Stop;
  }
}

class JuggernautMissile : Actor
{
  Default
  {
    +SEEKERMISSILE;
    +FORCEXYBILLBOARD;
    Radius 6;
    Height 10;
    Speed 4;
    FastSpeed 8;
    Damage 4;
    Projectile;
    SeeSound "COMPATK1";
    DeathSound "COMPATK2";
    Decal "PlasmaScorchLower";
    scale .5;
    //YScale 0.5;
  }

  bool isClose;
  double closeDistance;
  bool played;

  override void Tick()
  {
    super.Tick();
    
    PlayerPawn p = Players[consoleplayer].mo;
    double d = p.Distance3D(self);
    if(!isClose && d < 70)
    {
      isClose = true;
      closeDistance = d;
    } 
    else if(isClose && !played && d > closeDistance)
    {
      bool alive = InStateSequence(self.curState, self.ResolveState("Spawn"));
      //Console.Printf("Alive: %d", alive);
      if(alive) {
        S_StartSound("COMPFBY", 0, 0, 1, ATTN_NORM, 0.0, 0.0);
        played = true;
      }
    }
  }

  States
  {
    Spawn:
      GREN A 1 Bright A_SeekerMissile(2, 4);
      GREN A 0 Bright A_SpawnItem("JuggernautMissileTrail");
      Loop;
     death:
      GREN A 0 A_Nogravity;
      GREN A 1 Bright A_explode(32, 32, 1);
      GREN BCDEFG 4 Bright;
      stop;
  }
}

class JuggernautMissileTrail : Actor
{
  Default
  {
    +NOGRAVITY;
    +FORCEXYBILLBOARD;
    scale .5;
      //YScale 0.5;
  }
  States
  {
    Spawn:
      TNT1 A 3;
      FLAM BCDE 1 Bright;
      Stop;
  }
}

// class CompilerBall2 : CompilerBall
// {
//   Default
//   {
//     +SEEKERMISSILE;
//     Translation "112:127=160:167";
//   }
//   States
//   {
//     Spawn:
//       COMP E 1 Bright A_SeekerMissile(2,2);
//       COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP E 1 Bright A_SeekerMissile(2,2);
//       COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP E 1 Bright A_SeekerMissile(2,2);
//       COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP E 1 Bright A_SeekerMissile(2,2);
//       COMP E 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP F 1 Bright A_SeekerMissile(2,2);
//       COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP F 1 Bright A_SeekerMissile(2,2);
//       COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP F 1 Bright A_SeekerMissile(2,2);
//       COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
//       COMP F 1 Bright A_SeekerMissile(2,2);
//       COMP F 0 Bright A_SpawnItem("CompilerBallTrail2");
//       Loop;
//     Death:
//       COMP JK 6 Bright;
//       Stop;
//   }
// }