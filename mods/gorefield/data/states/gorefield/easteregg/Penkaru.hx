import hxvlc.flixel.FlxVideo;
import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.NativeAPI;
import flixel.util.FlxTimer;

var video:FlxVideo;
var oldVolume:Float;

function create()
{
    WindowUtils.preventClosing = true;

    video = new FlxVideo();
    video.onEndReached.add(end);

    // Load video file
    if (video.load(Assets.getPath(Paths.video("PENKARU GRIDDY"))))
    {
        // Add video to the display list
        FlxG.addChildBelowMouse(video);

        // Delay before playing to avoid black screen
        new FlxTimer().start(0.001, function(_) {
            video.play();
        });
    }

    // Backup and change volume
    oldVolume = FlxG.sound.volume;
    FlxG.sound.changeVolume(2);
    FlxG.sound.music.volume = 0;
}

function update(elapsed:Float)
{
    // Keep closing prevention alive
    WindowUtils.resetClosing();
}

function end()
{
    WindowUtils.preventClosing = false;
    WindowUtils.resetClosing();

    NativeAPI.showMessageBox("Error", "Null Object Reference", 0x00000000);
    NativeAPI.showMessageBox("JK :P", "Thanks for playing the mod penk :)\n                         -lunar & lean & gorefield team", 0x00000000);

    // Stop and dispose video
    video.dispose();

    // Restore state and volume
    FlxG.switchState(new StoryMenuState());
    FlxG.sound.music.volume = 1;
    FlxG.sound.volume = oldVolume;
    FlxG.sound.showSoundTray(true);
}