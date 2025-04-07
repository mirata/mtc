class PlatformThinker : Thinker {
    int tagId;
    double minHeight;
    double maxHeight;
    double speed;

    int sectorIndex;
    bool isDoor;
    bool fromFloor;
    bool fromCeiling;
    bool isActive;
    bool isExtending;

    array <int> activateSectorTags;

    PlatformThinker Init(int tagId, double minHeight, double maxHeight, double speed, bool isDoor, bool fromFloor, bool fromCeiling) {
        self.tagId = tagId;
        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        if((i = sti.Next()) >= 0)
        {
            self.sectorIndex = i;
        }
        self.isActive = false;
        self.isExtending = true;

        self.fromFloor = fromFloor;
        self.fromCeiling = fromCeiling; 
        self.isDoor = isDoor;
    
        self.minHeight = minHeight;
        self.maxHeight = maxHeight;
        self.speed = speed / 8;

        return self;
    }

    void AddActivateSectorTag(int tagId) {
        activateSectorTags.Push(tagId);
    }

    void Activate() {
        Console.Printf("Activate %d", tagId);
        self.isActive = true;
        level.sectors[self.sectorIndex].StartSoundSequence(0, "MarathonPlatformStart", 0);
    }

    void Deactivate() {
        Console.Printf("Deactivate %d", tagId);
        self.isActive = false;
        level.sectors[self.sectorIndex].StartSoundSequence(0, "MarathonPlatformStop", 0);
    }

    void Toggle() {
        Console.Printf("Toggle %d", tagId);
        if(self.isActive) {
            Deactivate();
        } else {
            Activate();
        }
    }

    override void Tick() {
        if(self.isActive) {
            double floorHeight = level.sectors[self.sectorIndex].floorplane.d;
            double celingHeight = level.sectors[self.sectorIndex].ceilingplane.d;
            if(self.fromFloor){
                level.sectors[self.sectorIndex].MoveFloor(self.speed, -self.maxHeight, 0, 1, false); 
                floorHeight = level.sectors[self.sectorIndex].floorplane.d;
            }
            if(self.fromCeiling){
                level.sectors[self.sectorIndex].MoveCeiling(self.speed, -self.minHeight, 0, -1, false); 
                celingHeight = level.sectors[self.sectorIndex].ceilingplane.d;
            }
            if(-floorHeight >= self.maxHeight) {
                self.isExtending = false;
                Deactivate();
                level.sectors[self.sectorIndex].StartSoundSequence(0, "MarathonPlatformStop", 0);
                for (int i = 0; i < activateSectorTags.Size(); i++) 
                {
                    Platforms.Activate(activateSectorTags[i]);
                }
            }
        }
    }
}

class Platforms play {
    static void Init(int tagId, double minHeight, double maxHeight, double speed, bool isDoor, bool fromFloor, bool fromCeiling) {
        PlatformThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("PlatformThinker").Init(tagId, minHeight, maxHeight, speed, isDoor, fromFloor, fromCeiling);
        }
    }

    static void AddActivateSectorTag(int tagId, int otherTagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.AddActivateSectorTag(otherTagId);
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
    static void Toggle(int tagId) {
        PlatformThinker p = GetInstance(tagId);
        if(p != null) {
            p.Toggle();
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