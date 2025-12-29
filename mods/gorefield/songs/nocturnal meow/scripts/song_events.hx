var scaryTime:Bool = false;

var hudMembers:Array<FlxSprite>;
var bloom:CustomShader;

function create()
{
    bloom = new CustomShader("glow");
    bloom.size = 0.0;
    bloom.dim = 2;

    if (FlxG.save.data.bloom)
    {
        FlxG.camera.addShader(bloom);
        camHUD.addShader(bloom);
    }
}

function postCreate()
{
    var useMiddleScroll:Bool = FlxG.save.data.middlescroll;

    hudMembers = [
        gorefieldhealthBarBG,
        gorefieldhealthBar,
        gorefieldiconP1,
        gorefieldiconP2,
        scoreTxt,
        missesTxt,
        accuracyTxt
    ];

    for (member in hudMembers)
    {
        if (member != null)
        {
            member.visible = true;
            member.alpha = 0;
        }
    }

    if (useMiddleScroll)
    {
        for (strum in cpuStrums)
            strum.visible = false;
    }

    boyfriend.cameraOffset.x += 20;
    boyfriend.cameraOffset.y += 80;
}

function stepHit(step:Int)
{
    var useMiddleScroll:Bool = FlxG.save.data.middlescroll;

    if (scaryTime)
    {
        camGame.shake(0.006, 0.1);
        camHUD.shake(0.005, 0.1);
    }

    switch (step)
    {
        case 256:
            strumLineBfZoom = 1.5;
            boyfriend.cameraOffset.x -= 20;
            boyfriend.cameraOffset.y -= 80;

            showPopUp(true, PlayState.instance.misses);

            for (member in hudMembers)
            {
                if (member != null)
                {
                    member.visible = true;
                    member.alpha = 0;
                    FlxTween.tween(member, { alpha: 1 }, 0.4);
                }
            }

        case 1232:
            if (stage != null && stage.stageSprites != null)
            {
                var rain:FlxSprite = stage.stageSprites.get("rain");
                var rain2:FlxSprite = stage.stageSprites.get("rain2");
                var black:FlxSprite = stage.stageSprites.get("black");
                var lightning:FlxSprite = stage.stageSprites.get("lightning_bolt");

                if (rain != null)
                    rain.visible = false;

                if (rain2 != null)
                    rain2.visible = true;

                if (black != null && lightning != null)
                {
                    remove(black);
                    insert(members.indexOf(lightning) - 1, black);

                    black.visible = true;
                    black.active = true;
                    black.alpha = 0.8;

                    FlxTween.tween(
                        black,
                        { alpha: 0 },
                        (Conductor.stepCrochet / 1000) * 6,
                        { startDelay: (Conductor.stepCrochet / 1000) }
                    );
                }

                camGame.shake(0.02, 1);
                camHUD.shake(0.02, 1);

                bloom.size = 8.0;
                bloom.dim = 1.2;

                FlxTween.num(
                    8, 0,
                    (Conductor.stepCrochet / 1000) * 16,
                    { ease: FlxEase.quadInOut, startDelay: (Conductor.stepCrochet / 1000) },
                    function(v:Float) bloom.size = v
                );

                FlxTween.num(
                    1.2, 2,
                    (Conductor.stepCrochet / 1000) * 16,
                    { ease: FlxEase.quadInOut, startDelay: (Conductor.stepCrochet / 1000) },
                    function(v:Float) bloom.dim = v
                );

                if (lightning != null && lightning.animation != null)
                {
                    lightning.visible = true;
                    lightning.animation.play("lightning_bolt");
                    lightning.animation.finishCallback = function(_)
                    {
                        lightning.visible = false;
                        lightning.active = false;
                        scaryTime = true;
                    };
                }
            }

        case 1504:
            scaryTime = false;
            boyfriend.cameraOffset.y += 80;

        case 1632:
            scaryTime = true;
            camFollowChars = false;
            camFollow.setPosition(950, 250);

        case 1784:
            scaryTime = false;
            camHUD.visible = false;
            camGame.visible = false;
    }
}
