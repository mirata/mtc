class MarathonPuff : Actor replaces bulletpuff
{
    Default
    {
        +NOBLOCKMAP;
        +NOGRAVITY;
        +NOEXTREMEDEATH;
        +FORCEXYBILLBOARD;
        +NOTRIGGER;
        VSpeed .01;
        Mass 5;
        scale 0.5;
        //YScale 0.5;
    }
  States
  {
  Spawn:
    BLUD A 0;
    PUFF E 4 A_StartSound("ding");
    PUFF FG 4;
    stop;
  Crash:
    BLUD A 0;
    PUFF A 0 A_StartSound("ricochet");
    PUFF A 4 bright;
    PUFF B 4 bright;
    PUFF CD 4 bright;
    stop;
  }
}

class TracerPuff : Actor replaces bulletpuff
{
    Default
    {
        +NOBLOCKMAP;
        +NOGRAVITY;
        +NOEXTREMEDEATH;
        +FORCEXYBILLBOARD;
        +NOTRIGGER;
        VSpeed .01;
        Mass 5;
        scale 0.5;
        //YScale 0.5;
    }
  States
  {
  Spawn:
    BLUD A 0;
    PUFF ABCD 4;
    stop;
  }
}
class MeleePuff : Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOGRAVITY;
        +NOEXTREMEDEATH;
        +FORCEXYBILLBOARD;
        VSpeed .01;
        Mass 5;
        scale 0.5;
        //YScale 0.5;
    }
  States
  {
    Spawn:
    TNT1 A 0;
    TNT1 A 1 A_StartSound("ding");
    Stop;
    Crash:
    TNT1 A 0;
    TNT1 A 1 A_StartSound("punch");
    Stop;
  }
}
class MarathonBlood : Blood Replaces Blood
{
    Default
    {
        Mass 5;
        +NOBLOCKMAP;
        +NOTELEPORT;
        +ALLOWPARTICLES;
        +FORCEXYBILLBOARD;
        scale 0.5;
        //YScale 0.5;
    }
  States
  {
    Spawn:
        BLUD A 0;
        BLUD A 0 A_StartSound("fleshit");
        BLUD ABCD 8;
        Stop;
  }
}