class PolygonThinker : Thinker {
    int tagId;
    string type;
    int targetId;

    int lastSectorNum;

    array <int> sectorIndexes;
    Vector3 teleportPosition;
    PlayerPawn player;
    PlayerInfo playerInfo;
    bool isTeleportStart;
    bool isTeleporting;
    int teleportTicks;

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
        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        while((i = sti.Next()) >= 0)
        {
            self.sectorIndexes.Push(i);
        }


        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                self.playerInfo = Players[i];
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
            for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                if(currentSectorNum == level.sectors[self.sectorIndexes[i]].sectornum) {
                    if(currentSectorNum != self.lastSectorNum) {
                    
                        if(self.type == "Teleport" || self.type == "AutomaticExit") {
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
                        else if(self.type == "VisibleMonsterTrigger") {
                            //self.playerInfo.DesiredFov = self.playerFOV;
                            Console.Printf("Waking monsters");
                            player.A_AlertMonsters();
                        }
                        else if(self.type == "InvisibleMonsterTrigger") {
                            //self.playerInfo.DesiredFov = self.playerFOV;
                            Console.Printf("Waking monsters");
                            player.A_AlertMonsters();
                        }
                        else if(self.type == "DualMonsterTrigger") {
                            //self.playerInfo.DesiredFov = self.playerFOV;
                            Console.Printf("Waking monsters");
                            player.A_AlertMonsters();
                        }
                    }
                } else{
                    self.isTeleportStart = false;
                }
            }
        }

        if(!self.isTeleporting && self.isTeleportStart && player.vel.Length() < 1.0) {
            if(self.type == "AutomaticExit") {
                Teleport.TeleportOutMapNumber(self.targetId);
            } else if (self.type == "Teleport") {      
                Teleport.TeleportTo(self.targetId);    
            }        
            self.isTeleporting = true;
            self.isTeleportStart = false;
        }

        self.lastSectorNum = currentSectorNum;

        if(self.isTeleporting) {            
            if(self.teleportTicks >= 30) {
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
        //PolygonThinker p = GetInstance(tagId);
        //if(p == null) {
            new ("PolygonThinker").Init(
                tagId, 
                type,
                targetId);
        //}
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
}