state("mafia2")     //should work for update 3 - 5
{
    bool isLoading : 0x16C2778, 0x33C;
    bool inCutscene : 0x16BCD68;
    byte chapter : 0x168D1F0, 0xB8;     //255 is main menu
    string20 finalCutscene : 0x16BE7EC, 0x44, 0x104, 0x4, 0x74;     //thanks Jazz
}

startup
{
    vars.afterCrash = false;
}

init
{
    vars.fromMenu = false;
    vars.afterFMV = false;
    vars.afterLoading = false;
    vars.stopwatch = new Stopwatch();
}

exit
{
    timer.IsGameTimePaused = true;
    vars.afterCrash = true;
}

update
{
    if (current.chapter >= 1 && current.chapter <= 15 && old.chapter == 255)
    {
        timer.IsGameTimePaused = false;
        vars.afterCrash = false;
    }
}

reset
{
    if (current.chapter == 1 && old.chapter == 255) return true;
}

start
{
    if (current.chapter == 1 && old.chapter == 255) vars.fromMenu = true;

    if (vars.fromMenu && !current.inCutscene && old.inCutscene)
    {
        vars.fromMenu = false;
        vars.afterFMV = true;
    }

    if (vars.afterFMV && !current.isLoading && old.isLoading)
    {
        vars.afterFMV = false;
        vars.afterLoading = true;
        vars.stopwatch.Restart();
    }

    if (vars.afterLoading && vars.stopwatch.ElapsedMilliseconds > 1400)
    {
        vars.afterLoading = false;
        vars.stopwatch.Reset();
        return true;
    }
}

split
{
    //split on next chapter
    if (current.chapter == old.chapter+1 &&
        old.chapter != 255 &&
        current.chapter >= 1 &&
        current.chapter <= 15 )
    {
        return true;
    }

    //final split
    if (current.chapter == 15 &&
        current.inCutscene &&
        !old.inCutscene &&
        current.finalCutscene == "/sds/fmv/fmv1511.sds")
    {
        return true;
    }
}

isLoading
{
    if (!vars.afterCrash) return current.isLoading;
}
