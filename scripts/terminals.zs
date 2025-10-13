class TerminalThinker : Thinker {
    
    PlayerPawn player;
    int tagId;
    int levelIndex;
    int terminalIndex;

    array <int> lineIndexes;  
    TextureID currentTex;
    string currentTexName;

    bool isActive;

    int slideIndex;

    Vector3 activatePos;

    TerminalDefinition definition;

    int teleportOnClose;
    bool isLeaving;
    int ticks;
    int teleportTicks;

    TerminalThinker Init(
        int tagId, 
        int levelIndex,
        int terminalIndex) {
        self.tagId = tagId;
        self.levelIndex = levelIndex;
        self.terminalIndex = terminalIndex;

        isLeaving = false;
        ticks = 0;
        slideIndex = 0;
        teleportOnClose = false;
        teleportTicks = 0;

        for (int i = 0; i < TerminalManager.Get().definitions.size(); i++) {
            TerminalDefinition def = TerminalManager.Get().definitions[i];
            if(def.levelIndex == levelIndex && def.terminalIndex == terminalIndex) {
                self.definition = def;
                // Console.Printf("Loaded terminal definition for level %d terminal %d", levelIndex, terminalIndex);
                break;
            }
        }

        self.isActive = false;

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }

        int i;
        LineIdIterator li = Level.CreateLineIdIterator(tagId);
        while((i = li.Next()) >= 0)
        {
            lineIndexes.push(i);
            Line line = level.lines[i];
            Side side = line.sidedef[Line.front];
            currentTex = side.GetTexture(Side.mid);
            currentTexName = TexMan.GetName(currentTex);
        }
        
        return self;
    }

    void Interact() {
        // LevelManager.SetFinished();
        if(self.teleportOnClose > 0){
            Deactivate(true);
            return;
        }

        let isFinished = LevelManager.IsFinished();
        let isFailure = LevelManager.IsFailure();

        let terminalCharacter = getTerminalCharacter();
        let length = terminalCharacter == "F" ? definition.finishedCount : terminalCharacter == "X" ? definition.failureCount : definition.unfinishedCount;
        self.teleportOnClose = false;

        self.isLeaving = false;
        self.ticks = 0;
        self.teleportOnClose = false;

        if(!self.isActive) {
            slideIndex = 0;
        } else if (slideIndex < length - 1) {
            slideIndex++;
        } else {   
            if(definition.finishedCount > 0) {
                // LevelManager.SetFinished();
            }
            Deactivate(true);
            return;
        }

        if(slideIndex == length - 1) {
            self.teleportOnClose = terminalCharacter == "F" ? definition.finishedTeleport : terminalCharacter == "X" ? definition.failureTeleport : definition.unfinishedTeleport; 
            self.isLeaving = true;
            self.ticks = 0;
        }

        let texName = "T";
        if(levelIndex < 10) {
            texName = texName .. "0";
        }
        texName = texName .. levelIndex;
        texName = texName .. terminalIndex;
        texName = texName .. getTerminalCharacter();
        texName = texName .. slideIndex;

        SetTexture(texName, slideIndex == 0 || slideIndex == definition.unfinishedCount - 1 ? "MarathonTerminal" : "MarathonBeep");

        if(self.isActive) {
            return;
        }
   
        self.activatePos = self.player.pos;
        self.isActive = true;
    }
    
    string getTerminalCharacter()
    {
        if(LevelManager.IsFailure() && definition.failureCount > 0) {
            return "X";
        } else if(LevelManager.IsFinished() && definition.finishedCount > 0) {
            return "F";
        } else {
            return "U";
        }
    }

    void Deactivate(bool playSound) {
        if(!self.isActive) {
            return;
        }
        SetTexture(currentTexName, playSound ? "MarathonBeep" : "");
        
        // Console.Printf("Deactivate %d", tagId);
        self.isActive = false;
    }

    void SetTexture(string texName, string sound) {
        for (int i = 0; i < lineIndexes.size(); i++) {    
            Line line = level.lines[lineIndexes[i]];
            Side side = line.sidedef[Line.front];
            TextureID tex = TexMan.CheckForTexture(texName, TexMan.Type_Any);

            side.SetTexture(Side.mid, tex);
            if(sound != "") {
                line.frontsector.StartSoundSequence(0, sound, 0);
            }
        }
    }
    
    override void Tick() {
        if(self.isActive){

            let pos = self.player.pos;
            Vector3 dist = (pos.x - activatePos.x, pos.y - activatePos.y, pos.z - activatePos.z);
            if(dist.Length() > 40.0) {
                Deactivate(false);
                return;
            };

            if(self.isLeaving) {
                self.ticks++;
                if(self.ticks > 35) {
                    self.isLeaving = false;
                    self.ticks = 0;
                    Deactivate(false);
                    return;
                }
            }
        }

        if(self.teleportOnClose > 0 && !self.isActive) {
            self.teleportTicks++;
            if(self.teleportTicks >= 15) {
                Teleport.TeleportOutMapNumber(self.teleportOnClose);
                self.teleportOnClose = false;
                self.teleportTicks = 0;
            }
        }
    }
}

class TerminalDefinition{
    int levelIndex;
    int terminalIndex;
    int unfinishedCount;
    int unfinishedTeleport;
    int finishedCount;
    int finishedTeleport;
    int failureCount;
    int failureTeleport;

    TerminalDefinition Init(int levelIndex, int terminalIndex, int unfinishedCount, int unfinishedTeleport, int finishedCount, int finishedTeleport, int failureCount, int failureTeleport) {
        self.levelIndex = levelIndex;
        self.terminalIndex = terminalIndex;
        self.unfinishedCount = unfinishedCount;
        self.unfinishedTeleport = unfinishedTeleport;
        self.finishedCount = finishedCount;
        self.failureCount = failureCount;
        self.finishedTeleport = finishedTeleport;
        self.failureTeleport = failureTeleport;

        return self;
    }
}

class TerminalManager : Thinker
{
    Array<TerminalDefinition> definitions;

    static TerminalManager Get()
    {
        TerminalManager m;
        ThinkerIterator it = ThinkerIterator.Create("TerminalManager");
        m = TerminalManager(it.Next());
        if (m == null)
        {
            m = new("TerminalManager");
        }

        return m;
    }
}

class Terminal play {
    static void InitDefinitions() {
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(0, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(0, 1, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(0, 2, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(0, 3, 3, 1, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(1, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(1, 1, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(1, 2, 4, 2, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 1, 7, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 2, 3, 0, 3, 3, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 3, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 4, 9, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(2, 5, 3, 0, 3, 3, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(3, 0, 8, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(3, 1, 5, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(3, 2, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(3, 3, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(3, 4, 3, 0, 4, 4, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(4, 0, 7, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(4, 1, 5, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(4, 2, 3, 0, 4, 5, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(5, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(5, 1, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(5, 2, 3, 0, 3, 6, 3, 6));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(5, 3, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(6, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(6, 1, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(6, 2, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(6, 3, 3, 0, 4, 7, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(7, 0, 5, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(7, 1, 3, 0, 4, 8, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(8, 0, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(8, 1, 3, 0, 4, 9, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(9, 0, 4, 0, 3, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(9, 1, 3, 0, 6, 10, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(9, 2, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(9, 3, 3, 10, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(10, 0, 3, 0, 3, 11, 3, 11));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(11, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(11, 1, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(11, 2, 8, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(12, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(12, 1, 4, 13, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(13, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(13, 1, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(13, 2, 5, 14, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(13, 3, 3, -1, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(14, 0, 5, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(14, 1, 5, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(14, 2, 3, 0, 3, 15, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(15, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(15, 1, 3, 16, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(17, 0, 3, 0, 4, 18, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(20, 0, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(20, 1, 6, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(20, 2, 3, 21, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(24, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(24, 1, 3, 25, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(24, 2, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(25, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(25, 1, 3, 0, 4, 26, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(25, 2, 3, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(26, 0, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(26, 1, 4, 0, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(26, 2, 4, 256, 0, 0, 0, 0));
        TerminalManager.Get().definitions.Push(new("TerminalDefinition").Init(26, 3, 3, 0, 0, 0, 0, 0));
    }

    static void Init(
        int tagId, 
        int levelIndex,
        int terminalIndex) {


        TerminalThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("TerminalThinker").Init(
                tagId, 
                levelIndex,
                terminalIndex);
        }
    }

    static void Interact(int tagId) {
        TerminalThinker p = GetInstance(tagId);
        if(p != null) {
            p.Interact();
        } else {
            Console.Printf("Terminal tag %d does not exist", tagId);
        }
    }

    static TerminalThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("TerminalThinker");
        TerminalThinker p = null;

        while (p = TerminalThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Terminal tag %d does not exist", tagId);
        return null;
    }
}