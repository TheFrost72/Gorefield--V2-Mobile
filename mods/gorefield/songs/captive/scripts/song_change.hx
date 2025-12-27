importScript("data/scripts/VideoHandler");
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxAxes;

var distortionShader:CustomShader = null;
var blackScreen:FlxSprite;
var missText:FlxText;
var useMiddleScroll:Bool = FlxG.save.data.middlescroll;

var scareMeter:FlxText;

function create()
{
    missText = new FlxText(0, 0, 0, 
        FlxG.save.data.spanish ?
        "¡¡NO FALLES!!\n¡¡TIENES POCA VIDA!!" :
        "¡¡DON'T FAIL!!\n¡¡YOU HAVE LITTLE HEALTH!!");
    missText.setFormat("fonts/Harbinger_Caps.otf", 100, 0xFFFF4D00, "center");
    missText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 8, 50);
    missText.screenCenter();
    missText.scrollFactor.set();
    missText.alpha = 0;
    add(missText);

    scareMeter = new FlxText(0, camHUD.downscroll ? 612 : 618, 0,"S        c        a        r        e       -       O       -       M        e        t        e        r");
    scareMeter.setFormat("fonts/Harbinger_Caps.otf", 30, 0xFF8F0000, "center");
    scareMeter.screenCenter(FlxAxes.X);
    scareMeter.scrollFactor.set();
    scareMeter.cameras = [camHUD];

    VideoHandler.load(["CUTSCENE_1", "CAPTIVE_CINEMATIC_2"], false, function() {
        FlxG.camera.flash(0xff000000);
    });

    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 0;
    if (FlxG.save.data.warp) camGame.addShader(distortionShader);

    blackScreen = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
    blackScreen.alpha = 1;
    blackScreen.cameras = [camHUD];

    stage.stageSprites["RedOverlay"].active = stage.stageSprites["RedOverlay"].visible = true;
    stage.stageSprites["RedOverlay"].alpha = 0;
    stage.stageSprites["RedOverlay"].cameras = [camHUD];

    stage.stageSprites["Warning"].active = stage.stageSprites["Warning"].visible = true;
    stage.stageSprites["Warning"].alpha = 0;
    stage.stageSprites["Warning"].cameras = [camHUD];
}

function postCreate()
{
    // Remove previous bars safely
    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar])
        if (spr != null) remove(spr);

    // Add bars and scareMeter safely
    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, scareMeter])
        if (spr != null) add(spr);

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar])
        if (spr != null) spr.y += 10;

    if (blackScreen != null) add(blackScreen);
}

var boogie:Bool = false;

function stepHit(step:Int) 
{
    switch (step) {
        case 2:
            if (blackScreen != null) FlxTween.tween(blackScreen, {alpha: 0}, 1);
        case 432:
            if (blackScreen != null) FlxTween.tween(blackScreen, {alpha: 1}, 1);
        case 448:
            if (blackScreen != null) FlxTween.tween(blackScreen, {alpha: 0.35}, 1);
        case 703:
            VideoHandler.playNext();
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt, scareMeter])
                if (spr != null) FlxTween.tween(spr, {alpha: 0}, 0.5);
        case 732:
            if (blackScreen != null) FlxTween.tween(blackScreen, {alpha: 1}, 1);
        case 1159:
            VideoHandler.playNext();
        case 576 | 771 | 1283:
            if (blackScreen != null) blackScreen.alpha = 0;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt, scareMeter])
                if (spr != null) spr.alpha = 1;
        case 1155:
            if (camHUD != null) FlxTween.tween(camHUD, {alpha: 0}, 0.5);
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt, scareMeter])
                if (spr != null) FlxTween.tween(spr, {alpha: 0}, 0.5);
        case 770:
            quitaVida = true;
            if (stage.stageSprites.exists("BG1")) stage.stageSprites["BG1"].alpha = 0;
            if (stage.stageSprites.exists("Entrada")) stage.stageSprites["Entrada"].alpha = 1;
            if (stage.stageSprites.exists("Suelo")) stage.stageSprites["Suelo"].alpha = 1;
            if (stage.stageSprites.exists("Barriles")) stage.stageSprites["Barriles"].alpha = 1;

            if (stage.stageSprites.exists("RedOverlay")) {
                var overlay = stage.stageSprites["RedOverlay"];
                overlay.alpha = 0.15;
                FlxTween.tween(overlay, {alpha: 0.35}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadInOut, type: 4});
            }

            if (boyfriend != null) { boyfriend.x -= 600; boyfriend.y -= 100; }
            if (dad != null) { dad.scale.set(0.55, 0.55); dad.x += 100; dad.y -= 100; dad.color = 0x7F8CA9; }
            if (gf != null) gf.visible = true;
            if (cpuStrums != null) cpuStrums.visible = false;
            if (!useMiddleScroll)
            {
            for (playerStrum in playerStrums) if (playerStrum != null) playerStrum.x -= 640;
            }
        case 772:
            if (boyfriend != null) { boyfriend.cameraOffset.x += 450; boyfriend.cameraOffset.y += 150; }
        case 1282:
            if (camHUD != null) FlxTween.tween(camHUD, {alpha: 1}, 0.5);
            if (stage.stageSprites.exists("RedOverlay")) stage.stageSprites["RedOverlay"].visible = false;
            if (stage.stageSprites.exists("Warning")) stage.stageSprites["Warning"].alpha = 1;
            if (stage.stageSprites.exists("Rayo")) stage.stageSprites["Rayo"].alpha = 1;

            camFollowChars = false;
            camFollow.setPosition(850, 550);

            if (boyfriend != null) { boyfriend.x -= 400; boyfriend.y -= 100; }
            if (gf != null) gf.x -= 300;
            if (dad != null) dad.visible = false;
            if (stage.stageSprites.exists("Entrada")) stage.stageSprites["Entrada"].alpha = 0;
            if (stage.stageSprites.exists("Suelo")) stage.stageSprites["Suelo"].alpha = 0;
            if (stage.stageSprites.exists("Barriles")) stage.stageSprites["Barriles"].alpha = 0;
            if (stage.stageSprites.exists("BG3")) stage.stageSprites["BG3"].alpha = 1;
        case 1392:
            devControlBotplay = !(player.cpu = true);
            if (camHUD != null) FlxTween.tween(camHUD, {alpha: 0}, 0.5);

            camFollowChars = true;
            if (gf != null) gf.cameraOffset.x -= 150;
        case 1411:
            camFollowChars = false;
            camFollow.setPosition(850, 550);
        case 1415:
            devControlBotplay = !(player.cpu = false);
            if (camHUD != null) FlxTween.tween(camHUD, {alpha: 1}, 0.25);
        case 1396:
            boogie = false;
        case 1412:
            boogie = true;
        case 1284:
            boogie = true;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt, scareMeter])
                if (spr != null) FlxTween.tween(spr, {alpha: 0}, 0.25);

            if (missText != null) {
                FlxTween.tween(missText, {alpha: 1}, 0.5, {startDelay: 1});
                FlxTween.tween(missText, {alpha: 0}, 1.25, {startDelay: 5});
            }
        case 1538:
            boogie = false;
        case 1539:
            if (blackScreen != null) FlxTween.tween(blackScreen, {alpha: 1}, 0.5);
            if (FlxG.camera != null) FlxTween.tween(FlxG.camera, {zoom: 2}, 1, {ease: FlxEase.quadOut});
            if (distortionShader != null) FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
    }

    if (boogie && step % 4 == 0 && distortionShader != null) {
        FlxTween.num(0, 1, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;});
        if (curStep > 1410) FlxTween.num(0, 2, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;});
    }
}

function onDadHit(event) {
    if (curStep > 770 && FlxG.camera != null) FlxG.camera.shake(0.007, 0.1);
    if (curStep > 1282 && FlxG.camera != null) FlxG.camera.shake(0.015, 0.1);
}