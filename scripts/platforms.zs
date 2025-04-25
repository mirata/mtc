class PlatformThinker : Thinker {
    int tagId;
    double minHeight;
    double maxHeight;
    double speed;
    int delay;

    Sector sector;
    bool isDoor;
    bool fromFloor;
    bool fromCeiling;
    bool floorToCeiling;
    bool activatesOnlyOnce;
    bool deactivatesAtEachLevel;
    bool deactivatesAtInitialLevel;
    bool delayBeforeActivation;
    int activatesLight;
    int deactivatesLight;
    bool controlByPlayer;
    bool controlByMonsters;

    bool isExtended;
    bool isExtending;
    bool isActive;
    bool initialExtended;

    bool previousActive;
    bool previousExtending;
    bool isDelaying;
    int delayTicks;
    bool hitLimit;

    int minFloor;
    int maxFloor;
    int minCeiling;
    int maxCeiling;

    array <int> adjacentPlatformTags;

    PlatformThinker Init(
        int tagId, 
        double minHeight, 
        double maxHeight, 
        double speed, 
        int delay,
        bool isDoor, 
        bool fromFloor, 
        bool fromCeiling,
        bool floorToCeiling,
        bool isExtended,
        bool isActive,
        bool activatesOnlyOnce,
        bool deactivatesAtEachLevel,
        bool deactivatesAtInitialLevel,
        bool delayBeforeActivation,
        int activatesLight,
        int deactivatesLight,
        bool controlByPlayer,
        bool controlByMonsters) {
        self.tagId = tagId;
        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        if((i = sti.Next()) >= 0)
        {
            self.sector = level.sectors[i];
        }
        self.minHeight = minHeight;
        self.maxHeight = maxHeight;
        self.speed = speed;
        self.delay = delay;
        self.isDoor = isDoor;

        self.fromFloor = fromFloor;
        self.fromCeiling = fromCeiling; 
        self.floorToCeiling = floorToCeiling;
        self.isExtended = isExtended;
        self.isActive = isActive;
        self.activatesOnlyOnce = activatesOnlyOnce;
        self.deactivatesAtEachLevel = deactivatesAtEachLevel;
        self.deactivatesAtInitialLevel = deactivatesAtInitialLevel;
        self.delayBeforeActivation = delayBeforeActivation;
        self.activatesLight = activatesLight;
        self.deactivatesLight = deactivatesLight;
        self.controlByPlayer = controlByPlayer;
        self.controlByMonsters = controlByMonsters;

        self.initialExtended = isExtended;
        self.isExtending = !isExtended;
        self.previousActive = isActive;
        self.previousExtending = isExtending;
        self.isDelaying = false;
        self.delayTicks = 0;
        self.hitLimit = false;

        self.minFloor = self.minHeight;
        self.maxFloor = self.maxHeight;
        self.minCeiling = self.minHeight;
        self.maxCeiling = self.maxHeight;
        
        if(self.fromFloor && self.fromCeiling) {
            self.maxFloor = self.minHeight + ((self.maxHeight - self.minHeight) / 2);
            self.minCeiling = self.minHeight + ((self.maxHeight - self.minHeight) / 2);
        }
        if(self.isExtended) {
            if(self.fromFloor){
                Console.Printf("Move Floor %d", maxFloor);
                self.sector.MoveFloor(self.maxFloor + sector.floorplane.d, -self.maxFloor, 0, 1, false); 
            }
        
            if(self.fromCeiling){
                Console.Printf("Move Ceiling %d", minCeiling);
                self.sector.MoveCeiling(sector.ceilingplane.d - self.minCeiling, self.minCeiling, 0, -1, false); 
            }
        }

        return self;
    }

    void SetAdjacentPlatform(int tagId) {
        adjacentPlatformTags.Push(tagId);
    }

    void SetAdjacentPlatformRules(
        bool activatesAdjacentPlatformsWhenActivating,
        bool activatesAdjacentPlatformsWhenDeactivating,
        bool activatesAdjacantPlatformsAtEachLevel,
        bool deactivatesAdjacentPlatformsWhenActivating,
        bool deactivatesAdjacentPlatformsWhenDeactivating) {
            
        }

    void Activate() {
        if(self.isActive) {
            return;
        }
        
        if(self.activatesLight >= 0) {
            Light.Activate(self.activatesLight);
        }
        if(self.deactivatesLight >= 0) {
            Light.Deactivate(self.deactivatesLight);
        }
        self.isActive = true;
    }

    void Deactivate() {
        if(!self.isActive) {
            return;
        }
        
        //Console.Printf("Deactivate %d", tagId);
        self.isActive = false;
    }

    void Toggle() {
        if(self.isDoor && !self.controlByPlayer) {
            sector.StartSoundSequence(0, "MarathonDoorStuck", 0);
            return;
        }
        //Console.Printf("Toggle %d", tagId);
        self.isDelaying = false;
        self.delayTicks = 0;
        self.hitLimit = false;
        if(!self.isActive) {
            Activate();
            if(self.isDoor){ 
            }
        } else {
            if(self.isDoor)
            {
                self.isExtending = !self.isExtending;
            }
            else{
                Deactivate();
            }
        }
    }

    void ToggleMonster() {
        
        if(!self.controlByMonsters) {
            return;
        }
        if(self.isDoor && (!self.isActive || self.isExtending)) {
            self.isDelaying = false;
            self.delayTicks = 0;
            Activate();
        }
    }

    override void Tick() {
        if(self.isActive) {
            //sector.SetLightLevel(0);
            double floorHeight = sector.floorplane.d;
            double ceilingHeight = sector.ceilingplane.d;
            if(self.isDelaying) {
                if(self.delayTicks < self.delay) {
                    self.delayTicks++;
                }
                else{
                    self.isExtending = !self.isExtending;
                    self.isDelaying = false;
                    self.delayTicks = 0;
                    self.hitLimit = false;
                }
                // Console.Printf("Delay %d", self.delayTicks);
            }
            if(!self.isDelaying){
                if(self.fromFloor){
                    if(isExtending){           
                        self.sector.MoveFloor(self.speed, -self.maxFloor, 0, 1, false); 
                    }
                    else{    
                        self.sector.MoveFloor(self.speed, -self.minFloor, 0, -1, false); 
                    }
                    floorHeight = sector.floorplane.d;
                }
                if(self.fromCeiling){
                    if(isExtending){           
                        self.sector.MoveCeiling(self.speed, self.minCeiling, 0, -1, false); 
                    }
                    else{    
                        //Console.Printf("Opening");
                        self.sector.MoveCeiling(self.speed, self.maxCeiling, 0, 1, false); 
                    }
                    ceilingHeight = sector.ceilingplane.d;
                }

                //Console.Printf("From Floor: %i, From Ceiling: %i", self.maxHeight, ceilingHeight);

                if((self.fromFloor && ((self.isExtending && -floorHeight >= self.maxFloor) || (!self.isExtending && -floorHeight <= self.minFloor)))  ||
                    (self.fromCeiling && ((self.isExtending && ceilingHeight <= self.minCeiling) || (!self.isExtending && ceilingHeight >= self.maxCeiling))) ) {

                        self.hitLimit = true;
                        self.isExtended = self.isExtending;
                        if((self.deactivatesAtInitialLevel && self.isExtended == self.initialExtended) || self.deactivatesAtEachLevel) {
                            self.isActive = false;
                            self.isExtending = !self.isExtending;
                        }
                        //Console.Printf("Yo");

                    // Deactivate();
                }
            }
            
            // Console.Printf("Heights %d %d", floorHeight, ceilingHeight);
        }

        //sounds 

        if(self.hitLimit) {
            self.isDelaying = true;
            self.hitLimit = false;
            if(!self.isDoor){
                Console.Printf("Hitlimit %d", tagId);
                sector.StartSoundSequence(0, "MarathonPlatformStop", 0);
            }
            
            for (int i = 0; i < adjacentPlatformTags.Size(); i++) 
            {
                Platform.Activate(adjacentPlatformTags[i]);
            }
        }
        else if(self.isActive && !self.previousActive) {
            //activating
            if(self.isDoor){
                if(self.isExtending){
                    sector.StartSoundSequence(0, "MarathonDoorClose", 0);
                } else {
                    sector.StartSoundSequence(0, "MarathonDoorOpen", 0);
                }
            } else {
                sector.StartSoundSequence(0, "MarathonPlatformStart", 0);
            }
        } 
        else if(!self.isActive && self.previousActive) {
            //deactivating
            if(!self.isDoor) {
                Console.Printf("Deactivating %d", tagId);
                sector.StartSoundSequence(0, "MarathonPlatformStop", 0);
            }
        }
        else if(self.isActive){
            //reversing directions
            if(self.isDoor && self.isExtending && !self.previousExtending) {                        
                sector.StartSoundSequence(0, "MarathonDoorClose", 0);
            }
            else if(self.isDoor && !self.isExtending && self.previousExtending) {                        
                sector.StartSoundSequence(0, "MarathonDoorOpen", 0);
            }
            else if(!self.isDoor && ((!self.isExtending && self.previousExtending) || (self.isExtending && !self.previousExtending))) {    
                Console.Printf("Reverse %d", tagId);                    
                sector.StartSoundSequence(0, "MarathonPlatformStart", 0);
            }
        }
        self.previousActive = self.isActive;
        self.previousExtending = self.isExtending;
    }
}

class Platform play {
    static void Init(
        int tagId, 
        double minHeight, 
        double maxHeight, 
        double speed, 
        int delay,
        bool isDoor, 
        bool fromFloor, 
        bool fromCeiling,
        bool floorToCeiling,
        bool isExtended,
        bool isActive,
        bool activatesOnlyOnce,
        bool deactivatesAtEachLevel,
        bool deactivatesAtInitialLevel,
        bool delayBeforeActivation,
        int activatesLight,
        int deactivatesLight,
        bool controlByPlayer,
        bool controlByMonsters) {
        PlatformThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("PlatformThinker").Init(
                tagId, 
                minHeight, 
                maxHeight, 
                speed, 
                delay,
                isDoor, 
                fromFloor, 
                fromCeiling,
                floorToCeiling,
                isExtended,
                isActive,
                activatesOnlyOnce,
                deactivatesAtEachLevel,
                deactivatesAtInitialLevel,
                delayBeforeActivation,
                activatesLight,
                deactivatesLight,
                controlByPlayer,
                controlByMonsters);
        }
    }

    static void SetAdjacentPlatform(int tagId, int otherTagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.SetAdjacentPlatform(otherTagId);
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }

    static void SetAdjacentPlatformRules(
        int tagId, 
        bool activatesAdjacentPlatformsWhenActivating,
        bool activatesAdjacentPlatformsWhenDeactivating,
        bool activatesAdjacantPlatformsAtEachLevel,
        bool deactivatesAdjacentPlatformsWhenActivating,
        bool deactivatesAdjacentPlatformsWhenDeactivating) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.SetAdjacentPlatformRules(
                activatesAdjacentPlatformsWhenActivating,
                activatesAdjacentPlatformsWhenDeactivating,
                activatesAdjacantPlatformsAtEachLevel,
                deactivatesAdjacentPlatformsWhenActivating,
                deactivatesAdjacentPlatformsWhenDeactivating);
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }

    static void Activate(int tagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.Activate();
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }
    static void Deactivate(int tagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.Deactivate();
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }
    static void Toggle(int tagId, string monsterClass) {
        // Console.Printf("Monster %s", monsterClass);
        PlatformThinker p = GetInstance(tagId);
        let isPlayer = monsterClass == "MarathonPlayer";
        if(p != null) {
            if(isPlayer) {
                p.Toggle();
            } else {
                p.ToggleMonster();
            }
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }


    static PlatformThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("PlatformThinker");
        PlatformThinker p = null;

        while (p = PlatformThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Platform tag %d does not exist", tagId);
        return null;
    }
}