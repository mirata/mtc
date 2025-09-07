class LightThinker : Thinker {
    int tagId;
    int controlPanelTagId;

    bool isActive;
    int state; //0 = active1, 1 = active2, 2 = inactive1, 3 = inactive2, 4 = activating, 5 = deactivating
    int ticks;
    float startTransitionIntensity;
    float currentIntensity;

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

    array <int> sectorIndexes;

    LightThinker Init(
    int tagId, 
    int controlPanelTagId,
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
        self.controlPanelTagId = controlPanelTagId;
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

        self.state =  isActive ? 1 : 3; //transition to active2 or inactive2
        self.startTransitionIntensity = isActive ? active1Intensity : inactive1Intensity;
        self.currentIntensity = self.startTransitionIntensity;
        self.ticks = 0;

        SectorTagIterator sti = level.CreateSectorTagIterator(tagId);
        int i;

        while((i = sti.Next()) >= 0)
        {
            self.sectorIndexes.Push(i);
        }

        return self;
    }

    void Activate() {
        if(self.state == 0 || self.state == 1 || self.state == 4) {
            return;
        }
        Switches.Toggle(self.controlPanelTagId, true);
        
        // Console.Printf("Activate %d", tagId);
        self.startTransitionIntensity = self.currentIntensity;
        self.state = 4;
        self.ticks = 0;
    }

    void Deactivate() {
        if(self.state == 2 || self.state == 3 || self.state == 5) {
            return;
        }
        
        Switches.Toggle(self.controlPanelTagId, false);
        // Console.Printf("Deactivate %d", tagId);
        self.startTransitionIntensity = self.currentIntensity;
        self.state = 5;
        self.ticks = 0;
    }

    void Toggle() {
        if(self.state == 0 || self.state == 1 || self.state == 4) {
            Deactivate();
        } else if(self.state == 2 || self.state == 3 || self.state == 5) {
            Activate();
        }
    }

    override void Tick() {
        string fn;
        int period;
        int intensity;
        int intensityDelta;

        if(self.state == 0) {
            fn = self.active1Fn;
            period = self.active1Period + Random(-self.active1PeriodDelta, self.active1PeriodDelta);
            intensity = self.active1Intensity;
            intensityDelta = self.active1IntensityDelta;
        } else if(self.state == 1) {
            fn = self.active2Fn;
            period = self.active2Period + Random(-self.active2PeriodDelta, self.active2PeriodDelta);
            intensity = self.active2Intensity;
            intensityDelta = self.active2IntensityDelta;
        } else if(self.state == 2) {
            fn = self.inactive1Fn;
            period = self.inactive1Period + Random(-self.inactive1PeriodDelta, self.inactive1PeriodDelta);
            intensity = self.inactive1Intensity;
            intensityDelta = self.inactive1IntensityDelta;
        } else if(self.state == 3) {
            fn = self.inactive2Fn;
            period = self.inactive2Period + Random(-self.inactive2PeriodDelta, self.inactive2PeriodDelta);
            intensity = self.inactive2Intensity;
            intensityDelta = self.inactive2IntensityDelta;
        } else if(self.state == 4) {
            fn = self.activatingFn;
            period = self.activatingPeriod + Random(-self.activatingPeriodDelta, self.activatingPeriodDelta);
            intensity = self.activatingIntensity;
            intensityDelta = self.activatingIntensityDelta;
        } else if(self.state == 5) {
            fn = self.deactivatingFn;
            period = self.deactivatingPeriod + Random(-self.deactivatingPeriodDelta, self.deactivatingPeriodDelta);
            intensity = self.deactivatingIntensity;
            intensityDelta = self.deactivatingIntensityDelta;
        }

        self.currentIntensity = lightFn(self.startTransitionIntensity, fn, period, intensity, intensityDelta, self.ticks);
        for(int i = 0; i < self.sectorIndexes.Size(); i++) {
            level.sectors[self.sectorIndexes[i]].SetLightLevel(int(currentIntensity));
        }
        if(self.ticks >= period) {
            self.ticks = 0;
            self.startTransitionIntensity = intensity;
            if(self.state == 4 && self.active1Period > 0) {
                // Console.Printf("Active 1");
                self.state = 0;
            } else if(self.state == 5 && self.inactive1Period > 0) {
                // Console.Printf("Inactive 1");
                self.state = 2;
            } else if(self.state == 0 && self.active2Period > 0) {
                // Console.Printf("Active 2");
                self.state = 1;
            } else if(self.state == 1 && self.active1Period > 0) {
                // Console.Printf("Active 1");
                self.state = 0;
            } else if(self.state == 2 && self.inactive2Period > 0) {
                // Console.Printf("Inactive 2");
                self.state = 3;
            } else if(self.state == 3 && self.inactive1Period > 0) {
                // Console.Printf("Inactive 1");
                self.state = 2;
            }
        }
        self.ticks++;
    }


    //i think this is the wrong way around?  immediately go to active2?

    float lightFn(float startTransitionIntensity, string fn, int period, int intensity, int intensityDelta, int ticks) {
        float frac;
        float v;
        switch(GetNumeric(fn))
        {
            case 0:
                //Console.Printf("Constant %d", intensity);
                return intensity;
            case 1:
                frac = (float(intensity) - startTransitionIntensity) / period;
                v = startTransitionIntensity + (frac * ticks );
                // Console.Printf("Linear %f",v);
                
                break;
            case 2:
                //sin wave between 0 and 1
                float val = Sin(float(ticks) / period * 180 - 90) / 2 + 0.5; 
                frac = (float(intensity) - startTransitionIntensity) * val;
                v = startTransitionIntensity + frac;
                // Console.Printf("Smooth %f", v);
                break;
            case 3:
                int d = Random(-intensityDelta, intensityDelta);
                frac = float(intensity - startTransitionIntensity) / period;
                v = startTransitionIntensity + (frac * ticks ) + d;
                // Console.Printf("Flicker %f", v);
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
        int controlPanelTagId,
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
                controlPanelTagId,
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