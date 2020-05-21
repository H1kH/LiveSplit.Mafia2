state("mafia2")     //should work for update 3 - 5
{
    bool isLoading : 0x16C2778, 0x33C;
    bool inCutscene : 0x16BCD68;
    byte chapter : 0x168D1F0, 0xB8;     //255 is main menu
    string20 finalCutscene : 0x16BE7EC, 0x44, 0x104, 0x4, 0x74;     //thanks Jazz
}

state("Mafia II Definitive Edition")     //Manifest 5603084205041664233
{
    bool isLoading : 0x1CC18C8, 0x424;
    bool inCutscene : 0x1CB33C0;
    byte chapter : 0x1C2E6B0, 0xD0;
    string20 finalCutscene : 0x01CB2D70, 0x4F0;     //thanks Vojtas 
}

startup  //script start
{
    vars.afterCrash = false;
}

init  //game start
{
    vars.fromMenu = false;
    vars.ready = false;
    vars.stopwatch = new Stopwatch();
}

exit  //game exit
{
    timer.IsGameTimePaused = true;
    vars.afterCrash = true;
}

update
{
    if (old.chapter == 255 && current.chapter >= 1 && current.chapter <= 15)
    {
        timer.IsGameTimePaused = false;
        vars.afterCrash = false;
    }

    if (old.chapter != 255 && current.chapter == 255)
    {
        vars.ready = false;
        vars.stopwatch.Reset();
    }

    if (vars.stopwatch.ElapsedMilliseconds > 0)
    {
        if (current.isLoading && vars.stopwatch.IsRunning) vars.stopwatch.Stop();
        else if (!current.isLoading && !vars.stopwatch.IsRunning) vars.stopwatch.Start();
    }
}

reset
{
    if (old.chapter == 255 && current.chapter == 1) return true;
}

start
{
    if (old.chapter == 255 && current.chapter == 1) vars.fromMenu = true;

    if (vars.fromMenu && old.inCutscene && !current.inCutscene)
    {
        vars.fromMenu = false;
        vars.ready = true;
        vars.stopwatch.Restart();
    }

    if (vars.ready && vars.stopwatch.ElapsedMilliseconds > 1400)
    {
        vars.ready = false;
        vars.stopwatch.Reset();
        return true;
    }
}

split
{
    //split on next chapter
    if (current.chapter == old.chapter+1 &&
        old.chapter != 255 &&
        current.chapter >= 1 && current.chapter <= 15) return true;

    //final split
    if (current.chapter == 15 &&
        !old.inCutscene && current.inCutscene &&
        current.finalCutscene == "/sds/fmv/fmv1511.sds") return true;
}

isLoading
{
    if (!vars.afterCrash) return current.isLoading;
}
