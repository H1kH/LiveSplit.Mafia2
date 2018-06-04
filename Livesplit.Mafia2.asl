state("mafia2")         //should work for update 3 - 5
{
    bool isLoading : 0x16C2778, 0x33C;
    bool inCutscene : 0x16BCD68;
    byte chapter : 0x168D1F0, 0xB8;
    string20 finalCutscene : 0x16BE7EC, 0x44, 0x104, 0x4, 0x74;      //thanks Jazz
}

init
{      
    vars.fromMenu = false;
    vars.afterCutscene = false;
}

reset
{
    if (current.chapter == 1 && old.chapter == 255) return true;
}

start
{
    if (current.chapter == 1 && old.chapter == 255)     //255 is main menu
    {
        vars.fromMenu = true;
    }
    
    if (vars.fromMenu && !current.inCutscene && old.inCutscene)
    {       
        vars.fromMenu = false;
        vars.afterCutscene = true;
    }
    
    if (vars.afterCutscene && !current.isLoading && old.isLoading)
    {
        vars.afterCutscene = false;
        return true;
    }
}

split
{  
    if (current.chapter == old.chapter+1 &&
        old.chapter != 255 &&
        current.chapter >= 1 &&
        current.chapter <= 15 )
    {
        return true;
    }    
    
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
    return current.isLoading;
}
