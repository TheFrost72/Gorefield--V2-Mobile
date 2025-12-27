import StringTools;

var actualWeekSongs:Map<String, Array<String>> = [];

function create(){
    actualWeekSongs.set('Principal Week...',["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"]);
    actualWeekSongs.set('Lasagna Boy Week...',["Fast Delivery", "Health Inspection"]);
    actualWeekSongs.set('Sansfield Week...',["Cat Patella", "Mondaylovania", "ULTRA FIELD"]);
    actualWeekSongs.set('ULTRA Week...',["The Complement", "R0ses and Quartzs"]);
    actualWeekSongs.set('Cryfield Week...',["Cryfield", "Nocturnal Meow"]);
}

function setWeekProgress(song:String){
    // Store week progress
    weekProgress.set(PlayState.storyWeek.name, {
        song: song.toLowerCase(),
        weekMisees: PlayState.campaignMisses,
        weekScore: PlayState.campaignScore,
        deaths: PlayState.deathCounter
    });
}

function postCreate(){
    if (!PlayState.isStoryMode) return;

    // Do not track special weeks
    switch(PlayState.storyWeek.name){
        case 'Code Songs...' | 'Cartoon World...' | 'Binky Circus...' | "Godfield's Will...":
            return;
    }

    // If continuing mid-week, save progress
    if (PlayState.storyWeek.songs[0].name.toLowerCase() != PlayState.SONG.meta.name.toLowerCase())
        setWeekProgress(PlayState.SONG.meta.name);

    // Reset progress if player restarted week
    if (weekProgress.exists(PlayState.storyWeek.name)
        && actualWeekSongs.get(PlayState.storyWeek.name)[0].toLowerCase() == PlayState.SONG.meta.name.toLowerCase())
    {
        weekProgress.remove(PlayState.storyWeek.name);
    }
}

function onSongEnd(){
    if (!PlayState.isStoryMode) return;

    // Finished weeks
    switch(PlayState.SONG.meta.name.toLowerCase()){
        case 'bigotes':
            if (!FlxG.save.data.beatWeekG1){
                FlxG.save.data.beatWeekG1 = true;
                FlxG.save.data.weeksFinished = [true, false, false, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, false, false, false, false, false, false];
            }

        case 'health inspection':
            if (!FlxG.save.data.beatWeekG2){
                FlxG.save.data.beatWeekG2 = true;
                FlxG.save.data.weeksFinished = [true, true, false, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, false, false, false, false, false];
            }

        case 'ultra field':
            if (!FlxG.save.data.beatWeekG3){
                FlxG.save.data.beatWeekG3 = true;
                FlxG.save.data.weeksFinished = [true, true, true, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, false, false, false, false];
            }

        case 'r0ses and quartzs':
            if (!FlxG.save.data.beatWeekG4){
                FlxG.save.data.beatWeekG4 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, false, false, false];
            }

        case 'nocturnal meow':
            if (!FlxG.save.data.beatWeekG5){
                FlxG.save.data.beatWeekG5 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, true, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, false, false];
            }

        case 'cataclysm':
            if (!FlxG.save.data.beatWeekG6){
                FlxG.save.data.beatWeekG6 = true;
                FlxG.save.data.beatWeekG8 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, true, true];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, false, true];
                FlxG.save.data.codesUnlocked = true;
            }
    }

    FlxG.save.flush();
}

function destroy(){
    if (!PlayState.isStoryMode) return;

    // Remove progress if week is over
    if (PlayState.storyPlaylist.length <= 0)
        weekProgress.remove(PlayState.storyWeek.name);

    FlxG.save.data.weekProgress = weekProgress;
    FlxG.save.flush();
}