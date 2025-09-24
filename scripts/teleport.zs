class TeleportThinker : Thinker {
    
    PlayerPawn player;
    bool isActive;
    int ticks;
    string mapName;

    Vector3 teleportPosition;

    TeleportThinker Init() {
        ticks = 0;

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }
        
        return self;
    }

    void TeleportTo(int tagId) {
        if(isActive) {
            return;
        }
        

        if(tagId > 0) {            
            SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
            int i;

            if((i = sti.Next()) >= 0)
            {
                self.teleportPosition = (level.sectors[i].centerspot.x, level.sectors[i].centerspot.y, level.sectors[i].floorplane.d);
                isActive = true;
                ticks = 0;
                TeleportOut("");
                Console.Printf("Teleporting to tag %d", tagId);
            }
        }
    }

    void TeleportOut(string mapName) {
        self.mapName = mapName;
        isActive = true;
        ticks = 0;
        Actor.Spawn("MarathonTeleportOut", (0,0,0), ALLOW_REPLACE);
    }

    void TeleportIn() {
        Actor.Spawn("MarathonTeleportIn", (0,0,0), ALLOW_REPLACE);
    }
    
    override void Tick() {
        if(isActive) {
            ticks++;
            if(ticks >= 15) {
                if(self.mapName != "") {
                    LevelLocals.ChangeLevel(self.mapName, 0, CHANGELEVEL_NOINTERMISSION, 0);
                } else {
                    self.player.Teleport(self.teleportPosition, self.player.Angle, TF_USEACTORFOG | TF_KEEPANGLE  | TF_KEEPVELOCITY);
                    TeleportIn();
                    isActive = false;
                    ticks = 0;
                }
            }
        }
    }

    static TeleportThinker Get()
    {
        TeleportThinker m;
        ThinkerIterator it = ThinkerIterator.Create("TeleportThinker");
        m = TeleportThinker(it.Next());
        if (m == null)
        {
            m = new("TeleportThinker").Init();
        }

        return m;
    }
}

class Teleport play {
    static void TeleportTo(int tagId) {
        TeleportThinker.Get().TeleportTo(tagId);
    }

    static void TeleportOut(string mapName) {
        TeleportThinker.Get().TeleportOut(mapName);
    }

    static void TeleportIn() {
        TeleportThinker.Get().TeleportIn();
    }
}