class LevelManager : Thinker
{
    int levelIndex;

    int bobCount;
    int enemyCount;

    int exploredMarkerCount;
    int exploredMarkerTotal;

    int repairPlatformCount;
    int repairPlatformTotal;

    int tagSwitchCount;
    int tagSwitchTotal;

    PlayerPawn player;

    Array<LevelDefinition> definitions;

    LevelManager Init() {
        self.levelIndex = -1;
    
        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }

        for(int i = 0; i < 27; i++) {
            definitions.Push(new("LevelDefinition"));
        }

        definitions[2].retrieval = true;
        definitions[3].repair = true;
        definitions[4].repair = true;
        definitions[5].extermination = true;
        definitions[5].rescue = true;
        definitions[6].repair = true;
        definitions[7].retrieval = true;
        definitions[8].repair = true;
        definitions[9].exploration = true;
        definitions[10].extermination = true;
        definitions[10].exploration = true;
        definitions[14].retrieval = true;
        definitions[16].exploration = true;
        definitions[17].exploration = true;
        definitions[18].exploration = true;
        definitions[19].exploration = true;
        definitions[21].exploration = true;
        definitions[22].extermination = true;
        definitions[22].exploration = true;
        definitions[23].repair = true;
        definitions[25].extermination = true;

// MAP01 - 
// MAP02 - 
// MAP03 - Retrieval
// MAP04 - Repair
// MAP05 - Repair
// MAP06 - Extermination, Rescue
// MAP07 - Repair
// MAP08 - 
// MAP09 - Repair
// MAP10 - Exploration
// MAP11 - Extermination, Exploration
// MAP12 - 
// MAP13 - 
// MAP14 - 
// MAP15 - Retrieval
// MAP16 - 
// MAP17 - Exploration
// MAP18 - Exploration
// MAP19 - Exploration
// MAP20 - Exploration
// MAP21 - 
// MAP22 - Exploration
// MAP23 - Extermination, Exploration
// MAP24 - Repair
// MAP25 - 
// MAP26 - Extermination
// MAP27 - 

        return self;
    }

    LevelDefinition GetCurrentDefinition() {
        if(levelIndex < 0 || levelIndex >= definitions.size()) {
            return null;
        }
        return definitions[levelIndex];
    }

    static bool IsFinished()
    {
        let definition = Get().GetCurrentDefinition();
        if(definition == null) {
            return false;
        }

        if(definition.retrieval) {
            Console.Printf("Check Retrieval state");
            if(Get().player == null) {
                return false;
            }
            let levelIndex = Get().levelIndex;
            if(levelIndex ==2) {
                let inv = Get().player.FindInventory("DefenseChip");
                return inv != null && inv.amount == 3;
            } else if(levelIndex == 7) {
                let inv = Get().player.FindInventory("FusionPistol");
                return inv != null && inv.amount == 1;
            } else if(levelIndex == 15) {
                let inv = Get().player.FindInventory("DefenseChip");
                return inv != null && inv.amount == 1;
            }
            return false;
        }
        if(definition.repair) {
            Console.Printf("Check Repair state");
            return LevelManager.Get().repairPlatformCount == LevelManager.Get().repairPlatformTotal && LevelManager.Get().tagSwitchCount == LevelManager.Get().tagSwitchTotal;
        }
        if(definition.extermination) {
            Console.Printf("Check Extermination state");
            return Get().enemyCount == 0;
        }
        if(definition.exploration) {
            Console.Printf("Check Exploration state");
            return Get().exploredMarkerCount == Get().exploredMarkerTotal;
        }
        return false;
    }

    static bool IsFailure()
    {
        if(!IsFinished()) {
            return false;
        }

        let definition = Get().GetCurrentDefinition();
        if(definition == null) {
            return false;
        }
        
        if(definition.rescue) {
            Console.Printf("Check Rescue fail state");
            return Get().bobCount < 2;
        }

        return false;
    }

    static void SetStart(int tagId) {
        Console.Printf("Setting start index to %d", tagId);
        let levelManager = Get();
        let player = levelManager.player;
        let sti = level.CreateSectorTagIterator(tagId);
        int i;
        if((i = sti.Next()) >= 0)
        {
            // if(levelManager.levelIndex > 0 && player.CurSector != null && player.CurSector.sectornum ==level.sectors[i].sectornum){
            //     Teleport.TeleportIn();
            // } else{
            //     Teleport.RemoveTeleport();
            // }
        }
    }

    static void SetLevelIndex(int levelIndex) {
        Get().levelIndex = levelIndex;
    }

    static LevelManager Get()
    {
        LevelManager m;
        ThinkerIterator it = ThinkerIterator.Create("LevelManager");
        m = LevelManager(it.Next());
        if (m == null)
        {
            m = new("LevelManager").Init();
        }

        return m;
    }

    override void Tick(){
        // Console.Printf("BOBs: %d, Enemies: %d", self.bobCount, self.enemyCount);
        // Console.Printf("Repair Platforms: %d / %d, TagSwitches: %d / %d, Explored Markers: %d / %d", self.repairPlatformCount, self.repairPlatformTotal, self.tagSwitchCount, self.tagSwitchTotal, self.exploredMarkerCount, self.exploredMarkerTotal);
        if(self.player == null){
            return;
        }
        let inv = self.player.FindInventory("DefenseChip");
        if(inv == null) {
            return;
        }
    }
}

class LevelDefinition {
    bool retrieval;
    bool repair;
    bool extermination;
    bool rescue;
    bool exploration;
    bool vacuum;
}