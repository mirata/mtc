class PlatformThinker : Thinker {
    int tagId;
    int controlPanelTagId;
    string type;
    double minHeight;
    double maxHeight;
    double speed;
    int delay;
    int activatorTagId;
    bool isRepairPlatform;

    PlayerPawn player;
    Sector sector;
    bool isDoor;
    bool fromFloor;
    bool fromCeiling;
    bool floorToCeiling;
    bool contractsSlower;
    bool cannotBeExternallyDeactivated;
    bool causesDamage;
    bool reversesDirectionWhenObstructed;
    bool activatesOnlyOnce;
    bool deactivatesAtEachLevel;
    bool deactivatesAtInitialLevel;
    bool delayBeforeActivation;
    int activatesLight;
    int deactivatesLight;
    bool controlByPlayer;
    bool controlByMonsters;

    bool activatesAdjacentPlatformsWhenActivating;
    bool activatesAdjacentPlatformsWhenDeactivating;
    bool activatesAdjacentPlatformsAtEachLevel;
    bool deactivatesAdjacentPlatformsWhenActivating;
    bool deactivatesAdjacentPlatformsWhenDeactivating;
    bool doesNotActivateParent;

    bool isExtended;
    bool isExtending;
    bool isActive;
    bool initialExtended;
    bool beenActivated;

    bool previousActive;
    bool previousExtending;
    bool isDelaying;
    int delayTicks;
    bool hitLimit;
    double lastCombinedDelta;
    bool obstructReverse;

    double minFloor;
    double maxFloor;
    double minCeiling;
    double maxCeiling;

    array <int> sectorIndexes;
    array <int> adjacentPlatformTags;

    PlatformThinker Init(
        int tagId, 
        int controlPanelTagId,
        string type,
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
        bool contractsSlower,
        bool cannotBeExternallyDeactivated,
        bool causesDamage,
        bool reversesDirectionWhenObstructed,
        bool activatesOnlyOnce,
        bool deactivatesAtEachLevel,
        bool deactivatesAtInitialLevel,
        bool delayBeforeActivation,
        int activatesLight,
        int deactivatesLight,
        bool controlByPlayer,
        bool controlByMonsters) {
        self.tagId = tagId;
        self.controlPanelTagId = controlPanelTagId;
        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        while((i = sti.Next()) >= 0)
        {
            self.sectorIndexes.Push(i);
            if(self.sector == null) {
                self.sector = level.sectors[i];
            }
        }

        if(self.sector == null) {
            Console.Printf("PlatformThinker: Sector with tag %d not found", tagId);
            return null;
        }

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }

        self.type = type;

        //we do this to allow an invisible amount of space between sectors - this allows sound propagation!
        self.minHeight = float(minHeight) + float(0.000000001);
        self.maxHeight = float(maxHeight) - float(0.000000001);

        self.speed = speed;
        self.delay = delay;
        self.isDoor = isDoor;

        self.fromFloor = fromFloor;
        self.fromCeiling = fromCeiling; 
        self.floorToCeiling = floorToCeiling;
        self.isExtended = isExtended;
        self.isActive = isActive;
        self.contractsSlower = contractsSlower;
        self.cannotBeExternallyDeactivated = cannotBeExternallyDeactivated;
        self.causesDamage = causesDamage;
        self.reversesDirectionWhenObstructed = reversesDirectionWhenObstructed;
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
        self.lastCombinedDelta = 0;
        self.obstructReverse = false;

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
                // Console.Printf("Move Floor %d", maxFloor);
                for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                    level.sectors[self.sectorIndexes[i]].MoveFloor(self.maxFloor + sector.floorplane.d, -self.maxFloor, 0, 1, false); 
                }
            }
        
            if(self.fromCeiling){
                // Console.Printf("Move Ceiling %d", minCeiling);
                for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                    let cur = sector.ceilingplane.d;
                    level.sectors[self.sectorIndexes[i]].MoveCeiling(sector.ceilingplane.d - self.minCeiling, self.minCeiling, 0, -1, false); 
                }
            }
        }

        if(!isDoor && controlByPlayer) {
            Polygon.Init(tagId, "PlatformActivate", tagId);
        }

        return self;
    }
    
    void GetAdjacentPlatformTags() {
        int i;
        PlatformThinker adjacent = null;
        for(i = 0; i < self.sector.lines.Size(); i++) {
            let line = self.sector.lines[i];
            if(line.frontsector != null && line.frontsector.Index() != self.sector.Index()) {
                let platform = Platform.GetInstanceBySector(line.frontsector);
                if(platform != null) {
                    Utils.AddUniqueInt(self.adjacentPlatformTags, platform.tagId);
                }
            }
            if(line.backsector != null && line.backsector.Index() != self.sector.Index()) {
                let platform = Platform.GetInstanceBySector(line.backsector);
                if(platform != null) {
                    Utils.AddUniqueInt(self.adjacentPlatformTags, platform.tagId);
                }
            }
        }
    }

    void SetAdjacentPlatformRules(
        bool activatesAdjacentPlatformsWhenActivating,
        bool activatesAdjacentPlatformsWhenDeactivating,
        bool activatesAdjacentPlatformsAtEachLevel,
        bool deactivatesAdjacentPlatformsWhenActivating,
        bool deactivatesAdjacentPlatformsWhenDeactivating,
        bool doesNotActivateParent) {
        self.activatesAdjacentPlatformsWhenActivating = activatesAdjacentPlatformsWhenActivating;
        self.activatesAdjacentPlatformsWhenDeactivating = activatesAdjacentPlatformsWhenDeactivating;
        self.activatesAdjacentPlatformsAtEachLevel = activatesAdjacentPlatformsAtEachLevel;
        self.deactivatesAdjacentPlatformsWhenActivating = deactivatesAdjacentPlatformsWhenActivating;
        self.deactivatesAdjacentPlatformsWhenDeactivating = deactivatesAdjacentPlatformsWhenDeactivating;
        self.doesNotActivateParent = doesNotActivateParent;
        GetAdjacentPlatformTags();
    }

    void SetRepairPlatform() {
        self.isRepairPlatform = true;
    }

    void ActivateFrom(int activatorTagId) {
        if(self.isActive || (self.activatesOnlyOnce && self.beenActivated)) {
            return;
        }
        self.activatorTagId = activatorTagId;

        // if(self.tagId == 145){
            
        //                     for (int i = 0; i < Players.size(); i++) {
        //                     let player = PlayerPawn(Players[i].mo);

                            
        //                     player.DamageMobj(player, player, 22, "Crush");
        //                     break;
        //                     }
        // }
        // Console.Printf("Activate %d", tagId);
        if(self.isRepairPlatform) {
            LevelManager.Get().repairPlatformCount++;
        }

        Switches.Toggle(self.controlPanelTagId, true);
        
        if(self.activatesLight >= 0) {
            Light.Activate(self.activatesLight);
        }
        if(self.deactivatesLight >= 0) {
            Light.Deactivate(self.deactivatesLight);
        }
        self.isActive = true;
        self.beenActivated = true;
        self.isDelaying = false;
        self.delayTicks = 0;
    }

    void Activate() {
        ActivateFrom(-1);
    }

    void Deactivate() {
        if(!self.isActive) {
            return;
        }
        Switches.Toggle(self.controlPanelTagId, false);
        
        // Console.Printf("Deactivate %d", tagId);
        self.isActive = false;
        self.isDelaying = false;
        self.delayTicks = 0;
    }

    void Toggle() {
        //Console.Printf("Toggle %d", tagId);
        self.isDelaying = false;
        self.delayTicks = 0;
        self.hitLimit = false;
        if(!self.isActive) {
            Activate();
            if(self.isDoor){ 
            }
        } else {
            if(self.cannotBeExternallyDeactivated) {
                return;
            }
            if(self.isDoor)
            {
                self.isExtending = !self.isExtending;
            }
            else{
                Deactivate();
            }
        }
    }

    void ToggleTouch() {
        
        if(self.isDoor && !self.controlByPlayer) {
            sector.StartSoundSequence(0, "MarathonDoorStuck", 0);
            return;
        }
        Toggle();
    }

    void ToggleTouchMonster() {
        
        if(!self.controlByMonsters) {
            return;
        }
        if(self.isDoor && (!self.isActive || self.isExtending)) {
            self.isDelaying = false;
            self.delayTicks = 0;
            Activate();
        }
    }

    void ActivateAdjacentPlatforms() {
        for (int i = 0; i < adjacentPlatformTags.Size(); i++) 
        {
            if(self.doesNotActivateParent && adjacentPlatformTags[i] == self.activatorTagId) {
                Console.Printf("Not activating %d", adjacentPlatformTags[i]);
                continue;
            }
            Console.Printf("Activating %d", adjacentPlatformTags[i]);
            Platform.ActivateFrom(adjacentPlatformTags[i], self.tagId);
        }
    }

    void DeactivateAdjacentPlatforms() {
        for (int i = 0; i < adjacentPlatformTags.Size(); i++) 
        {
            Platform.Deactivate(adjacentPlatformTags[i]);
        }
    }

    override void Tick() {
        double originalFloorHeight = sector.floorplane.d;
        double originalCeilingHeight = sector.ceilingplane.d;

        if(self.isActive) {
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
                    if(self.isExtending) {  
                        //Console.Printf("Extending"); 
                        for(int i = 0; i < self.sectorIndexes.Size(); i++) {        
                            level.sectors[self.sectorIndexes[i]].MoveFloor(self.speed, -self.maxFloor, 0, 1, false); 
                        }
                    }
                    else{    
                        //Console.Printf("Contracting");         
                        for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                            level.sectors[self.sectorIndexes[i]].MoveFloor(self.contractsSlower ? self.speed / 6 : self.speed, -self.minFloor, 0, -1, false); 
                        }
                     }
                    floorHeight = sector.floorplane.d;
                }
                if(self.fromCeiling){
                    let cur = sector.ceilingplane.d;
                    if(isExtending){           
                        for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                            level.sectors[self.sectorIndexes[i]].MoveCeiling(self.speed, self.minCeiling, 0, -1, false); 
                        }
                    }
                    else{    
                        //Console.Printf("Opening");
                        for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                            level.sectors[self.sectorIndexes[i]].MoveCeiling(self.contractsSlower ? self.speed / 6 : self.speed, self.maxCeiling, 0, 1, false); 
                        }
                    }
                    ceilingHeight = sector.ceilingplane.d;
                    
                    for(int i = 0; i < self.sectorIndexes.Size(); i++) {
                        for(int j = 0; j < level.sectors[self.sectorIndexes[i]].lines.Size(); j++) {
                            let line = level.sectors[self.sectorIndexes[i]].lines[j];
                                
                            Side side0 = line.sidedef[0];
                            if(side0 != null) {
                                let off = side0.GetTextureYOffset(Side.mid);
                                off += (cur - level.sectors[self.sectorIndexes[i]].ceilingplane.d);
                                side0.SetTextureYOffset(Side.mid, off);
                            }
                            Side side1 = line.sidedef[1];
                            if(side1 != null) {
                                let off = side1.GetTextureYOffset(Side.mid);
                                off += (cur - level.sectors[self.sectorIndexes[i]].ceilingplane.d);
                                side1.SetTextureYOffset(Side.mid, off);
                            }
                        }
                    }
                }

                if (player != null && Utils.OverlapsSector(player, sector))
                {
                    // Player overlaps this platform's sector; compute a seam-aware ceiling/floor
                    // using all sectors the player's radius touches.
                    Array<int> touched;
                    double effectiveCeiling = 1e30;
                    Utils.GetOverlappedSectorIndexes(player, touched, 16, 3, player.radius);

                    for (int ts = 0; ts < touched.Size(); ts++)
                    {
                        let s = level.sectors[touched[ts]];
                        if (s == null) continue;
                        effectiveCeiling = min(effectiveCeiling, s.ceilingplane.d);
                    }

                    // Only treat this as an obstruction while the platform is closing (reducing space).
                    // When retracting/opening, transient overlaps can happen and we don't want reversal loops.
                    bool isClosing = (self.fromFloor && self.isExtending) || (self.fromCeiling && self.isExtending);
                    if (isClosing)
                    {
                        // Same clearance math as before, but using the tightest corridor.
                        let space = effectiveCeiling + floorHeight - player.Height;
                        // Console.Printf("Effective Floor: %f, Effective Ceiling: %f, Space: %f", floorHeight, effectiveCeiling, space);
                        if (space <= 0)
                        {
                            if (self.causesDamage)
                            {
                                if (self.reversesDirectionWhenObstructed)
                                {
                                    player.A_StartSound("CRUNCH", CHAN_BODY, CHANF_DEFAULT, 1);
                                    player.DamageMobj(player, player, 22, "Crush");
                                }
                                else
                                {
                                    player.DamageMobj(player, player, 999, "Crush");
                                }
                            }

                            if (self.reversesDirectionWhenObstructed)
                            {
                                // Console.Printf("Obstruction!: %f", space);
                                self.obstructReverse = true;
                                // Console.Printf("Reversing direction due to obstruction");
                                self.isExtending = !self.isExtending;
                            }
                        }
                    }
                }

                if((self.fromFloor && ((self.isExtending && -floorHeight >= self.maxFloor) || (!self.isExtending && -floorHeight <= self.minFloor)))  ||
                    (self.fromCeiling && ((self.isExtending && ceilingHeight <= self.minCeiling) || (!self.isExtending && ceilingHeight >= self.maxCeiling))) ) {
                        self.hitLimit = true;
                        self.isExtended = self.isExtending;
                        if((self.deactivatesAtInitialLevel && self.isExtended == self.initialExtended) || self.deactivatesAtEachLevel) {
                            Deactivate();
                            
                            if(self.activatesAdjacentPlatformsWhenDeactivating) {
                                ActivateAdjacentPlatforms();
                            }
                            if(self.deactivatesAdjacentPlatformsWhenDeactivating) {
                                DeactivateAdjacentPlatforms();
                            }
                            self.isExtending = !self.isExtending;
                        }
                        //Console.Printf("Yo");

                    // 
                }
            }
            
            // Console.Printf("Heights %d %d", floorHeight, ceilingHeight);
        }


        double floorDelta = originalFloorHeight - sector.floorplane.d;
        double ceilingDelta =  originalCeilingHeight - sector.ceilingplane.d;
        double combinedDelta = floorDelta + ceilingDelta;

        if(combinedDelta == 0 && lastCombinedDelta != 0) {
            if(!self.isDoor) {
                if(self.type == "HeavySphtPlatform" || self.type == "NoisySphtPlatform") {
                    sector.StartSoundSequence(0, "MarathonPlatformStop", 0);
                }
            }

        }
        if((combinedDelta != 0 && lastCombinedDelta == 0) || combinedDelta > 0 && lastCombinedDelta < 0 || combinedDelta < 0 && lastCombinedDelta > 0) {
            if(self.isDoor) {               
                if(self.obstructReverse) {
                    self.obstructReverse = false;
                    Console.Printf("Obstruct!");
                    sector.StartSoundSequence(0, "MarathonDoorStuck", 0);
                } else if(combinedDelta > 0) {
                    Console.Printf("Extend!");
                    sector.StartSoundSequence(0, "MarathonDoorClose", 0);
                } else {
                    Console.Printf("Retract!");
                    sector.StartSoundSequence(0, "MarathonDoorOpen", 0);
                }
            } else{
                if(self.type == "HeavySphtPlatform" || self.type == "NoisySphtPlatform") {
                    sector.StartSoundSequence(0, "MarathonPlatformStart", 0);
                }
            }

            if(self.activatesAdjacentPlatformsWhenActivating) {
                ActivateAdjacentPlatforms();
            }
            if(self.deactivatesAdjacentPlatformsWhenActivating) {
                DeactivateAdjacentPlatforms();
            }
        }
        // if(combinedDelta > 0 && lastCombinedDelta < 0 || combinedDelta < 0 && lastCombinedDelta > 0) {
        //     Console.Printf("Reverse!");
        // }
        self.lastCombinedDelta = combinedDelta;
        //sounds 

        if(self.hitLimit) {
            self.isDelaying = true;
            self.hitLimit = false;
            
        }
        self.previousActive = self.isActive;
        self.previousExtending = self.isExtending;
    }
}

class Platform play {
    static void Init(
        int tagId, 
        int controlPanelTagId,
        string type,
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
        bool contractsSlower,
        bool cannotBeExternallyDeactivated,
        bool causesDamage,
        bool reversesDirectionWhenObstructed,
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
                controlPanelTagId,
                type,
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
                contractsSlower,
                cannotBeExternallyDeactivated,
                causesDamage,
                reversesDirectionWhenObstructed,
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

    static void SetAdjacentPlatformRules(
        int tagId, 
        bool activatesAdjacentPlatformsWhenActivating,
        bool activatesAdjacentPlatformsWhenDeactivating,
        bool activatesAdjacentPlatformsAtEachLevel,
        bool deactivatesAdjacentPlatformsWhenActivating,
        bool deactivatesAdjacentPlatformsWhenDeactivating,
        bool doesNotActivateParent) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.SetAdjacentPlatformRules(
                activatesAdjacentPlatformsWhenActivating,
                activatesAdjacentPlatformsWhenDeactivating,
                activatesAdjacentPlatformsAtEachLevel,
                deactivatesAdjacentPlatformsWhenActivating,
                deactivatesAdjacentPlatformsWhenDeactivating,
                doesNotActivateParent);
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }

    static void SetRepairPlatform(
        int tagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            
            LevelManager.Get().repairPlatformTotal++;
            p.SetRepairPlatform();
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

    static void ActivateFrom(int tagId, int activatorTagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.ActivateFrom(activatorTagId);
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

    static void Toggle(int tagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.Toggle();
        } else {
            Console.Printf("Platform tag %d does not exist", tagId);
        }
    }

    static void ToggleTouch(int tagId, string monsterClass) {
        // Console.Printf("Monster %s", monsterClass);
        PlatformThinker p = GetInstance(tagId);
        let isPlayer = monsterClass == "MarathonPlayer";
        if(p != null) {
            if(isPlayer) {
                p.ToggleTouch();
            } else {
                p.ToggleTouchMonster();
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

    

    static PlatformThinker GetInstanceBySector(Sector sector) {
        ThinkerIterator it = ThinkerIterator.Create("PlatformThinker");
        PlatformThinker p = null;

        while (p = PlatformThinker(it.next()))
        {
            if(p.sector == sector) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Platform tag %d does not exist", tagId);
        return null;
    }
}