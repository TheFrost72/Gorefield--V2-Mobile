import funkin.game.ComboRating;
import funkin.backend.system.framerate.Framerate;

public var breakingHeart:FunkinSprite = null;
public var breakingPS:Int = 4;

function create(){
	scripts.getByName("ui_healthbar.hx").call("disableScript");
	camHUD.downscroll = false; //doesnt work with downscroll sorry downscroll players :sob: - lean
}

function postCreate()
{
    // Disable debug overlay
    Framerate.instance.visible = false;

    // Disable HUD elements
    healthBar.visible = false;
    healthBarBG.visible = false;
    iconP1.visible = false;
    iconP2.visible = false;
    camFollowChars = false;
    canHudBeat = false;

    // Set camera follow position
    camFollow.setPosition(642, 358);

    // Slight horizontal adjustment for strum notes
    for (strum in strumLines)
    {
        for (i => strumNote in strum.members)
        {
            if (strumNote == null) continue;
            strumNote.x -= 76 * i;
        }
    }

    // Create the breaking heart UI sprite
    breakingHeart = new FunkinSprite(90, 100);
    breakingHeart.frames = Paths.getFrames('stages/breaking/BREAKING_LIFES');
    breakingHeart.animation.addByPrefix('4', 'LIFES 4', 24, false);
    breakingHeart.animation.addByPrefix('4 remove', 'LIFES MINUS 3', 24, false);
    breakingHeart.animation.addByPrefix('3 remove', 'LIFES MINUS 2', 24, false);
    breakingHeart.animation.addByPrefix('2 remove', 'LIFES MINUS 1', 24, false);
    breakingHeart.animation.play('4');
    breakingHeart.zoomFactor = 0;
    add(breakingHeart);

    // Ensure the "black" sprite renders above everything and uses HUD camera
    if (stage.stageSprites["black"] != null)
    {
        remove(stage.stageSprites["black"]);
        insert(99, stage.stageSprites["black"]);
        stage.stageSprites["black"].cameras = [camHUD];
    }

    // Control visibility of menu sprites
    var menuSprite = stage.stageSprites["MENU_BREAKING"];
    var menuSprite2 = stage.stageSprites["MENU_BREAKING2"];
    var menuSprite3 = stage.stageSprites["danger"];
    var menuSprite4 = stage.stageSprites["danger2"];
    if (menuSprite == null || menuSprite2 == null || menuSprite3 == null || menuSprite4 == null) return;

    if (FlxG.save.data.middlescroll)
    {
        menuSprite.visible = false;
        menuSprite2.visible = true;
        menuSprite3.visible = true;
        menuSprite4.visible = false;
    }
    else
    {
        var verticalOffset:Float = 30;

        menuSprite.visible = true;
        menuSprite2.visible = false;
        menuSprite3.visible = false;
        menuSprite4.visible = true;

        for (strum in playerStrums)
        {
            if (strum == null) continue;
            strum.y += verticalOffset;
        }
    }

    // Snap camera to final position
    snapCam();
}

public static function losePS(psLost){
	breakingPS -= psLost;

	if(breakingPS < 1){
		gameOver();
		return;
	}
	else{
		breakingHeart.animation.play(Std.string(breakingPS + 1) + " remove", true);
	}
	
}

function onStrumCreation(_) _.__doAnimation = false;

function destroy() Framerate.instance.visible = true;
