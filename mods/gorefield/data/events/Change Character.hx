var preloadedCharacters:Map<String, Character> = [];
var preloadedIcons:Map<String, FlxSprite> = [];
var iconsEnabled:Bool = true;
var deferredIcons:Array<FlxSprite> = [];

function postCreate()
{
    // Detect songs that do not use icons by design
    if (gorefieldiconP1 == null && gorefieldiconP2 == null)
        iconsEnabled = false;

    for (event in PlayState.SONG.events)
    {
        if (event.name != "Change Character") continue;
        if (preloadedCharacters.exists(event.params[1])) continue;

        var foundPreExisting:Bool = false;

        // Search for already existing character
        for (strum in strumLines)
        {
            for (char in strum.characters)
            {
                if (char.curCharacter == event.params[1])
                {
                    preloadedCharacters.set(event.params[1], char);

                    if (iconsEnabled)
                    {
                        var iconRef = char == dad ? gorefieldiconP2 : gorefieldiconP1;
                        if (iconRef != null)
                            preloadedIcons.set(char.getIcon(), iconRef);
                    }

                    foundPreExisting = true;
                    break;
                }
            }
            if (foundPreExisting) break;
        }

        if (foundPreExisting) continue;

        // Create new character instance
        var oldCharacter = strumLines.members[event.params[0]].characters[0];
        if (oldCharacter == null) continue;

        var newCharacter = new Character(
            oldCharacter.x,
            oldCharacter.y,
            event.params[1],
            oldCharacter.isPlayer
        );

        newCharacter.active = newCharacter.visible = false;

        // Push character to GPU only if camera exists
        if (FlxG.camera != null)
            newCharacter.drawComplex(FlxG.camera);

        preloadedCharacters.set(event.params[1], newCharacter);

        // Apply camera offsets (original logic preserved)
        if (newCharacter.isGF)
        {
            newCharacter.cameraOffset.x += stage.characterPoses["gf"].camxoffset;
            newCharacter.cameraOffset.y += stage.characterPoses["gf"].camyoffset;
        }
        else if (newCharacter.playerOffsets)
        {
            newCharacter.cameraOffset.x += stage.characterPoses["boyfriend"].camxoffset;
            newCharacter.cameraOffset.y += stage.characterPoses["boyfriend"].camyoffset;
        }
        else
        {
            newCharacter.cameraOffset.x += stage.characterPoses["dad"].camxoffset;
            newCharacter.cameraOffset.y += stage.characterPoses["dad"].camyoffset;
        }

        // Skip icon creation if icons are disabled
        if (!iconsEnabled) continue;

        var iconName = newCharacter.getIcon();
        if (preloadedIcons.exists(iconName)) continue;

        var newIcon:FlxSprite = createIcon(newCharacter);
        if (newIcon == null) continue;

        newIcon.active = newIcon.visible = false;

        // Push icon to GPU only if frames and camera exist
        if (FlxG.camera != null && newIcon.frames != null)
        {
            newIcon.drawComplex(FlxG.camera);
        }
        else
        {
            deferredIcons.push(newIcon);
        }

        preloadedIcons.set(iconName, newIcon);
    }
}

// Flush deferred icons once camera and frames are ready
function flushDeferredIcons()
{
    if (FlxG.camera == null) return;

    for (icon in deferredIcons)
    {
        if (icon != null && icon.frames != null)
            icon.drawComplex(FlxG.camera);
    }

    deferredIcons = [];
}

function onEvent(_)
{
    var params:Array = _.event.params;

    if (_.event.name != "Change Character") return;

    var oldCharacter = strumLines.members[params[0]].characters[0];
    var newCharacter = preloadedCharacters.get(params[1]);

    if (oldCharacter == null || newCharacter == null) return;
    if (oldCharacter.curCharacter == newCharacter.curCharacter) return;

    insert(members.indexOf(oldCharacter), newCharacter);
    newCharacter.active = newCharacter.visible = true;
    remove(oldCharacter);

    newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
    newCharacter.playAnim(oldCharacter.animation.name);
    newCharacter.animation?.curAnim?.curFrame =
        oldCharacter.animation?.curAnim?.curFrame;

    strumLines.members[params[0]].characters[0] = newCharacter;

    // Stop if icons are disabled
    if (!iconsEnabled) return;

    var oldIcon = oldCharacter.isPlayer ? gorefieldiconP1 : gorefieldiconP2;
    var newIcon = preloadedIcons.get(newCharacter.getIcon());

    if (oldIcon == null || newIcon == null || oldIcon == newIcon) return;

    insert(members.indexOf(oldIcon), newIcon);
    newIcon.active = newIcon.visible = true;
    remove(oldIcon);

    if (oldCharacter.isPlayer)
        gorefieldiconP1 = newIcon;
    else
        gorefieldiconP2 = newIcon;

    updateIcons();
}