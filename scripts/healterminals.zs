class HealTerminalThinker : Thinker {
    
    PlayerPawn player;
    int tagId;
    string type;
    int factor;

    bool isActive;

    Vector3 activatePos;

    HealTerminalThinker Init(
        int tagId, 
        string type,
        int factor) {
        self.tagId = tagId;
        self.type = type;
        self.factor = factor;

        self.isActive = false;

        for (int i = 0; i < Players.size(); i++) {
            self.player = PlayerPawn(Players[i].mo);
            if (self.player != null) {
                break; // Take the first valid player
            }
        }
        
        return self;
    }

    void Activate() {
        Console.Printf("Activating HealTerminalThinker: %d", tagId);
        if(self.isActive) {
            return;
        }
        
        if(self.type == "Save") {
            player.A_StartSound("SAVE", CHAN_BODY, CHANF_DEFAULT, 1);
            Level.MakeAutoSave();
            return;
        }

        if(self.type == "Health") {
            int max = 100 * self.factor;
            if(player.health >= max) {
                return;
            }

            player.A_StartSound("HEAL", CHAN_BODY, CHANF_LOOPING , 1);
        } else {
            int oxygenCount = player.CountInv("OxygenTank");
            if(oxygenCount >= 1000) {
                return;
            }
            player.A_StartSound("AIRFILL", CHAN_BODY, CHANF_LOOPING , 1);
        }
        
        self.activatePos = self.player.pos;
        Switches.Toggle(self.tagId, true);
        self.isActive = true;
    }

    void Deactivate() {
        if(!self.isActive) {
            return;
        }
        Switches.Toggle(self.tagId, false);
        player.A_StopSound(CHAN_BODY);
        
        // Console.Printf("Deactivate %d", tagId);
        self.isActive = false;
    }

    void Interact() {
        if(!self.isActive) {
            Activate();
        } else {
            Deactivate();
        }
    }

    
    override void Tick() {
        if(self.isActive){

            let pos = self.player.pos;
            Vector3 dist = (pos.x - activatePos.x, pos.y - activatePos.y, pos.z - activatePos.z);
            if(dist.Length() > 10.0) {
                Deactivate();
                return;
            };

            if(self.type == "Health") {
                int countPerTick = 2;
                int max = 100 * self.factor;
                if(max - player.health < countPerTick){
                    player.A_SetHealth(max);
                    Deactivate();
                } else {
                    player.A_SetHealth(player.health + countPerTick);
                }
                return;
            }
            if(self.type == "Oxygen") {
                int oxygenCount = player.CountInv("OxygenTank");
                Console.Printf("Oxygen count: %d", oxygenCount);

                int countPerTick = 2;
                int max = 1000;

                if(max - oxygenCount < countPerTick) {
                player.GiveInventory("OxygenTank", max - oxygenCount);
                    Deactivate();
                } else {
                    player.GiveInventory("OxygenTank", countPerTick);
                }
                return;
            }
        }
    }
}

class HealTerminal play {
    static void Init(
        int tagId, 
        string type,
        int factor) {
        HealTerminalThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("HealTerminalThinker").Init(
                tagId, 
                type,
                factor);
        }
    }

    static void Interact(int tagId) {
        HealTerminalThinker p = GetInstance(tagId);
        if(p != null) {
            p.Interact();
        } else {
            Console.Printf("HealTerminal tag %d does not exist", tagId);
        }
    }

    static HealTerminalThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("HealTerminalThinker");
        HealTerminalThinker p = null;

        while (p = HealTerminalThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("HealTerminal tag %d does not exist", tagId);
        return null;
    }
}