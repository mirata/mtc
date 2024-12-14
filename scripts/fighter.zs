class Fighter1 : Actor
{
  Default
  {
    //$Title "Fighter"
    //$Angled
    //$Category "Marathon Monsters"
    MONSTER;
    +FLOORCLIP;
    +NOSPLASHALERT;
    +DONTGIB;
    obituary "%o was smacked down by a fighter.";
    hitobituary "%o was smacked down by a fighter.";
    health 25;
    radius 13;
    height 51;
    mass 100;
    speed 7;
    painchance 0;
    Translation "112:127=[4,198,101]:[0,32,27]", "199:207=[9,191,206]:[0,98,130]", "240:247=[1,69,88]:[0,0,0]";
    seesound "PFHOR";
    painsound "";
    deathsound "PFHORDIE";
    activesound "PFHOR";
    bloodcolor "ff ff 33";
    scale .4;
    //YScale 0.4;
  }
  States
  {
    Spawn:
      FIGH E 10 A_Look;
      Loop;
    See:
      FIGH ABCD 3 A_Chase;
      Loop;
    Melee:
      FIGH E 6 A_FaceTarget;
      FIGH A 0 A_PlaySound("PFHORAT1");
      FIGH FG 6 Bright A_FaceTarget;
      FIGH H 6 Bright A_CustomMeleeattack(random(4,32),"PFHORAT2","NONE","normal",1);
      goto See;
    Death:
      FIGH I 0 A_FaceTarget;
      FIGH I 8 A_Scream;
      FIGH I 1 A_CheckFloor("Death2");
      Wait;
    Death2:
      FIGH J 8 A_NoBlocking;
      FIGH J 1 A_CheckFloor("Death3");
      Wait;
    Death3:
      FIGH K 8;
      FIGH K 1 A_CheckFloor("Death4");
      Wait;
    Death4:
      FIGH L 1 A_Playsound("Splat");
      FIGH L -1 ACS_Execute(779,0,0,0,0);
      Stop;
    XDeath:
      FIGH I 0 A_FaceTarget;
      FIGH I 8;
      FIGH I 1 A_CheckFloor("XDeath2");
      Wait;
    XDeath2:
      FIGH M 4 A_NoBlocking;
      FIGH M 1 A_CheckFloor("XDeath3");
      Wait;
    XDeath3:
      FIGH N 4;
      FIGH N 1 A_CheckFloor("XDeath4");
      Wait;
    XDeath4:
      FIGH O 4;
      FIGH O 1 A_CheckFloor("XDeath5");
      Wait;
    XDeath5:
      FIGH P 4;
      FIGH P 1 A_CheckFloor("XDeath6");
      Wait;
    XDeath6:
      FIGH Q 1 A_Playsound("Slop");
      FIGH Q -1 ACS_Execute(779,0,0,0,0);
      Stop;
    Death.Crush:
      FIGH I 0 A_FaceTarget;
      FIGH I 8 A_Playsound("PFHORBURN");
      FIGH I 1 A_CheckFloor("Death.Crush2");
      Wait;
    Death.Crush2:
      FIGH M 4 A_NoBlocking;
      FIGH M 1 A_CheckFloor("Death.Crush3");
      Wait;
    Death.Crush3:
      FIGH N 4;
      FIGH N 1 A_CheckFloor("Death.Crush4");
      Wait;
    Death.Crush4:
      FIGH O 4;
      FIGH O 1 A_CheckFloor("Death.Crush5");
      Wait;
    Death.Crush5:
      FIGH P 4;
      FIGH P 1 A_CheckFloor("Death.Crush6");
      Wait;
    Death.Crush6:
      FIGH Q 1 A_Playsound("Slop");
      FIGH Q -1 ACS_Execute(779,0,0,0,0);
      Stop;
    Burn:
      BURN A 5 Bright A_PlaySound("PFHORBURN");
      BURN A 1 Bright A_CheckFloor("Burn2");
      Wait;
    Burn2:
      BURN B 5 Bright A_NoBlocking;
      BURN B 1 Bright A_CheckFloor("Burn3");
      Wait;
    Burn3:
      BURN C 5 Bright;
      BURN C 1 Bright A_CheckFloor("Burn4");
      Wait;
    Burn4:
      BURN D 5 Bright;
      BURN D 1 Bright A_CheckFloor("Burn5");
      Wait;
    Burn5:
      BURN E -1 ACS_Execute(779,0,0,0,0);
      Stop;
    Death.LavaFire:
      BURN A 0 Bright A_NoBlocking;
      BURN A 5 Bright A_Playsound("PFHORBURN");
      BURN A 1 Bright A_Checkfloor("Death.LavaFire1");
      Wait;
    Death.LavaFire1:
      BURN B 5 Bright;
      BURN B 1 Bright A_Checkfloor("Death.LavaFire2");
      Wait;
    Death.LavaFire2:
      BURN C 5 Bright;
      BURN C 1 Bright A_Checkfloor("Death.LavaFire3");
      Wait;
    Death.LavaFire3:
      BURN D 5 Bright;
      BURN D 1 Bright A_Checkfloor("Death.LavaFire4");
      Wait;
    Death.LavaFire4:
      BURN E -1 ACS_Execute(779,0,0,0,0);
      Stop;
    }
}
class Fighter2 : Fighter1
{
  Default
  {
    //$Title "Fighter Major"
    health 50;
    Translation "112:127=[161,0,100]:[0,0,0]";
  }
}
class Fighter3 : Fighter1
{
  Default
  {
    //$Title "Projectile Fighter"
    health 50;
    Translation "112:127=[246,37,0]:[0,0,0]", "200:207=[57,228,139]:[5,44,24]", "240:246=[5,44,24]:[0,0,0]";
  }
  States
  {
    Missile:
      FIGH E 6 A_FaceTarget;
      FIGH FG 6 Bright A_FaceTarget;
      FIGH H 6 Bright A_CustomMissile("FighterProjectile",32,0,random(-1,1),8,random(-1,1));
      goto See;
  }
}
class Fighter4 : Fighter1
{
  Default
  {
    //$Title "Projectile Fighter Major"
    health 50;
    Translation "112:127=[12,0,255]:[0,0,0]", "200:207=[57,228,139]:[5,44,24]", "240:246=[5,44,24]:[0,0,0]";
    speed 9;
  }
  States
  {
    Missile:
      FIGH E 6 A_FaceTarget;
      FIGH FG 6 Bright A_FaceTarget;
      FIGH H 6 Bright A_CustomMissile("FighterProjectile",32,0,random(-1,1),8,random(-1,1));
      FIGH E 6 A_FaceTarget;
      FIGH FG 6 Bright A_FaceTarget;
      FIGH H 6 Bright A_CustomMissile("FighterProjectile",32,0,random(-1,1),8,random(-1,1));
      goto See;
  }
}
class FighterProjectile : Actor
{
  Default
  {
    Translation "112:127=[4,198,111]:[0,32,27]", "199:207=[9,191,206]:[0,98,130]", "240:247=[1,69,88]:[0,0,0]";
    Radius 6;
    Height 8;
    Speed 15;
    FastSpeed 30;
    Damage 4;
    Projectile;
    SeeSound "PFHORAT1";
    DeathSound "PFHORAT2";
    scale .5;
    //YScale 0.5;
    +FORCEXYBILLBOARD;
    Decal "BaronScorch";
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
        S_StartSound("FIGHFBY", 0, 0, 1, ATTN_NORM, 0.0, 0.0);
        played = true;
      }
    }
  }

  States
  {
    Spawn:
      FIGH RS 4 Bright;
      Loop;
    Death:
      FIGH TUVWX 4 Bright;
      Stop;
  }
}