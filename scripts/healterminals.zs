class HealThinker : Thinker {
    
    PlayerPawn player;
    int tagId;
    string type;
    int factor;

    bool isActive;

    Vector3 activatePos;

    HealThinker Init(
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
        Console.Printf("Activating HealThinker: %d", tagId);
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

    void Toggle() {
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
        HealThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("HealThinker").Init(
                tagId, 
                type,
                factor);
        }
    }

    static void Activate(int tagId) {
        HealThinker p = GetInstance(tagId);
        if(p != null) {
            p.Activate();
        } else {
            Console.Printf("HealTerminal tag %d does not exist", tagId);
        }
    }
    static void Deactivate(int tagId) {
        HealThinker p = GetInstance(tagId);
        if(p != null) {
            p.Deactivate();
        } else {
            Console.Printf("HealTerminal tag %d does not exist", tagId);
        }
    }

    static void Toggle(int tagId) {
        HealThinker p = GetInstance(tagId);
        if(p != null) {
            p.Toggle();
        } else {
            Console.Printf("HealTerminal tag %d does not exist", tagId);
        }
    }

    static HealThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("HealThinker");
        HealThinker p = null;

        while (p = HealThinker(it.next()))
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