import flixel.text.FlxTextBorderStyle;

var resumeSpr:FlxSprite;
var restartSpr:FlxSprite;
var optionsSpr:FlxSprite;
var exitToMenu:FlxSprite;

var curSelected:Int = 0; // 0 a 3 agora

function postCreate() {
    for(i => sprite in members)
        sprite.visible = sprite.active = false;

    var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
    bg.updateHitbox();
    bg.alpha = 0;
    bg.screenCenter();
    bg.scrollFactor.set();
    add(bg);

    for(i => option in [resumeSpr, restartSpr, optionsSpr, exitToMenu]) {
        var spriteNames = ['game/pause/RESUME', 'game/pause/RESTART', 'game/pause/OPTIONS', 'game/pause/EXIT'];
        var spr = new FlxSprite(0, 4 * i * 35).loadGraphic(Paths.image(spriteNames[i]));
        spr.scrollFactor.set();
        spr.ID = i;
        add(spr);

        switch(i) {
            case 0: resumeSpr = spr;
            case 1: restartSpr = spr;
            case 2: optionsSpr = spr;
            case 3: exitToMenu = spr;
        }
    }

    FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

    var garfield:FlxSprite = new FlxSprite(780, -720).loadGraphic(Paths.image('game/pause/GOREFIELD_PAUSE'));
    garfield.antialiasing = true;
    add(garfield);

    var levelInfo:FlxText = new FlxText(20, 15, 0, PlayState.SONG.meta.displayName, 32);
    var deathCounter:FlxText = new FlxText(20, 15, 0, "Blue balled: " + PlayState.deathCounter, 32);
    var multiplayerText:FlxText = new FlxText(20, 15, 0, PlayState.opponentMode ? 'OPPONENT MODE' : (PlayState.coopMode ? 'CO-OP MODE' : ''), 32);

    for(k => label in [levelInfo, deathCounter, multiplayerText]) {
        label.scrollFactor.set();
        label.setFormat(Paths.font('Harbinger_Caps.otf'), 32, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(30, 56, 29));
        label.borderSize = 3;
        label.updateHitbox();
        label.alpha = 0;
        label.x = FlxG.width - 10 - (label.width + 20);
        label.y = 15 + (32 * k);
        FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
        add(label);
    }

    FlxTween.tween(garfield, {y: -130}, 0.4, {
        ease: FlxEase.quartOut,
        onComplete: function() {
            FlxTween.tween(garfield, {y: -127}, 2, {ease: FlxEase.quartInOut, type: 4});
        }
    });

    addTouchPad('UP_DOWN', 'A_B');
    addTouchPadCamera(false);
}

function update(elapsed) {
    if (pauseMusic.volume < 0.5)
        pauseMusic.volume += 0.1 * elapsed;

    if(exitToMenu == null) return;

    // Atualiza destaque
    resumeSpr.alpha = (curSelected == 0) ? 1 : 0.55;
    restartSpr.alpha = (curSelected == 1) ? 1 : 0.55;
    optionsSpr.alpha = (curSelected == 2) ? 1 : 0.55;
    exitToMenu.alpha = (curSelected == 3) ? 1 : 0.55;

    var upP = controls.UP_P;
    var downP = controls.DOWN_P;

    if(upP) {
        curSelected--;
        if(curSelected < 0) curSelected = 3;
    }
    if(downP) {
        curSelected++;
        if(curSelected > 3) curSelected = 0;
    }

    if(upP || downP)
        FlxG.sound.play(Paths.sound("menu/scrollMenu"));

    for(sprite in [resumeSpr, restartSpr, optionsSpr, exitToMenu]) {
        FlxTween.cancelTweensOf(sprite);
        FlxTween.tween(sprite, {x: sprite.alpha == 1 ? 5 : -50}, 0.25, {ease: FlxEase.cubeOut});
    }
}