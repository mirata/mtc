class LightThinker : Thinker {
    int tagId;

    bool isActive;
    int state; //0 = active1, 1 = active2, 2 = inactive1, 3 = inactive2, 4 = activating, 5 = deactivating
    int ticks;
    float originalIntensity;

    string active1Fn;
    int active1Period;
    int active1PeriodDelta;
    int active1Intensity;
    int active1IntensityDelta;

    string active2Fn;
    int active2Period;
    int active2PeriodDelta;
    int active2Intensity;
    int active2IntensityDelta;

    string inactive1Fn;
    int inactive1Period;
    int inactive1PeriodDelta;
    int inactive1Intensity;
    int inactive1IntensityDelta;

    string inactive2Fn;
    int inactive2Period;
    int inactive2PeriodDelta;
    int inactive2Intensity;
    int inactive2IntensityDelta;

    string activatingFn;
    int activatingPeriod;
    int activatingPeriodDelta;
    int activatingIntensity;
    int activatingIntensityDelta;

    string deactivatingFn;
    int deactivatingPeriod;
    int deactivatingPeriodDelta;
    int deactivatingIntensity;
    int deactivatingIntensityDelta;

    array <Sector> sectors;

    LightThinker Init(
    int tagId, 
    bool isActive, 
    string active1Fn,
    int active1Period,
    int active1PeriodDelta,
    int active1Intensity,
    int active1IntensityDelta,
    string active2Fn,
    int active2Period,
    int active2PeriodDelta,
    int active2Intensity,
    int active2IntensityDelta,
    string inactive1Fn,
    int inactive1Period,
    int inactive1PeriodDelta,
    int inactive1Intensity,
    int inactive1IntensityDelta,
    string inactive2Fn,
    int inactive2Period,
    int inactive2PeriodDelta,
    int inactive2Intensity,
    int inactive2IntensityDelta,
    string activatingFn,
    int activatingPeriod,
    int activatingPeriodDelta,
    int activatingIntensity,
    int activatingIntensityDelta,
    string deactivatingFn,
    int deactivatingPeriod,
    int deactivatingPeriodDelta,
    int deactivatingIntensity,
    int deactivatingIntensityDelta) {
        self.tagId = tagId;
        self.isActive = isActive;

        self.active1Fn = active1Fn;
        self.active1Period = active1Period;
        self.active1Intensity = active1Intensity;
        self.active1IntensityDelta = active1IntensityDelta;

        self.active2Fn = active2Fn;
        self.active2Period = active2Period;
        self.active2Intensity = active2Intensity;
        self.active2IntensityDelta = active2IntensityDelta;

        self.inactive1Fn = inactive1Fn;
        self.inactive1Period = inactive1Period;
        self.inactive1Intensity = inactive1Intensity;
        self.inactive1IntensityDelta = inactive1IntensityDelta;

        self.inactive2Fn = inactive2Fn;
        self.inactive2Period = inactive2Period;
        self.inactive2Intensity = inactive2Intensity;
        self.inactive2IntensityDelta = inactive2IntensityDelta;

        self.activatingFn = activatingFn;
        self.activatingPeriod = activatingPeriod;
        self.activatingIntensity = activatingIntensity;
        self.activatingIntensityDelta = activatingIntensityDelta;

        self.deactivatingFn = deactivatingFn;
        self.deactivatingPeriod = deactivatingPeriod;
        self.deactivatingIntensity = deactivatingIntensity;
        self.deactivatingIntensityDelta = deactivatingIntensityDelta;

        self.state =  isActive ? 0 : 2;
        self.ticks = 0;

        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        while((i = sti.Next()) >= 0)
        {
            self.sectors.Push(level.sectors[i]);
        }

        return self;
    }

    void Activate() {
        if(self.state == 0 || self.state == 1 || self.state == 4) {
            return;
        }
        
        Console.Printf("Activate %d", tagId);
        self.originalIntensity = self.sectors[0].GetLightLevel();
        self.state = 4;
        self.ticks = 0;
    }

    void Deactivate() {
        if(self.state == 2 || self.state == 3 || self.state == 5) {
            return;
        }
        
        Console.Printf("Deactivate %d", tagId);
        self.originalIntensity = self.sectors[0].GetLightLevel();
        self.state = 5;
        self.ticks = 0;
    }

    void Toggle() {

    }

    override void Tick() {
        
        if(self.state == 4) {
        
            float intensity = lightFn(self.originalIntensity, self.active1Fn, self.active1Period, self.active1Intensity, self.active1IntensityDelta, self.ticks);
            if(self.ticks < self.active1Period) {
                for(int i = 0; i < self.sectors.Size(); i++) {
                    self.sectors[i].SetLightLevel(int(intensity));
                }
            }
            self.ticks++;
        }
    }

    float lightFn(int originalIntensity, string fn, int period, int intensity, int intensityDelta, int ticks) {
        float frac;
        float v;
        switch(GetNumeric(fn))
        {
            case 0:
                return intensity;
            case 1:
                frac = float(intensity - originalIntensity) / period;
                v = originalIntensity + (frac * ticks);
                
                break;
            case 2:
                frac = float(intensity - originalIntensity) / period;
                v = originalIntensity + (frac * ticks);
                break;
            case 3:
                int d = Random(-intensityDelta, intensityDelta);
                frac = float(intensity - originalIntensity) / period;
                v = originalIntensity + (frac * ticks) + d;
                Console.Printf("Flicker %d", d);
                break;
            default:
                break;
        }
        
        if(v > 255)
        {
            v = 255;
        }
        else if(v < 100)
        {
            v = 100;
        }
        return v;
    }

    int GetNumeric(string fn) {
        if(fn == "Constant") {
            return 0;
        } else if(fn == "Linear") {
            return 1;
        } else if(fn == "Smooth") {
            return 2;
        } else if(fn == "Flicker") {
            return 3;
        } else {
            return -1;
        }
    }
}

class Light play {
    static void Init(
        int tagId, 
        bool isActive,
        string active1Fn,
        int active1Period,
        int active1PeriodDelta,
        int active1Intensity,
        int active1IntensityDelta,
        string active2Fn,
        int active2Period,
        int active2PeriodDelta,
        int active2Intensity,
        int active2IntensityDelta,
        string inactive1Fn,
        int inactive1Period,
        int inactive1PeriodDelta,
        int inactive1Intensity,
        int inactive1IntensityDelta,
        string inactive2Fn,
        int inactive2Period,
        int inactive2PeriodDelta,
        int inactive2Intensity,
        int inactive2IntensityDelta,
        string activatingFn,
        int activatingPeriod,
        int activatingPeriodDelta,
        int activatingIntensity,
        int activatingIntensityDelta,
        string deactivatingFn,
        int deactivatingPeriod,
        int deactivatingPeriodDelta,
        int deactivatingIntensity,
        int deactivatingIntensityDelta) {
        LightThinker p = GetInstance(tagId);
        if(p == null) {
            p = new ("LightThinker").Init(
                tagId, 
                isActive,
                active1Fn,
                active1Period,
                active1PeriodDelta,
                active1Intensity,
                active1IntensityDelta,
                active2Fn,
                active2Period,
                active2PeriodDelta,
                active2Intensity,
                active2IntensityDelta,
                inactive1Fn,
                inactive1Period,
                inactive1PeriodDelta,
                inactive1Intensity,
                inactive1IntensityDelta,
                inactive2Fn,
                inactive2Period,
                inactive2PeriodDelta,
                inactive2Intensity,
                inactive2IntensityDelta,
                activatingFn,
                activatingPeriod,
                activatingPeriodDelta,
                activatingIntensity,
                activatingIntensityDelta,
                deactivatingFn,
                deactivatingPeriod,
                deactivatingPeriodDelta,
                deactivatingIntensity,
                deactivatingIntensityDelta);
        }
    }

    static void Activate(int tagId) {
        LightThinker p = GetInstance(tagId);
        if(p != null) {
            p.Activate();
        } else {
            Console.Printf("Light tag %d does not exist", tagId);
        }
    }
    static void Deactivate(int tagId) {
        LightThinker p = GetInstance(tagId);
        if(p != null) {
            p.Deactivate();
        } else {
            Console.Printf("Light tag %d does not exist", tagId);
        }
    }
    static void Toggle(int tagId) {
        LightThinker p = GetInstance(tagId);
        if(p != null) {
            p.Toggle();
        } else {
            Console.Printf("Light tag %d does not exist", tagId);
        }
    }


    static LightThinker GetInstance(int tagId) {
        ThinkerIterator it = ThinkerIterator.Create("LightThinker");
        LightThinker p = null;

        while (p = LightThinker(it.next()))
        {
            if(p.tagId == tagId) {
                //Console.Printf("Found existing thinker for tag %d", tagId);
                return p;
            }
        }
        //Console.Printf("Light tag %d does not exist", tagId);
        return null;
    }
}