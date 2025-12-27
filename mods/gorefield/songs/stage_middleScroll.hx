function postCreate()
{
    if (stage == null || stage.stageXML == null) return;

    // --- Ensure save data exists
    if (FlxG.save.data.middlescroll == null)
        FlxG.save.data.middlescroll = false;

    var useSaveMiddleScroll:Bool = FlxG.save.data.middlescroll;

    // --- SONG-SPECIFIC override system (absolute priority)
    if (PlayState.SONG != null && PlayState.SONG.meta != null && PlayState.SONG.meta.name != null
        && PlayState.SONG.meta.name.toLowerCase() == "breaking cat")
    {
        var horizontalOffset:Float = -495;
        var verticalOffset:Float = 30;

        if (playerStrums != null)
        {
            for (strum in playerStrums)
            {
                if (strum == null) continue;
                strum.x += horizontalOffset;
                strum.y += verticalOffset;
            }
        }

        __script__.didLoad = __script__.active = false;
        return;
    }

    // --- Check if stage XML forces middlescroll
    var xmlMiddleScroll:Bool =
        stage.stageXML.exists("middleScroll")
        && stage.stageXML.get("middleScroll") == "true";

    // Bail out early if no strum groups exist
    if ((xmlMiddleScroll || useSaveMiddleScroll) && (playerStrums == null || cpuStrums == null)) return;

    // --- GLOBAL middlescroll system (XML OR Save Data)
    if (xmlMiddleScroll || useSaveMiddleScroll)
    {
        // Hide CPU strums
        for (strum in cpuStrums)
        {
            if (strum != null)
                strum.visible = false;
        }

        // Center player strums using index loop to avoid indexOf pitfalls
        var count:Int = playerStrums.members.length;
        for (i in 0...count)
        {
            var p = playerStrums.members[i];
            if (p == null) continue;
            p.x = FlxG.width / 2 - (Note.swagWidth * count) / 2 + (Note.swagWidth * i);
        }
    }

    // --- Disable script after execution
    __script__.didLoad = __script__.active = false;
}