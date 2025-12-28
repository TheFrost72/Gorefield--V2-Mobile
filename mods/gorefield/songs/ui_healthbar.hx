import funkin.game.HealthIcon;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.PlayState;
import flixel.math.FlxMath;

var iconOffsets:Array<Array<Float>> = [];

static var gorefieldhealthBarBG:FlxSprite;
static var gorefieldhealthBar:FlxBar;
public var healthBardisabled:Bool = false;

static var gorefieldiconP1:FlxSprite;
static var gorefieldiconP2:FlxSprite;

function postCreate()
{
    healthBar.visible = false;
    healthBarBG.visible = false;
    iconP1.visible = false;
    iconP2.visible = false;

    gorefieldhealthBarBG = createBGBar(
        (stage != null && stage.stageXML != null && stage.stageXML.exists("healthBarColor"))
        ? stage.stageXML.get("healthBarColor")
        : "orange"
    );

    var isCaptive:Bool = PlayState.SONG.meta.name.toLowerCase() == "captive";

    if (isCaptive)
    {
        gorefieldhealthBar = new FlxBar(
            0, 0,
            FlxBarFillDirection.RIGHT_TO_LEFT,
            910, 300,
            PlayState.instance,
            "health", 0, maxHealth
        );

        gorefieldhealthBar.createImageBar(
            Paths.image("game/healthbar/Captive_life_bar_empty"),
            Paths.image("game/healthbar/Captive_life_bar_full")
        );
    }
    else
    {
        gorefieldhealthBar = new FlxBar(
            0, 0,
            FlxBarFillDirection.RIGHT_TO_LEFT,
            804, 18,
            PlayState.instance,
            "health", 0, maxHealth
        );

        gorefieldhealthBar.createImageBar(
            Paths.image("game/healthbar/filler_right"),
            Paths.image("game/healthbar/filler_left")
        );
    }

    gorefieldhealthBar.antialiasing = true;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar])
    {
        spr.scrollFactor.set();
        spr.updateHitbox();
        spr.cameras = [camHUD];
        add(spr);
        spr.screenCenter(0x01);
    }

    health -= 0.02;

    gorefieldhealthBar.y =
    (gorefieldhealthBarBG.y = FlxG.height * 0.83) + (isCaptive ? 0 : 34);

    gorefieldiconP2 = createIcon(dad);
    gorefieldiconP1 = createIcon(boyfriend);

    add(gorefieldiconP2);
    add(gorefieldiconP1);

    for (txt in [scoreTxt, missesTxt, accuracyTxt])
    {
        members.remove(txt);
        add(txt);
    }

    updateIcons();
}

function update(elapsed:Float)
{
    updateIcons();
}

static function updateIcons()
{
    if (healthBardisabled) return;
    if (gorefieldhealthBar == null) return;
    if (gorefieldiconP1 == null || gorefieldiconP2 == null) return;

    var percent = FlxMath.remapToRange(gorefieldhealthBar.percent, 0, 100, 1, 0);

    gorefieldiconP1.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * percent) - 20;
    gorefieldiconP2.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * percent) - (gorefieldiconP2.width - 20);

    for (icon in [gorefieldiconP1, gorefieldiconP2])
    {
        var offset = iconOffsets[icon.ID];

        icon.x += offset[0];
        icon.y = gorefieldhealthBar.y - (icon.height / 2) + (offset[1] * (camHUD.downscroll ? -1 : 1));

        var losing:Bool = (icon == gorefieldiconP1)
            ? (gorefieldhealthBar.percent < 20)
            : (gorefieldhealthBar.percent > 80);

        if (icon.animation != null && icon.animation.curAnim != null)
        {
            if (icon.animation.name == "non-animated")
            {
                icon.animation.curAnim.curFrame = losing ? 1 : 0;
            }
            else if (icon.animation.exists("losing"))
            {
                icon.animation.play(losing ? "losing" : "idle");
            }
        }
    }
}

static function createIcon(character:Character):FlxSprite
{
    var icon = new FlxSprite();
    icon.ID = iconOffsets.length;

    var iconName = (character != null) ? character.getIcon() : "face";
    var path = 'icons/' + iconName;

    if (!Assets.exists(Paths.image(path)))
        path = 'icons/face';

    var animated:Bool =
        character != null &&
        character.xml != null &&
        character.xml.exists("animatedIcon") &&
        character.xml.get("animatedIcon") == "true";

    if (animated)
    {
        icon.frames = Paths.getSparrowAtlas(path);

        if (!character.xml.exists("noLosingIcon"))
            icon.animation.addByPrefix("losing", "losing", 24, true);

        icon.animation.addByPrefix("idle", "idle", 24, true);
        icon.animation.play("idle");
    }
    else
    {
        icon.loadGraphic(Paths.image(path));

        if (icon.graphic != null)
        {
            icon.loadGraphic(icon.graphic, true, icon.graphic.width / 2, icon.graphic.height);
            icon.animation.add("non-animated", [0, 1], 0, false);
            icon.animation.play("non-animated");
        }
        else
        {
            icon.visible = false;
        }
    }

    icon.flipX = (character != null && character.isPlayer);
    icon.updateHitbox();

    if (character != null && character.xml != null && character.xml.exists("iconScale"))
    {
        var scale = Std.parseFloat(character.xml.get("iconScale"));
        icon.scale.set(scale, scale);
    }

    icon.cameras = [camHUD];
    icon.scrollFactor.set();
    icon.antialiasing = (character != null) ? character.antialiasing : true;

    iconOffsets.push([
        (character != null && character.xml != null && character.xml.exists("iconoffsetx"))
            ? Std.parseFloat(character.xml.get("iconoffsetx"))
            : 0,
        (character != null && character.xml != null && character.xml.exists("iconoffsety"))
            ? Std.parseFloat(character.xml.get("iconoffsety"))
            : 0
    ]);

    return icon;
}

static function createBGBar(name:String):FlxSprite
{
    var bgBar = new FlxSprite().loadGraphic(Paths.image("game/healthbar/healthbar_" + name));
    bgBar.cameras = [camHUD];
    bgBar.antialiasing = true;
    bgBar.scale.set(0.995, 1.05);
    bgBar.updateHitbox();
    bgBar.screenCenter(0x01);
    bgBar.scrollFactor.set();
    return bgBar;
}
