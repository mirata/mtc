class PolygonThinker : Thinker {
    int tagId;
    string type;
    int targetId;

    int lastSectorNum;

    Sector sector;
    Vector3 teleportPosition;
    PlayerPawn player;
    PlayerInfo playerInfo;
    bool isTeleportStart;
    bool isTeleporting;
    int teleportTicks;
    float playerFOV;
    int teleportDuration;

    PolygonThinker Init(
        int tagId,
        string type,
        int targetId) {
        self.tagId = tagId;
        self.type = type;
        self.targetId = targetId;
        self.lastSectorNum = -1;
        self.teleportTicks = 0;
        self.isTeleportStart = false;
        self.isTeleporting = false;
        self.teleportDuration = 30;
        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        if((i = sti.Next()) >= 0)
        {
            self.sector = level.sectors[i];
        }

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                self.playerInfo = Players[i];
                self.playerFOV = self.playerInfo.DesiredFov;
                break; // Take the first valid player
            }
        }
        
        if(targetId > 0) {
            sti = level.CreateSectorTagIterator(targetId);

            if((i = sti.Next()) >= 0)
            {
                self.teleportPosition = (level.sectors[i].centerspot.x, level.sectors[i].centerspot.y, level.sectors[i].floorplane.d);
            }
        }

        return self;
    }

    override void Tick() {
        let currentSectorNum = -1;
        if(player.CurSector != null) {
            currentSectorNum = player.CurSector.sectornum;
            if(self.sector != null && currentSectorNum == self.sector.sectornum) {
                if(currentSectorNum != self.lastSectorNum) {
                
                    if(self.type == "Teleport") {
                        if(!self.isTeleportStart) {
                            self.isTeleportStart = true;
                        }
                    } 
                    if(self.type == "PlatformActivate") {
                        Console.Printf("Activating platform %d", self.targetId);
                        Platform.Activate(self.targetId);
                    } 
                    else if(self.type == "PlatformDeactivate") {
                        Console.Printf("Deactivating platform %d", self.targetId);
                        Platform.Deactivate(self.targetId);
                    } 
                    else if(self.type == "LightActivate") {
                        //self.playerInfo.DesiredFov = 180.0;
                        Console.Printf("Activating light %d", self.targetId);
                        Light.Activate(self.targetId);
                    } 
                    else if(self.type == "LightDeactivate") {
                        //self.playerInfo.DesiredFov = self.playerFOV;
                        Console.Printf("Deactivating light %d", self.targetId);
                        Light.Deactivate(self.targetId);
                    }
                }
            } else{
                self.isTeleportStart = false;
            }
        }

        if(self.isTeleportStart && player.vel.Length() < 1.0) {
            Actor.Spawn("MarathonTeleport", self.player.pos, ALLOW_REPLACE);
            self.isTeleporting = true;
            self.isTeleportStart = false;
        }

        self.lastSectorNum = currentSectorNum;

        if(self.isTeleporting) {
            if(self.teleportTicks == 0) {
                self.player.StartSoundSequence("TeleportOut", 0);
            }
            
            if(self.teleportTicks == (self.teleportDuration / 2)) {
                self.player.StartSoundSequence("TeleportIn", 0);
            }
            self.teleportTicks++;
            float val = Sin(float(self.teleportTicks) / self.teleportDuration * 180);
            self.playerInfo.DesiredFOV = ((160.0 - self.PlayerFOV) * val) + self.PlayerFOV;
            if(self.teleportTicks == self.teleportDuration / 2) {
                // Console.Printf("Teleporting player");
                self.player.Teleport(self.teleportPosition, self.player.Angle, TF_USEACTORFOG | TF_KEEPANGLE  | TF_KEEPVELOCITY);
                // Actor.Spawn("MarathonTeleportIn", self.teleportPosition, ALLOW_REPLACE);
            }
            
            if(self.teleportTicks >= self.teleportDuration) {
                self.isTeleporting = false;
                self.teleportTicks = 0;
            }
        }
    }
}

class Polygon play {
    static void Init(
        int tagId, 
        string type,
        int targetId) {
        PolygonThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("PolygonThinker").Init(
                tagId, 
                type,
                targetId);
        }
    }

    static PolygonThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("PolygonThinker");
        PolygonThinker p = null;

        while (p = PolygonThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Polygon tag %d does not exist", tagId);
        return null;
    }

    

    static PolygonThinker GetInstanceBySector(Sector sector) {
        ThinkerIterator it = ThinkerIterator.Create("PolygonThinker");
        PolygonThinker p = null;

        while (p = PolygonThinker(it.next()))
        {
            if(p.sector == sector) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Polygon tag %d does not exist", tagId);
        return null;
    }
}