import openfl.ui.Mouse;

// Current selected option index
var curSelected:Int = -1;

// Group holding the menu options
var options:FlxTypedGroup<FlxSprite>;

function create()
{
    // Play menu music
    FlxG.sound.playMusic(Paths.music("bebe repeat after mem/Baby_Menu"));

    // Background sprite
    var background:FlxSprite = new FlxSprite();
    background.loadGraphic(Paths.image("menus/bebe repeat after mem/BEBE_REPEAT_AFTHER_MEM"));
    background.setGraphicSize(FlxG.width, FlxG.height);
    background.updateHitbox();
    background.antialiasing = true;
    add(background);

    // Options group
    options = new FlxTypedGroup<FlxSprite>();
    add(options);

    // Create Yes / No buttons
    for (i => option in ["yes", "non"])
    {
        var sprite:FlxSprite = new FlxSprite(170 * i + 800, 400);
        sprite.loadGraphic(
            Paths.image("menus/bebe repeat after mem/skidibi dom dom dom " + option + " " + option),
            true,
            143,
            93
        );

        // Animations
        sprite.animation.add("idle", [1], 0, false);
        sprite.animation.add("selected", [0], 0, false);
        sprite.animation.play("idle");

        sprite.ID = i;
        sprite.antialiasing = true;

        options.add(sprite);
    }
}

function update(elapsed:Float)
{
    var overSomething:Bool = false;

    // Mouse hover detection
    if (FlxG.mouse.justMoved)
    {
        for (sprite in options.members)
        {
            if (sprite != null && FlxG.mouse.overlaps(sprite))
            {
                overSomething = true;
                changeItem(sprite.ID, true);
            }
        }

        if (!overSomething)
            changeItem(-1, true);
    }

    // Keyboard / controller navigation
    if (controls.RIGHT_P)
        changeItem(1, false);
    else if (controls.LEFT_P)
        changeItem(-1, false);

    // Confirm selection
    if (curSelected != -1
        && (
            (FlxG.mouse.justPressed && FlxG.mouse.overlaps(options.members[curSelected]))
            || controls.ACCEPT
        ))
    {
        FlxG.sound.play(Paths.sound("menu/confirm"));

        // Save player choice
        FlxG.save.data.baby = (curSelected == 0);
        FlxG.save.flush();

        // Return to gameplay
        new FlxTimer().start(0.3, function(_)
        {
            FlxG.switchState(new PlayState());
        });
    }

    // Update mouse cursor
    Mouse.cursor = overSomething ? "button" : "arrow";
}

function changeItem(change:Int, force:Bool)
{
    // Reset selection when forcing -1
    if (force && change == -1)
    {
        if (curSelected != -1 && options.members[curSelected] != null)
            options.members[curSelected].animation.play("idle");

        curSelected = -1;
        return;
    }

    // Ignore redundant force selection
    if (force && curSelected == change)
        return;

    // Reset previous selection
    if (curSelected != -1 && options.members[curSelected] != null)
        options.members[curSelected].animation.play("idle");

    // Apply selection logic
    if (force)
    {
        curSelected = change;
    }
    else
    {
        curSelected += change;

        if (curSelected >= options.members.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.members.length - 1;
    }

    // Apply new selection
    if (curSelected != -1 && options.members[curSelected] != null)
    {
        FlxG.sound.play(Paths.sound("menu/scrollMenu"));
        options.members[curSelected].animation.play("selected");
    }
}