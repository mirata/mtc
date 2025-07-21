class PolygonThinker : Thinker {
    int tagId;
    string type;
    int targetId;

    int lastTargetId;

    Sector sector;
    Vector3 teleportPosition;
    PlayerPawn player;
    PlayerInfo playerInfo;
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
        self.lastTargetId = -1;
        self.teleportTicks = 0;
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

        
        sti = level.CreateSectorTagIterator(18);

        if((i = sti.Next()) >= 0)
        {
            let sector = level.sectors[i];
            self.teleportPosition = (sector.centerspot.x, sector.centerspot.y, sector.floorplane.d);
        }

        return self;
    }

    override void Tick() {
        let sector = player.CurSector;
        let currentTagId = -1;
        if(sector != null) {
            for(let i=0;i<sector.CountTags();i++) {
                currentTagId = sector.GetTag(i);
                if(currentTagId == self.tagId && currentTagId != self.lastTargetId) {
                    if(!self.isTeleporting) {
                        self.isTeleporting = true;
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
                    break;
                }
            }
        }
        self.lastTargetId = currentTagId;

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
                Console.Printf("Teleporting player");
                self.player.Teleport(self.teleportPosition, self.player.Angle, TF_USEACTORFOG | TF_KEEPANGLE  | TF_KEEPVELOCITY);
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