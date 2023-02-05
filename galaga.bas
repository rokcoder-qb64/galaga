'======================================================================================================================================================================================================
' GALAGA
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' Programmed by RokCoder
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' Galaga is a 1981 fixed shooter arcade video game developed and published by Namco
' This version is a tribute to the original programmed using QB64PE
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' V0.1 - 4th Feb 2023 - First shared version
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' https://github.com/rokcoder-qb64/galaga
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
' https://www.rokcoder.com
' https://www.github.com/rokcoder
' https://www.facebook.com/rokcoder
' https://www.youtube.com/rokcoder
'======================================================================================================================================================================================================
' TODO
' Challenge wave styles 5 to 8 (once I can find a video of them being played without destroying the aliens so I can mimic the paths)
' Transforms (scorpions, spy ships and flag ships) not yet implemented
'
' BUGS
' Dying just before challenge stage resulted in READY and CHALLENGE STAGE overwriting each other
'======================================================================================================================================================================================================

$VERSIONINFO:CompanyName=RokSoft
$VERSIONINFO:FileDescription=QB64 Galaga
$VERSIONINFO:InternalName=galaga.exe
$VERSIONINFO:ProductName=QB64 Galaga
$VERSIONINFO:OriginalFilename=galaga.exe
$VERSIONINFO:LegalCopyright=(c)2023 RokSoft
$VERSIONINFO:FILEVERSION#=0,1,0,0
$VERSIONINFO:PRODUCTVERSION#=0,1,0,0
$EXEICON:'./assets/galaga.ico'

'======================================================================================================================================================================================================

OPTION _EXPLICIT
OPTION _EXPLICITARRAY

'===== General constants ==============================================================================================================================================================================

CONST FALSE = 0
CONST TRUE = NOT FALSE
CONST MAX_ATTACKING_FORMATIONS = 10
CONST MAX_ALIENS = 80
CONST NUM_CHALLENGE_PATHS = 4
CONST MAX_SPAWNS = 20
CONST MAX_BULLETS_PER_SHIP = 2
CONST MAX_BULLETS = MAX_BULLETS_PER_SHIP * 2
CONST TEXTCHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ -%.!c"
CONST MAX_NAME_LEN = 14

'===== Sound effect IDs ===============================================================================================================================================================================

CONST SFX_BOSS_GALAGA_TRACTOR_BEAM = 0
CONST SFX_TRACTOR_BEAM_CAUGHT = 1
CONST SFX_AMBIENCE = 2
CONST SFX_GALAGA_ATTACK = 3
CONST SFX_FIGHTER_SHOOT = 4
CONST SFX_STAGE_INTRO = 5
CONST SFX_GALAGA_DEFEAT_1 = 6
CONST SFX_GALAGA_DEFEAT_2 = 7
CONST SFX_BOSS_GALAGA_DEFEAT = 8
CONST SFX_BOSS_GALAGA_HIT = 9
CONST SFX_CAPTURED_FIGHTER_DESTROYED = 10
CONST SFX_FIGHTER_CAPTURED = 11
CONST SFX_1_UP = 12
CONST SFX_FIGHTER_RESCUED = 13
CONST SFX_DIE = 14
CONST SFX_NEXT_LEVEL = 15
CONST SFX_CHALLENGING_STAGE = 16
CONST SFX_CHALLENGING_STAGE_OVER = 17
CONST SFX_CHALLENGING_STAGE_PERFECT = 18
CONST SFX_NAME_ENTRY_1 = 19
CONST SFX_NAME_ENTRY_NOT_1 = 20
CONST SFX_COIN_CREDIT = 21

'===== Game controls (Left arrow, right arrow and space bar) ==========================================================================================================================================

CONST KEYDOWN_LEFT = 19200
CONST KEYDOWN_RIGHT = 19712
CONST KEYDOWN_FIRE = 32

'===== Sprite IDs =====================================================================================================================================================================================

CONST SPRITE_PLAYER = 0
CONST SPRITE_PLAYER_CAPTURED = 1
CONST SPRITE_BOSS_GALAGA = 2
CONST SPRITE_BOSS_GALAGA_HIT = 3
CONST SPRITE_BUTTERFLY = 4
CONST SPRITE_BEE = 5
CONST SPRITE_FLAGSHIP = 6
CONST SPRITE_SCORPION = 7
CONST SPRITE_SPY_SHIP = 8
CONST SPRITE_DRAGONFLY = 9
CONST SPRITE_SATELLITE = 10
CONST SPRITE_ENTERPRISE = 11
CONST SPRITE_BEAM = 12
CONST SPRITE_BULLET = 13
CONST SPRITE_PLAYER_LIVES = 14
CONST SPRITE_PLAYER_EXPLOSION = 15
CONST SPRITE_ALIEN_EXPLOSION = 16
CONST SPRITE_TEXT_WHITE = 17
CONST SPRITE_TEXT_RED = 18
CONST SPRITE_TEXT_BLUE = 19
CONST SPRITE_TEXT_YELLOW = 20
CONST SPRITE_FLAG = 21
CONST SPRITE_BOMB = 22
CONST SPRITE_SCORES = 23

'===== Text colour IDs ================================================================================================================================================================================

CONST COLOUR_WHITE = 0
CONST COLOUR_RED = 1
CONST COLOUR_BLUE = 2
CONST COLOUR_YELLOW = 3

'===== Alien type IDs =================================================================================================================================================================================

CONST TYPE_NONE = -1
CONST TYPE_BOSS_GALAGA = 0
CONST TYPE_BOSS_GALAGA_SHOT = 1
CONST TYPE_BUTTERFLY = 2
CONST TYPE_BEE = 3
CONST TYPE_PLAYER_CAPTURED = 4
CONST TYPE_PLAYER = 5
CONST TYPE_DRAGONFLY = 6
CONST TYPE_SCORPION = 7

'===== Paths to control alien flight - each path contains a list of commands ==========================================================================================================================

CONST PT_NONE = 0
CONST PT_NEW_WAVE_FROM_TOP = 1
CONST PT_NEW_WAVE_FROM_SIDE = 2
CONST PT_UP_AND_DIVE_WITH_BOSS = 3
CONST PT_BUTTERFLY_PATH = 4
CONST PT_BEE_PATH = 5
CONST PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD = 6
CONST PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER = 7
CONST PT_NEW_AGGRESSIVE_WAVE_FROM_TOP = 8
CONST PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP = 9
CONST PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE = 10
CONST PT_NEW_AGGRESSIVE_WAVE_FROM_HIGHER_SIDE = 11
CONST PT_UP_AND_DIVE_TO_CAPTURE = 12
CONST PT_RETURN_WITH_CAPTURED = 13
CONST PT_WAIT_FOR_CAPTURE = 14
CONST PT_TAKE_HOSTAGE_POSITION = 15
CONST PT_RESCUED_PLAYER = 16
CONST PT_PLAYER_SWOOP = 17
CONST PT_CHALLENGE1A = 18
CONST PT_CHALLENGE1B = 19
CONST PT_CHALLENGE2A = 20
CONST PT_CHALLENGE2B = 21
CONST PT_CHALLENGE3A = 22
CONST PT_CHALLENGE3B = 23
CONST PT_CHALLENGE3C = 24
CONST PT_CHALLENGE4A = 25
CONST PT_CHALLENGE4B = 26
CONST PT_CHALLENGE4C = 27
CONST PT_WAITING = 28
CONST PT_INACTIVE = 29

'===== Commands to control alien actions ==============================================================================================================================================================

CONST CMD_NONE = 0
CONST CMD_SET_POSITION = 1
CONST CMD_MOVEMENT = 2
CONST CMD_JOIN_FORMATION = 3
CONST CMD_LEAVE_FORMATION = 4
CONST CMD_MOVE_ABOVE_FORMATION = 5
CONST CMD_CONTINUE_FLIGHT = 6
CONST CMD_TO_HEIGHT = 7
CONST CMD_BEE_RETURN = 8
CONST CMD_SPEED = 9
CONST CMD_DIVE_AT_PLAYER = 10
CONST CMD_REMOVE = 11
CONST CMD_DIVE_TO_BEAM = 12
CONST CMD_WAIT_FOR_CAPTURE = 13
CONST CMD_TAKE_HOSTAGE_POSITION = 14
CONST CMD_DOUBLE_UP_PLAYER = 16
CONST CMD_PLAYER_IN_STORAGE = 17
CONST CMD_HOLD_FORMATION = 18
CONST CMD_FIRE_BEAM = 19
CONST CMD_PAUSE_ATTACK = 20
CONST CMD_INACTIVE = 21
CONST CMD_DEAD = 22
CONST CMD_DESTROYED = 23

'===== States for the various systems in the game =====================================================================================================================================================

CONST SHIP_EXPLODING = 0
CONST SHIP_ACTIVE = 1
CONST SHIP_INACTIVE = 2

CONST PLAYER_INACTIVE = 0
CONST PLAYER_SPAWNING = 1
CONST PLAYER_DOUBLING_UP = 2
CONST PLAYER_WAITING_TO_DOUBLE = 3
CONST PLAYER_CAPTURING = 4
CONST PLAYER_ACTIVE = 5

CONST SPAWN_NONE = 0
CONST SPAWN_EXPLOSION = 1
CONST SPAWN_SCORE = 2

CONST BULLET_NONE = 0
CONST BULLET_ACTIVE = 1
CONST BULLET_REMOVING = 2

CONST FE_SHOW_SCORES = 0
CONST FE_WAIT_START_PRESS = 1
CONST FE_PAUSE_BEFORE_OVER = 2

CONST BE_STATS = 0
CONST BE_POST_STATS_PAUSE = 1
CONST BE_ENTER_NAME = 2

CONST WS_WAIT_FOR_ATTACK = 0
CONST WS_PREPARE_BATCH = 1
CONST WS_BRING_ON_BATCH = 2
CONST WS_PLAY_STAGE = 3
CONST WS_CHALLENGE_RESULTS = 4
CONST WS_POST_STAGE = 5
CONST WS_INITIALISE_WAVE = 6
CONST WS_PAUSE = 7
CONST WS_INITIALISE_PLAY = 8
CONST WE_SHOW_PRE_GAME_OVERLAYS = 9

'===== Game flow is controlled via event lists ========================================================================================================================================================

CONST EVENT_UPDATE_STARS = 0
CONST EVENT_UPDATE_FRONT_END = 1
CONST EVENT_RENDER_FRONT_END = 2
CONST EVENT_UPDATE_ALIEN_MANAGER = 3
CONST EVENT_UPDATE_PLAYER = 4
CONST EVENT_UPDATE_BULLETS = 5
CONST EVENT_UPDATE_ALIENS = 6
CONST EVENT_RENDER_SCENE = 7
CONST EVENT_PROCESS_FLAGS = 8
CONST EVENT_UPDATE_BOMBS = 9
CONST EVENT_RENDER_BACK_END = 10
CONST EVENT_UPDATE_BACK_END = 11

'======================================================================================================================================================================================================

TYPE EVENT
    event AS INTEGER
    initialised AS INTEGER
END TYPE

TYPE FRONTEND
    state AS INTEGER
    keyPressTarget AS INTEGER
    active AS INTEGER
    pauseCounter AS INTEGER
END TYPE

TYPE BACKEND
    state AS INTEGER
    pause AS INTEGER
    name AS STRING
    score AS STRING
    cursorX AS INTEGER
    cursor AS INTEGER
    substate AS INTEGER
    pos AS INTEGER
    timer AS INTEGER
END TYPE

TYPE FLAG
    flag AS INTEGER
    xpos AS INTEGER
END TYPE

TYPE SFX
    handle AS LONG
    oneShot AS INTEGER
    looping AS INTEGER
END TYPE

TYPE SPRITEDATA
    offset AS INTEGER
    num AS INTEGER
END TYPE

TYPE WAVEDATA
    section AS INTEGER
    state AS INTEGER
    aliensAttackingPauseCounter AS INTEGER
    aliensCanAttack AS INTEGER
    batchCounter AS INTEGER
    aliensArrived AS INTEGER
    aliensInFormation AS INTEGER
    postArrivalPause AS INTEGER
    formationCentreX AS INTEGER
    formationCentreY AS INTEGER
    formationDirection AS SINGLE
    challengingStage AS INTEGER
    simultaneousAttackCount AS INTEGER
    continuousDiverCount AS INTEGER
    bombAvailability AS INTEGER
    continuousAttack AS INTEGER
    hitCount AS INTEGER
    formationSpread AS SINGLE
    stageClear AS INTEGER
    hasCaptive AS INTEGER
    postPauseState AS INTEGER
    pauseCounter AS INTEGER
    substate AS INTEGER
    bombCount AS INTEGER
    playerInStorage AS INTEGER
END TYPE

TYPE ALIENDATA
    controlPath AS INTEGER
    xPos AS SINGLE
    yPos AS SINGLE
    direction AS INTEGER
    rotation AS SINGLE
    formationXOffset AS SINGLE
    formationYOffset AS SINGLE
    alienType AS INTEGER
    pathDelay AS INTEGER
    pathIndex AS INTEGER
    currentAction AS INTEGER
    fetchNewAction AS INTEGER
    bombCount AS INTEGER
    steps AS INTEGER
    deltaMove AS SINGLE
    deltaTurn AS SINGLE
    targetHeight AS INTEGER
    continualPath AS INTEGER
    attackGroup AS INTEGER
    pauseCounter AS INTEGER
    isCaptor AS INTEGER
    isCaptive AS INTEGER
    beamActive AS INTEGER
    captureCounter AS INTEGER
    explosionCounter AS INTEGER
    targetX AS SINGLE
    targetY AS SINGLE
    costume AS INTEGER
    doubleUpCounter AS INTEGER
    scoreCostume AS INTEGER
    batchNum AS INTEGER
END TYPE

TYPE PLAYER
    doubleShip AS INTEGER
    canFire AS INTEGER
    xPos AS INTEGER
    yPos AS INTEGER
    lives AS INTEGER
    fireKeyDown AS INTEGER
    state AS INTEGER
END TYPE

TYPE SHIP
    isHit AS INTEGER
    xPos AS INTEGER
    state AS INTEGER
    counter AS INTEGER
END TYPE

TYPE SPAWNED_ANIMATION
    spawnType AS INTEGER
    counter AS INTEGER
    xPos AS INTEGER
    yPos AS INTEGER
    value AS INTEGER
END TYPE

TYPE GAME
    frameCounter AS LONG
    stage AS INTEGER
    score AS LONG
    fps AS INTEGER
    extraLife AS LONG
    gameOver AS INTEGER
    hiscore AS LONG
    gameOverCounter AS INTEGER
END TYPE

TYPE BULLET
    xPos AS INTEGER
    yPos AS INTEGER
    state AS INTEGER
    waitToRemoveCounter AS INTEGER
END TYPE

TYPE BOMB
    xPos AS SINGLE
    yPos AS SINGLE
    deltaX AS SINGLE
    deltaY AS SINGLE
END TYPE

TYPE STARS
    overlay AS LONG
    yPos AS INTEGER
    scroll AS INTEGER
END TYPE

TYPE HISCORE
    score AS LONG
    name AS STRING
END TYPE

TYPE STATS
    bulletCount AS INTEGER
    bulletMissCount AS INTEGER
END TYPE

TYPE TEXT
    text AS STRING
    x AS INTEGER
    y AS INTEGER
    colour AS INTEGER
END TYPE

'======================================================================================================================================================================================================

DIM SHARED eventIndex%
DIM SHARED virtualScreen&
DIM SHARED spriteLoadOffset%
DIM SHARED pathDataIndex%
DIM SHARED initialiseAlienIndex%
DIM SHARED textOffset%

DIM SHARED frontend AS FRONTEND
DIM SHARED backend AS BACKEND
DIM SHARED waveData AS WAVEDATA
DIM SHARED player AS PLAYER
DIM SHARED game AS GAME
DIM SHARED stars AS STARS
DIM SHARED stats AS STATS

DIM SHARED numberInAttackingFormation%(MAX_ATTACKING_FORMATIONS)
DIM SHARED textColour%(4)
DIM SHARED spriteHandle&(300)
DIM SHARED bossScores%(4)
DIM SHARED pathDataOffset%(100)
DIM SHARED pathData!(1000)
DIM SHARED starFrames&(4)

DIM SHARED bullet(MAX_BULLETS) AS BULLET
DIM SHARED spawnedAnimation(MAX_SPAWNS) AS SPAWNED_ANIMATION
DIM SHARED alienData(MAX_ALIENS) AS ALIENDATA
DIM SHARED sfx(25) AS SFX
DIM SHARED spriteData(60) AS SPRITEDATA
DIM SHARED ship(2) AS SHIP
DIM SHARED hiscore(5) AS HISCORE
DIM SHARED text(50) AS TEXT

REDIM SHARED events(0) AS EVENT
REDIM SHARED flagDisplay(0) AS FLAG
REDIM SHARED bomb(0) AS BOMB

'===== Game loop ======================================================================================================================================================================================

PrepareGalaga
PrepareFrontendEvents
DO: _LIMIT (game.fps%): ProcessEvents: LOOP

'===== Error handlers =================================================================================================================================================================================

fileReadError:
InitialiseHiscores
RESUME NEXT

fileWriteError:
ON ERROR GOTO 0
RESUME NEXT

'===== Event system ===================================================================================================================================================================================

SUB ResetEvents
    REDIM events(0) AS EVENT
    eventIndex% = -1
END SUB

SUB AddEvent (e%)
    DIM i%
    FOR i% = 0 TO UBOUND(events) - 1
        IF events(i%).event% = e% THEN EXIT SUB
    NEXT i%
    events(UBOUND(events)).event% = e%
    events(UBOUND(events)).initialised% = FALSE
    REDIM _PRESERVE events(UBOUND(events) + 1) AS EVENT
END SUB

SUB RemoveEvent (e%)
    DIM i%, j%
    FOR i% = 0 TO UBOUND(events) - 1
        IF events(i%).event% = e% THEN
            j% = i%
            FOR j% = i% TO UBOUND(events) - 2: events(j%) = events(j% + 1): NEXT j%
            REDIM _PRESERVE events(UBOUND(events) - 1) AS EVENT
            IF eventIndex% >= i% THEN eventIndex% = eventIndex% - 1
            EXIT SUB
        END IF
    NEXT i%
END SUB

SUB ProcessEvents
    eventIndex% = 0
    WHILE eventIndex% < UBOUND(events)
        SELECT CASE events(eventIndex%).event
            CASE EVENT_UPDATE_STARS: UpdateStars events(eventIndex%).initialised%
            CASE EVENT_UPDATE_FRONT_END: UpdateFrontEnd events(eventIndex%).initialised%
            CASE EVENT_RENDER_FRONT_END: RenderFrontend events(eventIndex%).initialised%
            CASE EVENT_UPDATE_ALIEN_MANAGER: UpdateAlienManager events(eventIndex%).initialised%
            CASE EVENT_UPDATE_PLAYER: UpdatePlayer events(eventIndex%).initialised%
            CASE EVENT_UPDATE_BULLETS: UpdateBullets events(eventIndex%).initialised%
            CASE EVENT_UPDATE_ALIENS: UpdateAliens events(eventIndex%).initialised%
            CASE EVENT_RENDER_SCENE: RenderScene events(eventIndex%).initialised%
            CASE EVENT_PROCESS_FLAGS: ProcessFlags events(eventIndex%).initialised%
            CASE EVENT_UPDATE_BOMBS: UpdateBombs events(eventIndex%).initialised%
            CASE EVENT_UPDATE_BACK_END: UpdateBackEnd events(eventIndex%).initialised%
            CASE EVENT_RENDER_BACK_END: RenderBackend events(eventIndex%).initialised%
        END SELECT
        IF eventIndex% > -1 THEN events(eventIndex%).initialised% = TRUE
        eventIndex% = eventIndex% + 1
    WEND
END SUB

'===== Preparing the event system for the front-end, main game and back-end ===========================================================================================================================

SUB PrepareFrontendEvents
    ResetEvents
    AddEvent EVENT_UPDATE_STARS
    AddEvent EVENT_UPDATE_FRONT_END
    AddEvent EVENT_RENDER_FRONT_END

END SUB

SUB PrepareGameEvents
    ResetEvents
    AddEvent EVENT_UPDATE_ALIEN_MANAGER
    AddEvent EVENT_UPDATE_STARS
    AddEvent EVENT_UPDATE_PLAYER
    AddEvent EVENT_UPDATE_BULLETS
    AddEvent EVENT_UPDATE_ALIENS
    AddEvent EVENT_UPDATE_BOMBS
    AddEvent EVENT_RENDER_SCENE
END SUB

SUB PrepareBackendEvents
    ResetEvents
    AddEvent EVENT_UPDATE_STARS
    AddEvent EVENT_UPDATE_BACK_END
    AddEvent EVENT_RENDER_BACK_END
END SUB

'===== One time initialisations =======================================================================================================================================================================

SUB PrepareGalaga
    DIM m%
    m% = INT((_DESKTOPHEIGHT - 80) / 288)
    virtualScreen& = _NEWIMAGE(224, 288, 32)
    SCREEN _NEWIMAGE(224 * m%, 288 * m%, 32)
    _DELAY 0.5
    _SCREENMOVE _MIDDLE
    '$RESIZE:STRETCH
    _ALLOWFULLSCREEN _SQUAREPIXELS , _SMOOTH
    _TITLE "Galaga"
    _DEST virtualScreen&
    game.fps% = 30
    RANDOMIZE TIMER
    game.frameCounter& = 0
    textOffset% = 0
    textColour%(0) = SPRITE_TEXT_WHITE
    textColour%(1) = SPRITE_TEXT_RED
    textColour%(2) = SPRITE_TEXT_BLUE
    textColour%(3) = SPRITE_TEXT_YELLOW
    bossScores%(0) = 150
    bossScores%(1) = 400
    bossScores%(2) = 800
    bossScores%(3) = 1500
    LoadSprites
    AddPathData
    LoadAllSFX
    InitialiseStars
    ReadHiscores
END SUB

'===== High score management ==========================================================================================================================================================================

SUB ReadHiscores
    DIM i%, handle&
    ON ERROR GOTO fileReadError
    IF NOT _FILEEXISTS("scores.txt") THEN InitialiseHiscores: EXIT SUB
    handle& = FREEFILE
    OPEN "scores.txt" FOR INPUT AS #handle&
    FOR i% = 0 TO 4
        INPUT #handle&, hiscore(i%).score&
        INPUT #handle&, hiscore(i%).name$
    NEXT i%
    CLOSE #handle&
    ON ERROR GOTO 0
END SUB

SUB InitialiseHiscores
    DIM i%
    FOR i% = 0 TO 4
        IF i% = 0 THEN hiscore(i%).name$ = "WWW.ROKCODER.COM" ELSE hiscore(i%).name$ = "-c ROKCODER c-"
        hiscore(i%).score = 25000 - i% * 5000
    NEXT i%
END SUB

SUB WriteHiscores
    DIM i%, handle&
    ON ERROR GOTO fileWriteError
    handle& = FREEFILE
    OPEN "scores.txt" FOR OUTPUT AS #handle&
    FOR i% = 0 TO 4
        PRINT #handle&, hiscore(i%).score&
        PRINT #handle&, hiscore(i%).name$
    NEXT i%
    CLOSE #handle&
    ON ERROR GOTO 0
END SUB

SUB ShowHighScores (highlight%)
    STATIC pretext$(5)
    DIM i%, c%, s$
    IF pretext$(0) = "" THEN pretext$(0) = "1ST": pretext$(1) = "2ND": pretext$(2) = "3RD": pretext$(3) = "4TH": pretext$(4) = "5TH"
    PrintText "THE GALACTIC HEROES", 4, 4, 2
    PrintText "-- BEST 5 --", 7, 7, 1
    PrintText "SCORE  NAME", 5, 10, 2
    FOR i% = 0 TO 4
        c% = COLOUR_BLUE
        IF i% = highlight% THEN c% = COLOUR_RED
        s$ = LTRIM$(STR$(hiscore(i%).score&))
        PrintText pretext$(i%) + " " + s$ + SPACE$(7 + (LEN(hiscore(i%).name$) > MAX_NAME_LEN) - LEN(s$)) + hiscore(i%).name$, 1, 12 + i% * 2, c%
    NEXT i%
    PrintText "1ST BONUS FOR 20000 PTS", 4, 24, 3
    PrintText "2ND BONUS FOR 70000 PTS", 4, 27, 3
    PrintText "AND FOR EVERY 70000 PTS", 4, 30, 3
    PrintText "PRESS SPACE BAR", 7, 34, 2
END SUB

FUNCTION InsertScore%
    DIM i%, j%
    i% = 0
    WHILE game.score& <= hiscore(i%).score&: i% = i% + 1: WEND
    j% = 4
    WHILE j% > i%: hiscore(j%) = hiscore(j% - 1): j% = j% - 1: WEND
    hiscore(i%).name$ = "        "
    hiscore(i%).score& = game.score&
    InsertScore% = i%
END FUNCTION

FUNCTION EditName$ (name$, x%, c$)
    EditName$ = LEFT$(name$, x%) + c$ + RIGHT$(name$, LEN(name$) - x% - 1)
END FUNCTION

'===== Front end state machine ========================================================================================================================================================================

SUB UpdateFrontEnd (initialised%)
    IF initialised% = FALSE THEN
        frontend.state% = FE_SHOW_SCORES
        game.hiscore& = hiscore(0).score&
        HideOverlays
        WriteHiscores
    END IF
    SELECT CASE frontend.state%
        CASE FE_SHOW_SCORES
            stars.scroll% = TRUE
            ShowHighScores -1
            frontend.keyPressTarget% = TRUE
            frontend.state% = FE_WAIT_START_PRESS
            frontend.active = TRUE
        CASE FE_WAIT_START_PRESS
            IF _KEYDOWN(KEYDOWN_FIRE) = frontend.keyPressTarget% THEN
                frontend.keyPressTarget% = NOT frontend.keyPressTarget%
                IF frontend.keyPressTarget% = TRUE THEN
                    PlaySfx SFX_1_UP
                    frontend.pauseCounter% = 0.8 * game.fps%
                    frontend.state% = FE_PAUSE_BEFORE_OVER
                END IF
            END IF
        CASE FE_PAUSE_BEFORE_OVER
            frontend.pauseCounter% = frontend.pauseCounter% - 1
            IF frontend.pauseCounter% = 0 THEN
                frontend.active = FALSE
                game.gameOver% = FALSE
                PrepareGameEvents
            END IF
    END SELECT
END SUB

'===== Back end state machine =========================================================================================================================================================================

SUB UpdateBackEnd (initialised%)
    DIM p%, c$
    IF initialised% = FALSE THEN backend.state% = BE_STATS
    SELECT CASE backend.state%
        CASE BE_STATS
            StopSfx SFX_BOSS_GALAGA_TRACTOR_BEAM
            HideOverlays
            backend.cursor% = FALSE
            PrintText "-RESULTS-", 9, 17, COLOUR_RED
            PrintText "SHOTS FIRED", 4, 20, COLOUR_YELLOW
            PrintText "NUMBER OF HITS", 4, 23, COLOUR_YELLOW
            PrintText "HIT-MISS RATIO", 4, 26, COLOUR_WHITE
            PrintText "%", 25, 26, COLOUR_WHITE
            PrintText LTRIM$(STR$(stats.bulletCount%)), 20, 20, COLOUR_YELLOW
            PrintText LTRIM$(STR$(stats.bulletCount% - stats.bulletMissCount%)), 20, 23, COLOUR_YELLOW
            p% = (stats.bulletCount% - stats.bulletMissCount%) * 1000 / stats.bulletCount%
            PrintText LTRIM$(STR$(INT(p% / 10))) + "." + LTRIM$(STR$(p% MOD 10)), 20, 26, COLOUR_WHITE
            backend.pause% = 6 * game.fps%
            backend.state% = BE_POST_STATS_PAUSE
        CASE BE_POST_STATS_PAUSE
            backend.pause% = backend.pause% - 1
            IF backend.pause% = 0 THEN
                HideOverlays
                StopSfx SFX_AMBIENCE
                IF game.score& > hiscore(4).score& THEN
                    backend.state% = BE_ENTER_NAME
                    backend.substate% = 0
                    backend.score$ = LTRIM$(STR$(game.score&))
                    backend.name$ = SPC(MAX_NAME_LEN)
                    backend.cursorX% = 0
                    backend.pos% = InsertScore%
                    IF backend.pos% = 0 THEN PlaySfx SFX_NAME_ENTRY_1 ELSE PlaySfxLooping SFX_NAME_ENTRY_NOT_1
                    backend.timer% = 30 * game.fps%
                    _KEYCLEAR
                ELSE
                    PrepareFrontendEvents
                END IF
            END IF
        CASE BE_ENTER_NAME
            SELECT CASE backend.substate%
                CASE 0
                    c$ = UCASE$(INKEY$)
                    IF c$ <> "" THEN
                        IF INSTR(TEXTCHARS, c$) > 0 AND backend.cursorX% < MAX_NAME_LEN THEN
                            backend.name$ = EditName$(backend.name$, backend.cursorX%, c$)
                            backend.cursorX% = backend.cursorX% + 1
                        ELSE
                            IF c$ = CHR$(8) AND backend.cursorX% > 0 THEN
                                backend.cursorX% = backend.cursorX% - 1
                                backend.name$ = EditName$(backend.name$, backend.cursorX%, " ")
                            ELSEIF c$ = CHR$(0) + CHR$(83) AND backend.cursorX% < MAX_NAME_LEN THEN
                                backend.name$ = EditName$(backend.name$, backend.cursorX%, " ")
                            ELSEIF c$ = CHR$(0) + CHR$(75) AND backend.cursorX% > 0 THEN
                                backend.cursorX% = backend.cursorX% - 1
                            ELSEIF c$ = CHR$(0) + CHR$(77) AND backend.cursorX% < MAX_NAME_LEN THEN
                                backend.cursorX% = backend.cursorX% + 1
                            ELSEIF c$ = CHR$(13) THEN
                                PrepareFrontendEvents
                            END IF
                        END IF
                    END IF
                    HideOverlays
                    hiscore(backend.pos%).name$ = backend.name$
                    ShowHighScores backend.pos%
                    backend.cursor% = game.frameCounter& MOD game.fps% < game.fps% / 2
                    backend.timer% = backend.timer% - 1
                    IF (backend.pos% = 0 AND NOT IsPlayingSfx%(SFX_NAME_ENTRY_1)) OR (backend.pos% > 0 AND backend.timer% = 0) THEN
                        StopSfx SFX_NAME_ENTRY_1
                        StopSfx SFX_NAME_ENTRY_NOT_1
                        PrepareFrontendEvents
                    END IF
            END SELECT
    END SELECT
END SUB

'===== Simple utility functions =======================================================================================================================================================================

FUNCTION ValidateAngle! (angle!)
    WHILE angle! > 180: angle! = angle! - 360: WEND
    WHILE angle! < -180: angle! = angle! + 360: WEND
    ValidateAngle! = angle!
END FUNCTION

FUNCTION Min! (value1!, value2!)
    IF value1! < value2! THEN Min! = value1! ELSE Min! = value2!
END FUNCTION

FUNCTION Max! (value1!, value2!)
    IF value1! > value2! THEN Max! = value1! ELSE Max! = value2!
END FUNCTION

'===== Simple asset loading functions =================================================================================================================================================================

SUB AssetError (fname$)
    SCREEN 0
    PRINT "Unable to load "; fname$
    PRINT "Please make sure EXE is in same folder as galaga.bas"
    PRINT "(Set Run/Output EXE to Source Folder option in the IDE before compiling)"
    END
END SUB

FUNCTION LoadImage& (fname$)
    DIM asset&, f$
    f$ = "./assets/" + fname$ + ".png"
    asset& = _LOADIMAGE(f$, 32)
    IF asset& = -1 THEN AssetError (f$)
    LoadImage& = asset&
END FUNCTION

FUNCTION SndOpen& (fname$)
    DIM asset&, f$
    f$ = "./assets/" + fname$
    asset& = _SNDOPEN(f$)
    IF asset& = -1 THEN AssetError (f$)
    SndOpen& = asset&
END FUNCTION

'===== Simple image/sprite handling functions =========================================================================================================================================================

SUB DrawImage (handle&, x%, y%)
    _PUTIMAGE (112 + x% - _WIDTH(handle&) / 2, 288 - (y% + 180) - _HEIGHT(handle&) / 2), handle&
END SUB

SUB DrawSprite (sprite%, offset%, x%, y%)
    DIM handle&
    handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
    _PUTIMAGE (112 + x% - _WIDTH(handle&) / 2, 288 - (y% + 180) - _HEIGHT(handle&) / 2), handle&
END SUB

SUB DrawSpriteSection (sprite%, offset%, x%, y%, u%, v%, uWidth%, vHeight%)
    DIM handle&
    handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
    _PUTIMAGE (112 + x% - _WIDTH(handle&) / 2, 288 - (y% + 180) - _HEIGHT(handle&) / 2), handle&, , (u%, v%)-(u% + uWidth% - 1, v% + vHeight% - 1)
END SUB

SUB DrawRotatedSprite (sprite%, x%, y%, angle%, costumeOffset%)
    DIM handle&, r%, offset%, x1%, x2%, y1%, y2%
    handle& = spriteHandle&(spriteData(sprite%).offset%)
    x1% = 112 + x% - _WIDTH(handle&) / 2
    y1% = 288 - (y% + 180) - _HEIGHT(handle&) / 2
    x2% = 112 + x% + _WIDTH(handle&) / 2 - 1
    y2% = 288 - (y% + 180) + _HEIGHT(handle&) / 2 - 1
    r% = _ROUND(ValidateAngle!(angle%) / 360 * 24)
    IF r% = 0 THEN
        DrawSprite sprite%, 6 + costumeOffset%, x%, y%
    ELSE
        SELECT CASE r%
            CASE 0 TO 6
                offset% = 6 - r%
                handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
                _PUTIMAGE (x2%, y1%)-(x1%, y2%), handle&
            CASE -6 TO -1
                offset% = 6 + r%
                handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
                _PUTIMAGE (x1%, y1%)-(x2%, y2%), handle&
            CASE 7 TO 12
                offset% = r% - 6
                handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
                _PUTIMAGE (x2%, y2%)-(x1%, y1%), handle&
            CASE -12 TO -7
                offset% = -6 - r%
                handle& = spriteHandle&(spriteData(sprite%).offset% + offset%)
                _PUTIMAGE (x1%, y2%)-(x2%, y1%), handle&
        END SELECT
    END IF
END SUB

SUB LoadSpriteStrip (sprite%, sheet&, x%, y%, w%, h%, dx%, num%)
    DIM i%
    spriteData(sprite%).offset% = spriteLoadOffset%
    spriteData(sprite%).num% = num%
    FOR i% = 0 TO num% - 1
        spriteHandle&(spriteLoadOffset%) = _NEWIMAGE(w%, h%, 32)
        _PUTIMAGE , sheet&, spriteHandle&(spriteLoadOffset%), (x%, y%)-(x% + w% - 1, y% + h% - 1)
        _SETALPHA 0, _RGB32(0, 0, 0), spriteHandle&(spriteLoadOffset%)
        x% = x% + dx%
        spriteLoadOffset% = spriteLoadOffset% + 1
    NEXT i%
END SUB

SUB AppendSpriteStrip (sprite%, sheet&, x%, y%, w%, h%, dx%, num%)
    DIM i%
    IF spriteData(sprite%).offset% + spriteData(sprite%).num% <> spriteLoadOffset% THEN END 'Crappy handling but that's fine
    spriteData(sprite%).num% = spriteData(sprite%).num% + num%
    FOR i% = 0 TO num% - 1
        spriteHandle&(spriteLoadOffset%) = _NEWIMAGE(w%, h%, 32)
        _PUTIMAGE , sheet&, spriteHandle&(spriteLoadOffset%), (x%, y%)-(x% + w% - 1, y% + h% - 1)
        _SETALPHA 0, _RGB32(0, 0, 0), spriteHandle&(spriteLoadOffset%)
        x% = x% + dx%
        spriteLoadOffset% = spriteLoadOffset% + 1
    NEXT i%
END SUB

'===== Load all sprites needed by the game code =======================================================================================================================================================

SUB LoadSprites
    DIM s&, t&
    spriteLoadOffset% = 0
    s& = LoadImage&("sprites")
    t& = LoadImage&("text")
    LoadSpriteStrip SPRITE_PLAYER, s&, 1, 1, 16, 16, 18, 7
    LoadSpriteStrip SPRITE_PLAYER_CAPTURED, s&, 1, 19, 16, 16, 18, 7
    LoadSpriteStrip SPRITE_BULLET, s&, 307, 136, 16, 16, 0, 1
    LoadSpriteStrip SPRITE_BOSS_GALAGA, s&, 1, 37, 16, 16, 18, 8
    LoadSpriteStrip SPRITE_BOSS_GALAGA_HIT, s&, 1, 55, 16, 16, 18, 8
    LoadSpriteStrip SPRITE_BUTTERFLY, s&, 1, 73, 16, 16, 18, 8
    LoadSpriteStrip SPRITE_BEE, s&, 1, 91, 16, 16, 18, 8
    LoadSpriteStrip SPRITE_SCORPION, s&, 1, 109, 16, 16, 18, 7
    LoadSpriteStrip SPRITE_DRAGONFLY, s&, 1, 163, 16, 16, 18, 7
    LoadSpriteStrip SPRITE_BEAM, s&, 289, 36, 48, 80, 50, 3
    LoadSpriteStrip SPRITE_PLAYER_LIVES, s&, 289, 172, 16, 16, 0, 1
    LoadSpriteStrip SPRITE_PLAYER_EXPLOSION, s&, 145, 1, 32, 32, 34, 4
    LoadSpriteStrip SPRITE_ALIEN_EXPLOSION, s&, 289, 1, 32, 32, 34, 5
    LoadSpriteStrip SPRITE_TEXT_WHITE, t&, 453, 443, 8, 8, 9, 25
    AppendSpriteStrip SPRITE_TEXT_WHITE, t&, 453, 452, 8, 8, 9, 17
    LoadSpriteStrip SPRITE_TEXT_RED, t&, 453, 462, 8, 8, 9, 25
    AppendSpriteStrip SPRITE_TEXT_RED, t&, 453, 471, 8, 8, 9, 17
    LoadSpriteStrip SPRITE_TEXT_BLUE, t&, 453, 481, 8, 8, 9, 25
    AppendSpriteStrip SPRITE_TEXT_BLUE, t&, 453, 490, 8, 8, 9, 17
    LoadSpriteStrip SPRITE_TEXT_YELLOW, t&, 453, 500, 8, 8, 9, 25
    AppendSpriteStrip SPRITE_TEXT_YELLOW, t&, 453, 509, 8, 8, 9, 17
    LoadSpriteStrip SPRITE_FLAG, s&, 381, 172, 16, 16, -18, 3
    AppendSpriteStrip SPRITE_FLAG, s&, 328, 172, 14, 16, 0, 1
    AppendSpriteStrip SPRITE_FLAG, s&, 317, 172, 8, 16, -10, 2
    LoadSpriteStrip SPRITE_BOMB, s&, 307, 118, 16, 16, 0, 1
    LoadSpriteStrip SPRITE_SCORES, s&, 343, 118, 16, 16, 18, 3
    AppendSpriteStrip SPRITE_SCORES, s&, 343, 136, 16, 16, 0, 1
    AppendSpriteStrip SPRITE_SCORES, s&, 397, 118, 16, 16, 18, 2
    AppendSpriteStrip SPRITE_SCORES, s&, 361, 136, 32, 16, 34, 2
    starFrames&(0) = LoadImage&("stars1")
    starFrames&(1) = LoadImage&("stars2")
    starFrames&(2) = LoadImage&("stars3")
    starFrames&(3) = LoadImage&("stars4")
    stars.overlay = LoadImage&("stars border")
    _FREEIMAGE s&
END SUB

'===== Rendering code for the front end, main game and back end =======================================================================================================================================

SUB RenderFrontend (initialised%)
    DIM handle&
    CLS
    RenderStars
    handle& = spriteHandle&(spriteData(SPRITE_PLAYER_LIVES).offset%)
    _PUTIMAGE (1 * 8, 23 * 8 + 3), handle&
    _PUTIMAGE (1 * 8, 26 * 8 + 3), handle&
    _PUTIMAGE (1 * 8, 29 * 8 + 3), handle&
    RenderText
    UpdateFromVirtualScreen
END SUB

SUB RenderBackend (initialised%)
    DIM handle&
    CLS
    RenderStars
    IF backend.state% = BE_ENTER_NAME THEN
        handle& = spriteHandle&(spriteData(SPRITE_PLAYER_LIVES).offset%)
        _PUTIMAGE (1 * 8, 23 * 8 + 3), handle&
        _PUTIMAGE (1 * 8, 26 * 8 + 3), handle&
        _PUTIMAGE (1 * 8, 29 * 8 + 3), handle&
    END IF
    RenderText
    IF backend.cursor% THEN handle& = spriteHandle&(spriteData(textColour%(COLOUR_WHITE)).offset% + INSTR(TEXTCHARS, " ") - 1): _PUTIMAGE ((12 + backend.cursorX%) * 8, (12 + backend.pos% * 2) * 8), handle&
    UpdateFromVirtualScreen
END SUB

SUB RenderScene (initialised%)
    STATIC matchingSprite%(32)
    DIM i%, frame%, sections%
    IF initialised% = FALSE THEN
        matchingSprite%(TYPE_PLAYER) = SPRITE_PLAYER
        matchingSprite%(TYPE_PLAYER_CAPTURED) = SPRITE_PLAYER_CAPTURED
        matchingSprite%(TYPE_BOSS_GALAGA) = SPRITE_BOSS_GALAGA
        matchingSprite%(TYPE_BOSS_GALAGA_SHOT) = SPRITE_BOSS_GALAGA_HIT
        matchingSprite%(TYPE_BUTTERFLY) = SPRITE_BUTTERFLY
        matchingSprite%(TYPE_BEE) = SPRITE_BEE
        matchingSprite%(TYPE_DRAGONFLY) = SPRITE_DRAGONFLY
        matchingSprite%(TYPE_SCORPION) = SPRITE_SCORPION
    END IF
    CLS
    RenderStars
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).controlPath% <> PT_WAITING AND alienData(i%).controlPath% <> PT_INACTIVE AND (alienData(i%).currentAction <> CMD_WAIT_FOR_CAPTURE OR player.state% = PLAYER_CAPTURING) AND alienData(i%).pathDelay% = -1 THEN
            IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                DrawRotatedSprite matchingSprite%(alienData(i%).alienType%), alienData(i%).xPos!, alienData(i%).yPos!, alienData(i%).rotation!, alienData(i%).costume%
            END IF
        END IF
    NEXT i%
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).controlPath% <> PT_WAITING AND alienData(i%).controlPath% <> PT_INACTIVE AND (alienData(i%).currentAction <> CMD_WAIT_FOR_CAPTURE OR player.state% = PLAYER_CAPTURING) AND alienData(i%).pathDelay% = -1 THEN
            SELECT CASE alienData(i%).currentAction%
                CASE CMD_DEAD
                    DrawSprite SPRITE_ALIEN_EXPLOSION, INT(alienData(i%).explosionCounter% / 2), alienData(i%).xPos!, alienData(i%).yPos!
                CASE CMD_HOLD_FORMATION, CMD_INACTIVE, CMD_DESTROYED, CMD_NONE
                CASE ELSE
                    SELECT CASE alienData(i%).alienType%
                        CASE TYPE_BOSS_GALAGA, TYPE_BOSS_GALAGA_SHOT, TYPE_BUTTERFLY, TYPE_BEE
                            DrawRotatedSprite matchingSprite%(alienData(i%).alienType%), alienData(i%).xPos!, alienData(i%).yPos!, alienData(i%).rotation!, alienData(i%).costume%
                        CASE ELSE
                            DrawRotatedSprite matchingSprite%(alienData(i%).alienType%), alienData(i%).xPos!, alienData(i%).yPos!, alienData(i%).rotation!, 0
                    END SELECT
            END SELECT
        END IF
    NEXT i%
    i% = CaptorId%
    IF i% > -1 THEN
        IF alienData(i%).beamActive% = TRUE THEN
            frame% = INT(alienData(i%).captureCounter% / 2) MOD 3
            IF alienData(i%).captureCounter < 18 * 6 THEN
                sections% = INT(alienData(i%).captureCounter% / 12)
            ELSE
                sections% = 8 - INT(alienData(i%).captureCounter% - 18 * 6) / 12
            END IF
            DrawSpriteSection SPRITE_BEAM, frame%, alienData(i%).xPos!, alienData(i%).yPos! - 48, 0, 0, 48, 8 * (sections% + 1)
        END IF
    END IF
    FOR i% = 0 TO MAX_BULLETS - 1
        IF bullet(i%).state% = BULLET_ACTIVE THEN DrawSprite SPRITE_BULLET, 0, bullet(i%).xPos%, bullet(i%).yPos%
    NEXT i%
    FOR i% = 0 TO UBOUND(bomb) - 1: DrawSprite SPRITE_BOMB, 0, bomb(i%).xPos!, bomb(i%).yPos!: NEXT i%
    UpdateSpawnedAnimations
    FOR i% = 0 TO 1
        SELECT CASE ship(i%).state%
            CASE SHIP_EXPLODING
                DrawSprite SPRITE_PLAYER_EXPLOSION, INT(ship(i%).counter% / 8), ship(i%).xPos%, player.yPos%
            CASE SHIP_ACTIVE
                DrawSprite SPRITE_PLAYER, 6, ship(i%).xPos%, player.yPos%
        END SELECT
    NEXT i%
    FOR i% = 0 TO player.lives% - 1: DrawSprite SPRITE_PLAYER_LIVES, 0, i% * 14 - 103, -172: NEXT i%
    FOR i% = 0 TO UBOUND(flagDisplay) - 1: DrawSprite SPRITE_FLAG, flagDisplay(i%).flag, flagDisplay(i%).xpos%, -172: NEXT i%
    RenderText
    UpdateFromVirtualScreen
END SUB

SUB RenderStars
    DIM i%
    FOR i% = 0 TO 1
        DrawImage starFrames&(INT(game.frameCounter& / 4) MOD 4), 0, i% * 256 - 36 - (stars.yPos% MOD 256)
    NEXT i%
    DrawImage stars.overlay, 0, -36
END SUB

SUB RenderText
    DIM i%, x%, y%, c%, c$, j%, handle&
    IF textOffset% > 0 THEN
        FOR i% = 0 TO textOffset% - 1
            x% = text(i%).x%
            y% = text(i%).y%
            c% = textColour%(text(i%).colour%)
            FOR j% = 0 TO LEN(text(i%).text$) - 1
                c$ = MID$(text(i%).text$, j% + 1, 1)
                IF c$ <> " " THEN handle& = spriteHandle&(spriteData(c%).offset% + INSTR(TEXTCHARS, c$) - 1): _PUTIMAGE (x% * 8, y% * 8), handle&
                x% = x% + 1
            NEXT j%
        NEXT i%
    END IF
END SUB

SUB UpdateFromVirtualScreen
    game.frameCounter& = game.frameCounter& + 1
    _PUTIMAGE , virtualScreen&, 0
    _DISPLAY
END SUB

'===== In-game text handling ==========================================================================================================================================================================

SUB PrintText (text$, x%, y%, colour%)
    text(textOffset%).text$ = text$
    text(textOffset%).x% = x%
    text(textOffset%).y% = y%
    text(textOffset%).colour% = colour%
    textOffset% = textOffset% + 1
END SUB

SUB HideOverlays
    textOffset% = 0
    ShowScoreAndHiscore
END SUB

'===== In-game sprite animation spawning and destroying ===============================================================================================================================================

SUB SpawnAnimation (spawnType%, alien AS ALIENDATA)
    DIM i%
    FOR i% = 0 TO MAX_SPAWNS - 1
        IF spawnedAnimation(i%).spawnType% = SPAWN_NONE THEN
            spawnedAnimation(i%).spawnType% = spawnType%
            spawnedAnimation(i%).xPos% = alien.xPos!
            spawnedAnimation(i%).yPos% = alien.yPos!
            spawnedAnimation(i%).value% = alien.scoreCostume%
            spawnedAnimation(i%).counter% = 0
            EXIT FOR
        END IF
    NEXT i%
END SUB

SUB UpdateSpawnedAnimations
    DIM i%
    FOR i% = 0 TO MAX_SPAWNS - 1
        IF spawnedAnimation(i%).spawnType% <> SPAWN_NONE THEN
            SELECT CASE spawnedAnimation(i%).spawnType%
                CASE SPAWN_EXPLOSION
                    IF spawnedAnimation(i%).counter% = 10 THEN
                        spawnedAnimation(i%).spawnType% = SPAWN_NONE
                    ELSE
                        DrawSprite SPRITE_ALIEN_EXPLOSION, INT(spawnedAnimation(i%).counter% / 2), spawnedAnimation(i%).xPos%, spawnedAnimation(i%).yPos%
                    END IF
                CASE SPAWN_SCORE
                    IF spawnedAnimation(i%).counter% >= 0.8 * game.fps% THEN
                        spawnedAnimation(i%).spawnType% = SPAWN_NONE
                    ELSE
                        DrawSprite SPRITE_SCORES, spawnedAnimation(i%).value%, spawnedAnimation(i%).xPos%, spawnedAnimation(i%).yPos%
                    END IF
            END SELECT
            spawnedAnimation(i%).counter% = spawnedAnimation(i%).counter% + 1
            EXIT FOR
        END IF
    NEXT i%
END SUB

'===== The "player" can consist of either one or two "ships" simultaneously ===========================================================================================================================

SUB InitialisePlayer
    DIM i%
    player.doubleShip% = FALSE
    player.canFire% = FALSE
    player.xPos% = 9
    player.yPos% = -156
    player.state% = PLAYER_INACTIVE
    FOR i% = 0 TO 1
        ship(i%).isHit% = FALSE
        ship(i%).state% = SHIP_INACTIVE
    NEXT i%
END SUB

SUB SpawnShip
    DIM id%
    player.lives% = player.lives% - 1
    id% = 0 - (ship(0).state% = SHIP_ACTIVE)
    ship(id%).isHit% = FALSE
    ship(id%).state% = SHIP_ACTIVE
    UpdateShip (id%)
END SUB

SUB UpdatePlayer (initialised%)
    DIM i%
    SELECT CASE player.state%
        CASE PLAYER_DOUBLING_UP
            IF player.xPos% < 0 THEN
                player.xPos% = Min!(0, player.xPos% + 2)
            ELSEIF player.xPos% > 0 THEN
                player.xPos% = Max!(0, player.xPos% - 2)
            END IF
        CASE PLAYER_ACTIVE
            IF _KEYDOWN(KEYDOWN_LEFT) AND player.xPos% > -111 - 16 * (ship(0).state% = SHIP_ACTIVE) THEN player.xPos% = player.xPos% - 3
            IF _KEYDOWN(KEYDOWN_RIGHT) AND player.xPos% < 111 + 16 * (ship(1).state% = SHIP_ACTIVE) THEN player.xPos% = player.xPos% + 3

            IF player.canFire% THEN
                IF _KEYDOWN(KEYDOWN_FIRE) THEN
                    IF NOT player.fireKeyDown% THEN
                        player.fireKeyDown% = TRUE
                        fireBullet
                    END IF
                ELSE
                    player.fireKeyDown% = FALSE
                END IF
            END IF
        CASE PLAYER_SPAWNING
            IF waveData.aliensInFormation% AND waveData.bombCount% = 0 THEN
                waveData.aliensAttackingPauseCounter% = 60
                waveData.aliensCanAttack% = TRUE
                player.xPos% = 9
                SpawnShip
                player.state% = PLAYER_ACTIVE
            END IF
    END SELECT
    FOR i% = 0 TO 1: UpdateShip i%: NEXT i%
END SUB

SUB NewLife
    IF player.state% = PLAYER_WAITING_TO_DOUBLE THEN EXIT SUB
    IF player.lives% > 0 THEN
        player.state% = PLAYER_SPAWNING
        player.canFire% = FALSE
        waveData.aliensCanAttack% = FALSE
    ELSE
        player.state% = PLAYER_INACTIVE
        player.lives% = -1
        game.gameOver% = TRUE
        game.gameOverCounter% = 5 * game.fps%
        waveData.aliensCanAttack% = FALSE
        HideOverlays
        PrintText "GAME OVER", 10, 18, COLOUR_BLUE
    END IF
END SUB

SUB UpdateShip (i%)
    SELECT CASE ship(i%).state%
        CASE SHIP_EXPLODING
            ship(i%).counter% = ship(i%).counter% + 1
            IF ship(i%).counter% = 32 THEN
                ship(i%).state% = SHIP_INACTIVE
                IF ship(0).state% <> SHIP_ACTIVE AND ship(1).state% <> SHIP_ACTIVE AND player.state% <> PLAYER_WAITING_TO_DOUBLE THEN
                    PrintText "READY", 10, 18, COLOUR_BLUE
                    NewLife
                END IF
                player.doubleShip% = FALSE
            END IF
        CASE SHIP_ACTIVE
            ship(i%).xPos% = player.xPos% - 8 + 16 * i%
            IF player.state% = PLAYER_CAPTURING THEN ship(i%).state% = SHIP_INACTIVE: EXIT SUB
            IF ship(i%).isHit% = TRUE THEN
                ship(i%).isHit% = FALSE
                PlaySfx SFX_DIE
                IF ship(0).state% <> SHIP_ACTIVE AND ship(1).state% <> SHIP_ACTIVE AND player.state% <> PLAYER_WAITING_TO_DOUBLE THEN waveData.aliensCanAttack% = FALSE
                ship(i%).state% = SHIP_EXPLODING
                ship(i%).counter% = 0
            END IF
    END SELECT
END SUB

SUB DoubleUpShip
    player.state% = PLAYER_DOUBLING_UP
    player.canFire% = FALSE
END SUB

SUB ShipDoubledUp
    player.doubleShip% = ship(0).state% = SHIP_ACTIVE OR ship(1).state% = SHIP_ACTIVE
    SpawnShip
    player.state% = PLAYER_ACTIVE
    player.canFire% = TRUE
    StopSfx (SFX_FIGHTER_RESCUED)
    player.lives = player.lives + 1
END SUB

'===== Bullet management system =======================================================================================================================================================================

SUB InitialiseBullets
    DIM i%
    FOR i% = 0 TO MAX_BULLETS - 1: bullet(i%).state% = BULLET_NONE: NEXT i%
    stats.bulletCount% = 0
    stats.bulletMissCount% = 0
END SUB

SUB fireBullet
    DIM i%
    FOR i% = 0 TO MAX_BULLETS_PER_SHIP - 1
        IF bullet(i%).state% = BULLET_NONE AND bullet(i% + MAX_BULLETS_PER_SHIP).state% = BULLET_NONE THEN
            PlaySfx SFX_FIGHTER_SHOOT
            IF ship(0).state% = SHIP_ACTIVE THEN ActivateBullet i%: stats.bulletCount% = stats.bulletCount% + 1
            IF ship(1).state% = SHIP_ACTIVE THEN ActivateBullet i% + MAX_BULLETS_PER_SHIP
            EXIT SUB
        END IF
    NEXT i%
END SUB

SUB ActivateBullet (i%)
    bullet(i%).state% = BULLET_ACTIVE
    bullet(i%).waitToRemoveCounter% = 0.1 * game.fps%
    bullet(i%).xPos% = ship(INT(i% / MAX_BULLETS_PER_SHIP)).xPos%
    bullet(i%).yPos% = player.yPos%
END SUB

SUB UpdateBullets (initialised%)
    DIM i%
    FOR i% = 0 TO MAX_BULLETS - 1
        IF bullet(i%).state% = BULLET_REMOVING THEN
            IF i% < MAX_BULLETS_PER_SHIP THEN
                bullet(i% + MAX_BULLETS_PER_SHIP).state% = BULLET_REMOVING
            ELSE
                bullet(i% - MAX_BULLETS_PER_SHIP).state% = BULLET_REMOVING
            END IF
        END IF
    NEXT i%
    FOR i% = 0 TO MAX_BULLETS - 1
        SELECT CASE bullet(i%).state%
            CASE BULLET_ACTIVE
                bullet(i%).yPos% = bullet(i%).yPos% + 12
                IF OffTop%(bullet(i%).yPos%) THEN
                    bullet(i%).state% = BULLET_NONE
                    IF i% < MAX_BULLETS_PER_SHIP THEN stats.bulletMissCount% = stats.bulletMissCount% + 1
                END IF
            CASE BULLET_REMOVING
                bullet(i%).waitToRemoveCounter% = bullet(i%).waitToRemoveCounter% - 1
                IF bullet(i%).waitToRemoveCounter% <= 0 THEN bullet(i%).state% = BULLET_NONE
        END SELECT
    NEXT i%
END SUB

'===== Stars manager ==================================================================================================================================================================================

SUB InitialiseStars
    stars.scroll = FALSE
    stars.yPos = 0
END SUB

SUB UpdateStars (initialised%)
    stars.yPos = stars.yPos - 2 * stars.scroll
END SUB

'===== Construction of alien attack and movement patterns =============================================================================================================================================

FUNCTION ExtrasFromAbove%
    ExtrasFromAbove% = Min!(8, game.stage% / 4)
END FUNCTION

FUNCTION ExtrasFromSide%
    ExtrasFromSide% = Min!(8, Max!(0, (game.stage% - 2) / 4))
END FUNCTION

FUNCTION WaveType%
    IF game.stage% < 3 THEN WaveType% = game.stage% ELSE WaveType% = 4 - ((game.stage% - 3) MOD 4)
END FUNCTION

FUNCTION ChallengeWaveType%
    ChallengeWaveType% = (((game.stage% - 3) / 4) MOD NUM_CHALLENGE_PATHS) + 1
END FUNCTION

SUB CreateWavePrepare
    DIM i%
    waveData.section% = 1
    FOR i% = 0 TO MAX_ALIENS - 1
        alienData(i%).controlPath% = PT_WAITING
        alienData(i%).currentAction% = CMD_NONE
        alienData(i%).alienType% = TYPE_NONE
        alienData(i%).isCaptive% = FALSE
        alienData(i%).isCaptor% = FALSE
    NEXT i%
    initialiseAlienIndex% = 0
END SUB

SUB InitialiseAlien (pathName%, delay%, formationX!, formationY!, alienType%, direction%)
    alienData(initialiseAlienIndex%).controlPath% = pathName%
    alienData(initialiseAlienIndex%).currentAction% = CMD_NONE
    alienData(initialiseAlienIndex%).formationXOffset! = formationX!
    alienData(initialiseAlienIndex%).formationYOffset! = formationY!
    alienData(initialiseAlienIndex%).direction% = direction%
    alienData(initialiseAlienIndex%).alienType% = alienType%
    alienData(initialiseAlienIndex%).pathDelay% = delay%
    alienData(initialiseAlienIndex%).batchNum% = INT(initialiseAlienIndex% / 8)
    initialiseAlienIndex% = initialiseAlienIndex% + 1
END SUB

SUB CreateWave
    SELECT CASE WaveType%
        CASE 1:
            SELECT CASE waveData.section%
                CASE 1: CreateWaveType1Section1
                CASE 2: CreateWaveType1Section2
                CASE 3: CreateWaveType1Section3
                CASE 4: CreateWaveType1Section4
                CASE 5: CreateWaveType1Section5
            END SELECT
        CASE 2:
            SELECT CASE waveData.section%
                CASE 1: CreateWaveType2Section1
                CASE 2: CreateWaveType2Section2
                CASE 3: CreateWaveType2Section3
                CASE 4: CreateWaveType2Section4
                CASE 5: CreateWaveType2Section5
            END SELECT
        CASE 3:
            SELECT CASE waveData.section%
                CASE 1: CreateWaveType3Section1
                CASE 2: CreateWaveType3Section2
                CASE 3: CreateWaveType3Section3
                CASE 4: CreateWaveType3Section4
                CASE 5: CreateWaveType3Section5
            END SELECT
    END SELECT
    waveData.section% = waveData.section% + 1
END SUB

SUB CreateChallengeWave
    SELECT CASE ChallengeWaveType%
        CASE 1:
            SELECT CASE waveData.section%
                CASE 1: CreateChallengeWaveType1Section1
                CASE 2: CreateChallengeWaveType1Section2
                CASE 3: CreateChallengeWaveType1Section3
                CASE 4: CreateChallengeWaveType1Section4
                CASE 5: CreateChallengeWaveType1Section5
            END SELECT
        CASE 2:
            SELECT CASE waveData.section%
                CASE 1: CreateChallengeWaveType2Section1
                CASE 2: CreateChallengeWaveType2Section2
                CASE 3: CreateChallengeWaveType2Section3
                CASE 4: CreateChallengeWaveType2Section4
                CASE 5: CreateChallengeWaveType2Section5
            END SELECT
        CASE 3:
            SELECT CASE waveData.section%
                CASE 1: CreateChallengeWaveType3Section1
                CASE 2: CreateChallengeWaveType3Section2
                CASE 3: CreateChallengeWaveType3Section3
                CASE 4: CreateChallengeWaveType3Section4
                CASE 5: CreateChallengeWaveType3Section5
            END SELECT
        CASE 4:
            SELECT CASE waveData.section%
                CASE 1: CreateChallengeWaveType4Section1
                CASE 2: CreateChallengeWaveType4Section2
                CASE 3: CreateChallengeWaveType4Section3
                CASE 4: CreateChallengeWaveType4Section4
                CASE 5: CreateChallengeWaveType4Section5
            END SELECT
    END SELECT
    waveData.section% = waveData.section% + 1
END SUB

'===== Patterns for aliens entering the three different entrance types ================================================================================================================================

SUB CreateWaveType1Section1
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
    NEXT i%
END SUB

SUB CreateWaveType1Section2
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, -1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, -1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, -0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, 1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 32, 0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 40, -1.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 48, 1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 56, 1.5, 3, TYPE_BUTTERFLY, 1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 64 + i% * 8, 0, 0, 0 + (i% MOD 2) * 2, 1
    NEXT i%
END SUB

SUB CreateWaveType1Section3
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, 3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, 2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, 3.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, 2.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 32, -3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 40, -2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 48, -3.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 56, -2.5, 3, TYPE_BUTTERFLY, -1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 64 + i% * 8, 0, 0, TYPE_BUTTERFLY, -1
    NEXT i%
END SUB

SUB CreateWaveType1Section4
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, 2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, 2.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 32, -1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 40, -2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 48, -1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 56, -2.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 64 + i% * 8, 0, 0, TYPE_BEE, 1
    NEXT i%
END SUB

SUB CreateWaveType1Section5
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, -3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -4.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, -3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 32, 3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 40, 4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 48, 3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 56, 4.5, 5, TYPE_BEE, 1
    IF NOT waveData.playerInStorage% THEN
        InitialiseAlien PT_WAIT_FOR_CAPTURE, 0, 0, 0, TYPE_PLAYER, 1
    ELSE
        waveData.playerInStorage% = FALSE
        i% = RandomBoss%
        InitialiseAlien PT_NEW_WAVE_FROM_TOP, 64, alienData(i%).formationXOffset!, 0, TYPE_PLAYER_CAPTURED, 1
        alienData(initialiseAlienIndex% - 1).isCaptive% = TRUE
        alienData(i%).isCaptor% = TRUE
    END IF
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 64 + i% * 8, 0, 0, TYPE_BEE, 1
    NEXT i%
END SUB

SUB CreateWaveType2Section1
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
    NEXT i%
END SUB

SUB CreateWaveType2Section2
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, -1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 0, -1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, -0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 8, 1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, 0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 16, -1.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, 1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 24, 1.5, 3, TYPE_BUTTERFLY, 1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BOSS_GALAGA, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_HIGHER_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, 1
    NEXT i%
END SUB

SUB CreateWaveType2Section3
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, 3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 0, 2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, 3.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 8, 2.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, -3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 16, -2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, -3.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER, 24, -2.5, 3, TYPE_BUTTERFLY, -1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, -1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_HIGHER_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, -1
    NEXT i%
END SUB

SUB CreateWaveType2Section4
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, 2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 0, 1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 2.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 8, 1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 16, -2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, -1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 24, -2.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
    NEXT i%
END SUB

SUB CreateWaveType2Section5
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 0, -3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, -4.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 8, -3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, 3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 16, 4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 24, 4.5, 5, TYPE_BEE, 1
    IF NOT waveData.playerInStorage% THEN
        InitialiseAlien PT_WAIT_FOR_CAPTURE, 0, 0, 0, TYPE_PLAYER, 1
    ELSE
        waveData.playerInStorage% = FALSE
        i% = RandomBoss%
        InitialiseAlien PT_NEW_WAVE_FROM_TOP, 32, alienData(i%).formationXOffset!, 0, TYPE_PLAYER_CAPTURED, 1
        alienData(initialiseAlienIndex% - 1).isCaptive% = TRUE
        alienData(i%).isCaptor% = TRUE
    END IF
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, 1
    NEXT i%
END SUB

SUB CreateWaveType3Section1
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 0.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -0.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 0.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
    NEXT i%
END SUB

SUB CreateWaveType3Section2
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, -1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, -0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, 0.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, 1.5, 1, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, 3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, 3.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, -3.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, -3.5, 3, TYPE_BUTTERFLY, -1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BOSS_GALAGA, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, -1
    NEXT i%
END SUB

SUB CreateWaveType3Section3
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, -1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, 1.5, 2, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, -1.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, 1.5, 3, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 0, 2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 8, 2.5, 3, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 16, -2.5, 2, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_NEW_WAVE_FROM_SIDE, 24, -2.5, 3, TYPE_BUTTERFLY, -1
    FOR i% = 0 TO ExtrasFromSide% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE, 32 + i% * 8, 0, 0, TYPE_BUTTERFLY, -1
    NEXT i%
END SUB

SUB CreateWaveType3Section4
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, 2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 0, 1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, 2.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 8, 1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, -1.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 16, -2.5, 4, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, -1.5, 5, TYPE_BEE, -1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 24, -2.5, 5, TYPE_BEE, -1
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, -1
    NEXT i%
END SUB

SUB CreateWaveType3Section5
    DIM i%
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 0, -4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 0, -3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 8, -4.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 8, -3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 16, 3.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 16, 4.5, 4, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP, 24, 3.5, 5, TYPE_BEE, 1
    InitialiseAlien PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD, 24, 4.5, 5, TYPE_BEE, 1
    IF NOT waveData.playerInStorage% THEN
        InitialiseAlien PT_WAIT_FOR_CAPTURE, 0, 0, 0, TYPE_PLAYER, 1
    ELSE
        waveData.playerInStorage% = FALSE
        i% = RandomBoss%
        InitialiseAlien PT_NEW_WAVE_FROM_TOP, 32, alienData(i%).formationXOffset!, 0, TYPE_PLAYER_CAPTURED, 1
        alienData(initialiseAlienIndex% - 1).isCaptive% = TRUE
        alienData(i%).isCaptor% = TRUE
    END IF
    FOR i% = 0 TO ExtrasFromAbove% / 2 - 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, 1
        InitialiseAlien PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP, 32 + i% * 8, 0, 0, TYPE_BEE, 1
    NEXT i%
END SUB

FUNCTION RandomBoss%
    DIM i%, t%
    t% = INT(RND * 4)
    DO
        IF alienData(i%).alienType = TYPE_BOSS_GALAGA THEN
            t% = t% - 1
            IF t% < 0 THEN RandomBoss% = i%: EXIT FUNCTION
        END IF
        i% = i% + 1
    LOOP
END FUNCTION

'===== Patterns for aliens entering the four different challenge types ===============================================================================================================================

SUB CreateChallengeWaveType1Section1
    InitialiseAlien PT_CHALLENGE1A, 0, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 0, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 8, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 8, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 16, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 16, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 24, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 24, 0, 0, TYPE_BEE, -1
END SUB
SUB CreateChallengeWaveType1Section2
    InitialiseAlien PT_CHALLENGE1B, 0, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE1B, 8, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1B, 16, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE1B, 24, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1B, 32, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE1B, 40, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1B, 48, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE1B, 56, 0, 0, TYPE_BEE, 1
END SUB
SUB CreateChallengeWaveType1Section3
    InitialiseAlien PT_CHALLENGE1B, 0, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 8, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 16, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 24, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 32, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 40, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 48, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1B, 56, 0, 0, TYPE_BEE, -1
END SUB
SUB CreateChallengeWaveType1Section4
    InitialiseAlien PT_CHALLENGE1A, 0, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 8, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 16, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 24, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 32, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 40, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 48, 0, 0, TYPE_BEE, -1
    InitialiseAlien PT_CHALLENGE1A, 56, 0, 0, TYPE_BEE, -1
END SUB
SUB CreateChallengeWaveType1Section5
    InitialiseAlien PT_CHALLENGE1A, 0, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 8, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 16, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 24, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 32, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 40, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 48, 0, 0, TYPE_BEE, 1
    InitialiseAlien PT_CHALLENGE1A, 56, 0, 0, TYPE_BEE, 1
END SUB

SUB CreateChallengeWaveType2Section1
    InitialiseAlien PT_CHALLENGE2A, 0, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 0, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 8, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 8, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 16, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 16, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 24, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 24, 0, 0, TYPE_BUTTERFLY, -1
END SUB
SUB CreateChallengeWaveType2Section2
    InitialiseAlien PT_CHALLENGE2B, 0, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE2B, 8, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 16, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE2B, 24, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 32, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE2B, 40, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 48, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE2B, 56, 0, 0, TYPE_BUTTERFLY, -1
END SUB
SUB CreateChallengeWaveType2Section3
    InitialiseAlien PT_CHALLENGE2B, 0, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2B, 0, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 8, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2B, 8, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 16, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2B, 16, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2B, 24, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2B, 24, 0, 0, TYPE_BUTTERFLY, -1
END SUB
SUB CreateChallengeWaveType2Section4
    InitialiseAlien PT_CHALLENGE2A, 0, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 8, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 16, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 24, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 32, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 40, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 48, 0, 0, TYPE_BUTTERFLY, -1
    InitialiseAlien PT_CHALLENGE2A, 56, 0, 0, TYPE_BUTTERFLY, -1
END SUB
SUB CreateChallengeWaveType2Section5
    InitialiseAlien PT_CHALLENGE2A, 0, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 8, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 16, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 24, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 32, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 40, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 48, 0, 0, TYPE_BUTTERFLY, 1
    InitialiseAlien PT_CHALLENGE2A, 56, 0, 0, TYPE_BUTTERFLY, 1
END SUB

SUB CreateChallengeWaveType3Section1
    InitialiseAlien PT_CHALLENGE3A, 0, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 8, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 16, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 24, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 32, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 40, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 48, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 56, 0, 0, TYPE_DRAGONFLY, 1
END SUB
SUB CreateChallengeWaveType3Section2
    InitialiseAlien PT_CHALLENGE3C, 0, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE3C, 0, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 8, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE3C, 8, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 16, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE3C, 16, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 24, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE3C, 24, 0, 0, TYPE_DRAGONFLY, -1
END SUB
SUB CreateChallengeWaveType3Section3
    InitialiseAlien PT_CHALLENGE3C, 0, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3C, 0, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 8, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3C, 8, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 16, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3C, 16, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3C, 24, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3C, 24, 0, 0, TYPE_DRAGONFLY, -1
END SUB
SUB CreateChallengeWaveType3Section4
    InitialiseAlien PT_CHALLENGE3A, 0, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 8, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 16, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 24, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 32, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 40, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3A, 48, 0, 0, TYPE_DRAGONFLY, 1
    InitialiseAlien PT_CHALLENGE3B, 56, 0, 0, TYPE_DRAGONFLY, 1
END SUB
SUB CreateChallengeWaveType3Section5
    InitialiseAlien PT_CHALLENGE3A, 0, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3B, 8, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3A, 16, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3B, 24, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3A, 32, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3B, 40, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3A, 48, 0, 0, TYPE_DRAGONFLY, -1
    InitialiseAlien PT_CHALLENGE3B, 56, 0, 0, TYPE_DRAGONFLY, -1
END SUB

SUB CreateChallengeWaveType4Section1
    InitialiseAlien PT_CHALLENGE4A, 0, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 0, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 8, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 8, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 16, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 16, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 24, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 24, 0, 0, TYPE_SCORPION, 1
END SUB
SUB CreateChallengeWaveType4Section2
    InitialiseAlien PT_CHALLENGE4C, 0, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE4C, 8, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4C, 16, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE4C, 24, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4C, 32, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE4C, 40, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4C, 48, 0, 0, TYPE_BOSS_GALAGA, 1
    InitialiseAlien PT_CHALLENGE4C, 56, 0, 0, TYPE_SCORPION, 1
END SUB
SUB CreateChallengeWaveType4Section3
    InitialiseAlien PT_CHALLENGE4C, 0, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 8, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 16, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 24, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 32, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 40, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 48, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4C, 56, 0, 0, TYPE_SCORPION, -1
END SUB
SUB CreateChallengeWaveType4Section4
    InitialiseAlien PT_CHALLENGE4A, 0, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 0, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 8, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 8, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 16, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 16, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4A, 24, 0, 0, TYPE_SCORPION, 1
    InitialiseAlien PT_CHALLENGE4B, 24, 0, 0, TYPE_SCORPION, 1
END SUB
SUB CreateChallengeWaveType4Section5
    InitialiseAlien PT_CHALLENGE4A, 0, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4B, 0, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4A, 8, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4B, 8, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4A, 16, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4B, 16, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4A, 24, 0, 0, TYPE_SCORPION, -1
    InitialiseAlien PT_CHALLENGE4B, 24, 0, 0, TYPE_SCORPION, -1
END SUB

'===== Defining the commands that build up the paths ==================================================================================================================================================

SUB AddPathData
    SetPathType PT_NEW_WAVE_FROM_TOP
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 18, 3, -3
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 30, 3, 6
    AddToPath_JoinFormation
    SetPathType PT_NEW_WAVE_FROM_SIDE
    AddToPath_SetPosition 0, 250, 270
    AddToPath_Movement 48, 3, -2
    AddToPath_Movement 48, 3, -6
    AddToPath_JoinFormation
    SetPathType PT_UP_AND_DIVE_WITH_BOSS
    AddToPath_LeaveFormation
    AddToPath_Movement 3, 2, 6
    AddToPath_Movement 48, 2, 0
    AddToPath_Movement 63, 2, 6
    AddToPath_Movement 36, 2, 0
    AddToPath_ContinueFlight 2, -1
    AddToPath_MoveAboveFormation
    AddToPath_JoinFormation
    SetPathType PT_BUTTERFLY_PATH
    AddToPath_LeaveFormation
    AddToPath_Movement 12, 2, 6
    AddToPath_Movement 40, 2, 0
    AddToPath_Movement 46, 2, -2
    AddToPath_Movement 30, 2, 2
    AddToPath_ContinueFlight 2, -2
    AddToPath_MoveAboveFormation
    AddToPath_JoinFormation
    SetPathType PT_BEE_PATH
    AddToPath_LeaveFormation
    AddToPath_Movement 10, 2, 6
    AddToPath_ToHeight 188
    AddToPath_Movement 108, 2, -2
    AddToPath_BeeReturn
    AddToPath_Movement 98, 2, -2
    AddToPath_ContinueFlight 2, 0
    AddToPath_MoveAboveFormation
    AddToPath_JoinFormation
    SetPathType PT_NEW_WAVE_FROM_TOP_SLIGHTLY_OUTWARD
    AddToPath_SetPosition 110, 12, 180
    AddToPath_Movement 18, 2.1623, -3
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 30, 4.6747, 6
    AddToPath_Speed 3
    AddToPath_JoinFormation
    SetPathType PT_NEW_WAVE_FROM_SIDE_SLIGHTLY_HIGHER
    AddToPath_SetPosition 0, 234, 270
    AddToPath_Movement 48, 2.5585, -2
    AddToPath_Movement 48, 1.3252, -6
    AddToPath_Speed 3
    AddToPath_JoinFormation
    SetPathType PT_NEW_AGGRESSIVE_WAVE_FROM_TOP
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 18, 3, -3
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 30, 3, 6
    AddToPath_DiveAtPlayer
    AddToPath_Remove
    SetPathType PT_NEW_AGGRESSIVE_WAVE_FROM_OUTER_TOP
    AddToPath_SetPosition 110, 12, 180
    AddToPath_Movement 18, 2.1623, -3
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 30, 4.6747, 6
    AddToPath_Speed 3
    AddToPath_DiveAtPlayer
    AddToPath_Remove
    SetPathType PT_NEW_AGGRESSIVE_WAVE_FROM_SIDE
    AddToPath_SetPosition 0, 250, 270
    AddToPath_Movement 48, 3, -2
    AddToPath_Movement 48, 3, -6
    AddToPath_DiveAtPlayer
    AddToPath_Remove
    SetPathType PT_NEW_AGGRESSIVE_WAVE_FROM_HIGHER_SIDE
    AddToPath_SetPosition 0, 234, 270
    AddToPath_Movement 48, 2.5585, -2
    AddToPath_Movement 48, 1.3252, -6
    AddToPath_Speed 3
    AddToPath_DiveAtPlayer
    AddToPath_Remove
    SetPathType PT_UP_AND_DIVE_TO_CAPTURE
    AddToPath_LeaveFormation
    AddToPath_Movement 3, 2, 6
    AddToPath_DiveToBeam
    AddToPath_ContinueFlight 3, 0
    AddToPath_MoveAboveFormation
    AddToPath_JoinFormation
    SetPathType PT_RETURN_WITH_CAPTURED
    AddToPath_Movement 30, 2, 6
    AddToPath_JoinFormation
    SetPathType PT_WAIT_FOR_CAPTURE
    AddToPath_WaitForCapture
    SetPathType PT_TAKE_HOSTAGE_POSITION
    AddToPath_TakeHostagePosition
    SetPathType PT_RESCUED_PLAYER
    AddToPath_DoubleUpPlayer
    SetPathType PT_PLAYER_SWOOP
    AddToPath_LeaveFormation
    AddToPath_Movement 3, 2, 6
    AddToPath_Movement 48, 2, 0
    AddToPath_Movement 63, 2, 6
    AddToPath_Movement 36, 2, 0
    AddToPath_ContinueFlight 2, -1
    AddToPath_PlayerInStorage
    SetPathType PT_CHALLENGE1A
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 24, 3, 0
    AddToPath_Movement 3, 3, -8
    AddToPath_Movement 48, 3, 0
    AddToPath_Movement 38, 3, -6
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE1B
    AddToPath_SetPosition 0, 250, 270
    AddToPath_Movement 54, 3, -1
    AddToPath_Movement 4, 3, -9
    AddToPath_Movement 20, 3, 0
    AddToPath_Movement 20, 3, -9
    AddToPath_Movement 20, 3, 0
    AddToPath_Movement 16, 3, -9
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE2A
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 24, 3, 0
    AddToPath_Movement 3, 3, -8
    AddToPath_Movement 20, 3, 0
    AddToPath_Movement 30, 0, -6
    AddToPath_Movement 20, 3, 0
    AddToPath_Movement 3, 3, 8
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE2B
    AddToPath_SetPosition 0, 248, 270
    AddToPath_Movement 36, 3, 0
    AddToPath_Movement 180, 3, -2
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE3A
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 34, 3, 0
    AddToPath_Movement 6, 3, -8
    AddToPath_Movement 36, 3, 0
    AddToPath_Movement 30, 0, -6
    AddToPath_Movement 37, 3, 0
    AddToPath_Movement 6, 3, 8
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE3B
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 34, 3, 0
    AddToPath_Movement 6, 3, 8
    AddToPath_Movement 36, 3, 0
    AddToPath_Movement 30, 0, -6
    AddToPath_Movement 37, 3, 0
    AddToPath_Movement 6, 3, -8
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE3C
    AddToPath_SetPosition 0, 250, 270
    AddToPath_Movement 25, 3, 0
    AddToPath_Movement 18, 0, 10
    AddToPath_Movement 30, 3, 3
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 30, 3, 3
    AddToPath_Movement 12, 3, 7.5
    AddToPath_Movement 30, 3, 0
    AddToPath_Movement 15, 0, -6
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE4A
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 6, 3, 0
    AddToPath_Movement 10, 0, 9
    AddToPath_Movement 36, 3, -5
    AddToPath_Movement 36, 3, 5
    AddToPath_Movement 72, 3, -5
    AddToPath_Movement 36, 3, 5
    AddToPath_Movement 36, 3, -5
    AddToPath_Movement 10, 0, 9
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE4B
    AddToPath_SetPosition 94, 12, 180
    AddToPath_Movement 6, 3, 0
    AddToPath_Movement 10, 0, -9
    AddToPath_Movement 36, 3, 5
    AddToPath_Movement 36, 3, -5
    AddToPath_Movement 72, 3, 5
    AddToPath_Movement 36, 3, -5
    AddToPath_Movement 36, 3, 5
    AddToPath_Movement 10, 0, -9
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
    SetPathType PT_CHALLENGE4C
    AddToPath_SetPosition 0, 250, 270
    AddToPath_Movement 8, 3, -8
    AddToPath_Movement 36, 3, 0
    AddToPath_Movement 4, 3, 16
    AddToPath_Movement 72, 3, 5
    AddToPath_Movement 12, 3, 0
    AddToPath_Movement 72, 3, 5
    AddToPath_Movement 12, 3, 0
    AddToPath_Movement 72, 3, 5
    AddToPath_Movement 12, 3, 0
    AddToPath_Movement 8, 3, 8
    AddToPath_ContinueFlight 3, 0
    AddToPath_Remove
END SUB

SUB SetPathType (pathType%)
    pathDataOffset%(pathType%) = pathDataIndex%
END SUB

SUB AddPathDataElement (d!)
    pathData!(pathDataIndex%) = d!
    pathDataIndex% = pathDataIndex% + 1
END SUB

SUB AddToPath_SetPosition (x!, y!, angle!)
    AddPathDataElement CMD_SET_POSITION
    AddPathDataElement x!
    AddPathDataElement y!
    AddPathDataElement angle!
END SUB

SUB AddToPath_Movement (frames!, deltaMove!, deltaAngle!)
    AddPathDataElement CMD_MOVEMENT
    AddPathDataElement frames!
    AddPathDataElement deltaMove!
    AddPathDataElement deltaAngle!
END SUB

SUB AddToPath_JoinFormation
    AddPathDataElement CMD_JOIN_FORMATION
END SUB

SUB AddToPath_LeaveFormation
    AddPathDataElement CMD_LEAVE_FORMATION
END SUB

SUB AddToPath_MoveAboveFormation
    AddPathDataElement CMD_MOVE_ABOVE_FORMATION
END SUB

SUB AddToPath_ContinueFlight (deltaMove!, deltaAngle!)
    AddPathDataElement CMD_CONTINUE_FLIGHT
    AddPathDataElement deltaMove!
    AddPathDataElement deltaAngle!
END SUB

SUB AddToPath_ToHeight (tagetHeight!)
    AddPathDataElement CMD_TO_HEIGHT
    AddPathDataElement tagetHeight!
END SUB

SUB AddToPath_BeeReturn
    AddPathDataElement CMD_BEE_RETURN
END SUB

SUB AddToPath_Speed (speed!)
    AddPathDataElement CMD_SPEED
    AddPathDataElement speed!
END SUB

SUB AddToPath_DiveAtPlayer
    AddPathDataElement CMD_DIVE_AT_PLAYER
END SUB

SUB AddToPath_Remove
    AddPathDataElement CMD_REMOVE
END SUB

SUB AddToPath_DiveToBeam
    AddPathDataElement CMD_DIVE_TO_BEAM
END SUB

SUB AddToPath_WaitForCapture
    AddPathDataElement CMD_WAIT_FOR_CAPTURE
END SUB

SUB AddToPath_TakeHostagePosition
    AddPathDataElement CMD_TAKE_HOSTAGE_POSITION
END SUB

SUB AddToPath_DoubleUpPlayer
    AddPathDataElement CMD_DOUBLE_UP_PLAYER
END SUB

SUB AddToPath_PlayerInStorage
    AddPathDataElement CMD_PLAYER_IN_STORAGE
END SUB

'===== Overall management of aliens during game play ==================================================================================================================================================

SUB InitialiseAliensForNewGame
    DIM i%
    waveData.hasCaptive% = FALSE
    waveData.playerInStorage = FALSE
    FOR i% = 0 TO MAX_ALIENS - 1
        alienData(i%).currentAction% = CMD_NONE
        alienData(i%).controlPath% = PT_INACTIVE
    NEXT i%
END SUB

SUB UpdateAlienManager (initialised%)
    IF initialised% = FALSE THEN waveData.state% = WS_INITIALISE_PLAY
    IF game.gameOver% THEN
        game.gameOverCounter% = game.gameOverCounter% - 1
        IF game.gameOverCounter% = 0 THEN
            PrepareBackendEvents
            EXIT SUB
        END IF
    END IF
    SELECT CASE waveData.state%
        CASE WS_INITIALISE_PLAY, WE_SHOW_PRE_GAME_OVERLAYS
            WS_InitialisePlay
        CASE WS_INITIALISE_WAVE
            WS_InitialiseWave
        CASE WS_WAIT_FOR_ATTACK
            WS_WaitForAttack
        CASE WS_PREPARE_BATCH
            WS_PrepareBatch
        CASE WS_BRING_ON_BATCH
            WS_BringOnBatch
        CASE WS_PLAY_STAGE
            WS_PlayStage
        CASE WS_CHALLENGE_RESULTS
            WS_ChallengeResults
        CASE WS_POST_STAGE
            WS_PostStage
        CASE WS_PAUSE
            waveData.pauseCounter% = waveData.pauseCounter% - 1
            IF waveData.pauseCounter% <= 0 THEN waveData.state% = waveData.postPauseState%
    END SELECT
END SUB

SUB WS_InitialisePlay
    IF waveData.state% = WS_INITIALISE_PLAY THEN waveData.substate% = 0: waveData.postPauseState% = WE_SHOW_PRE_GAME_OVERLAYS: waveData.bombCount% = 0
    SELECT CASE waveData.substate%
        CASE 0
            game.gameOver% = FALSE
            player.lives% = 3
            game.extraLife& = 20000
            InitialiseAliensForNewGame
            InitialisePlayer
            InitialiseBullets
            PlaySfx SFX_STAGE_INTRO
            game.stage% = 1
            stars.scroll% = FALSE
            game.score& = 0
            HideOverlays
            PrintText "PLAYER 1", 10, 18, 2
            waveData.pauseCounter = 4 * game.fps%
            waveData.state% = WS_PAUSE
            waveData.substate% = waveData.substate% + 1
        CASE 1
            HideOverlays
            PrintText "STAGE 1", 10, 18, 2
            AddEvent EVENT_PROCESS_FLAGS
            waveData.pauseCounter = 1.6 * game.fps%
            waveData.state% = WS_PAUSE
            waveData.substate% = waveData.substate% + 1
        CASE 2
            stars.scroll% = TRUE
            PrintText "PLAYER 1", 10, 16, 2
            NewLife
            waveData.pauseCounter = 1 * game.fps%
            waveData.state% = WS_PAUSE
            waveData.postPauseState% = WS_INITIALISE_WAVE
    END SELECT
END SUB

SUB WS_InitialiseWave
    DIM quadrant%, i%
    quadrant% = game.stage% / 4
    waveData.simultaneousAttackCount% = Min!(8, 2 + quadrant% / 2)
    waveData.continuousDiverCount% = Max!(30, 39 - (0.75 + quadrant%) / 4)
    waveData.bombAvailability% = Min!(6, 2 + quadrant% / 4)
    waveData.continuousAttack% = FALSE
    waveData.challengingStage% = ((game.stage% - 3) MOD 4) = 0
    waveData.aliensInFormation% = TRUE
    waveData.hitCount% = 0
    FOR i% = 0 TO MAX_ALIENS - 1
        alienData(i%).attackGroup% = -1
    NEXT i%
    waveData.formationCentreX% = 0
    waveData.formationCentreY% = 82
    waveData.formationSpread! = 16
    waveData.formationDirection! = 1
    FOR i% = 0 TO MAX_ATTACKING_FORMATIONS - 1
        numberInAttackingFormation%(i%) = 0
    NEXT i%
    CreateWavePrepare
    waveData.state = WS_WAIT_FOR_ATTACK
END SUB

SUB WS_WaitForAttack
    IF waveData.aliensCanAttack% = FALSE THEN EXIT SUB
    IF waveData.aliensAttackingPauseCounter% > 0 THEN
        waveData.aliensAttackingPauseCounter% = waveData.aliensAttackingPauseCounter% - 1
        IF waveData.aliensAttackingPauseCounter% = 0 THEN
            player.canFire% = TRUE
        END IF
        EXIT SUB
    END IF
    HideOverlays
    waveData.batchCounter% = 5
    waveData.state% = WS_PREPARE_BATCH
END SUB

SUB WS_PrepareBatch
    waveData.aliensArrived% = FALSE
    waveData.aliensInFormation% = TRUE
    IF waveData.aliensCanAttack% = FALSE THEN
        MoveFormation:
        EXIT SUB
    END IF
    IF waveData.aliensAttackingPauseCounter% > 0 THEN
        MoveFormation
        waveData.aliensAttackingPauseCounter% = waveData.aliensAttackingPauseCounter% - 1
        IF waveData.aliensAttackingPauseCounter% = 0 THEN
            player.canFire% = TRUE
        END IF
    ELSE
        IF waveData.challengingStage% = FALSE THEN
            CreateWave
        ELSE
            CreateChallengeWave
        END IF
        waveData.postArrivalPause% = 15
        waveData.state% = WS_BRING_ON_BATCH
    END IF
END SUB

SUB WS_BringOnBatch
    IF waveData.postArrivalPause% > 0 THEN
        MoveFormation
        waveData.aliensArrived% = CheckAllArrived%
        IF waveData.aliensArrived% = TRUE THEN
            waveData.postArrivalPause% = waveData.postArrivalPause% - 1
        END IF
    ELSE
        IF waveData.aliensAttackingPauseCounter% > 0 THEN
            waveData.aliensAttackingPauseCounter% = waveData.aliensAttackingPauseCounter% - 1
            IF waveData.aliensAttackingPauseCounter% = 0 THEN
                player.canFire% = TRUE
                HideOverlays
            END IF
        END IF
        MoveFormation
        waveData.aliensInFormation% = CheckInFormation%
        IF waveData.formationCentreX% = 0 THEN
            waveData.batchCounter% = waveData.batchCounter% - 1
            IF waveData.batchCounter% > 0 THEN
                waveData.state% = WS_PREPARE_BATCH
            ELSE
                IF waveData.challengingStage% = FALSE THEN
                    waveData.aliensCanAttack% = TRUE
                    waveData.formationDirection! = 0.096
                    waveData.stageClear% = FALSE
                    waveData.state% = WS_PLAY_STAGE
                    IF NOT waveData.challengingStage% THEN PlaySfxLooping SFX_AMBIENCE
                ELSE
                    waveData.state% = WS_CHALLENGE_RESULTS
                    waveData.substate% = 0
                END IF
            END IF
        END IF
    END IF
END SUB

SUB WS_PlayStage
    DIM randVal%
    waveData.continuousAttack% = waveData.hitCount% >= waveData.continuousDiverCount% AND waveData.aliensCanAttack% AND waveData.aliensAttackingPauseCounter% = 0
    waveData.formationSpread! = waveData.formationSpread! + waveData.formationDirection!
    IF waveData.formationSpread! <= 16 OR waveData.formationSpread! >= 22 THEN waveData.formationDirection! = -waveData.formationDirection!
    waveData.aliensInFormation% = CheckInFormation%
    IF waveData.aliensCanAttack% = TRUE THEN
        IF waveData.aliensAttackingPauseCounter% > 0 THEN
            waveData.aliensAttackingPauseCounter% = waveData.aliensAttackingPauseCounter% - 1
            IF waveData.aliensAttackingPauseCounter% = 0 THEN
                player.canFire% = TRUE
                HideOverlays
            END IF
        ELSE
            IF CountActiveFormations% < waveData.simultaneousAttackCount THEN
                randVal% = RND * 5
                SELECT CASE randVal%
                    CASE 0: BossFormationSwoop
                    CASE 1: BeeLoopBackupDive
                    CASE 2: ButterflyDiveOffScreen
                    CASE 3: CaptiveSwoop
                    CASE 4: IF waveData.continuousAttack = FALSE THEN BossCaptureDive
                END SELECT
            END IF
        END IF
    END IF
    IF IsStageClear% THEN
        StopSfx SFX_AMBIENCE
        waveData.state% = WS_PAUSE
        waveData.pauseCounter% = game.fps%
        waveData.postPauseState% = WS_POST_STAGE
    END IF
END SUB

SUB WS_ChallengeResults
    SELECT CASE waveData.substate%
        CASE 0
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = game.fps%
            waveData.substate% = 1
            waveData.postPauseState% = WS_CHALLENGE_RESULTS
        CASE 1
            IF waveData.hitCount% = 40 THEN PlaySfx SFX_CHALLENGING_STAGE_PERFECT ELSE PlaySfx SFX_CHALLENGING_STAGE_OVER
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = game.fps%
            waveData.substate% = 2
        CASE 2
            PrintText "NUMBER OF HITS", 5, 18, COLOUR_BLUE
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = game.fps%
            waveData.substate% = 3
        CASE 3
            PrintText LTRIM$(STR$(waveData.hitCount%)), 21, 18, COLOUR_BLUE
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = game.fps%
            IF waveData.hitCount% = 40 THEN waveData.substate% = 4 ELSE waveData.substate% = 11
        CASE 4 TO 9
            IF waveData.substate% MOD 2 = 0 THEN
                PrintText "PERFECT", 10, 16, COLOUR_RED
            ELSE
                PrintText "       ", 10, 16, COLOUR_RED
            END IF
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = 0.2 * game.fps%
            waveData.substate% = waveData.substate% + 1
        CASE 10
            ModifyScoreBy 10000
            PrintText "NUMBER OF HITS", 5, 18, COLOUR_BLUE
            PrintText LTRIM$(STR$(waveData.hitCount%)), 21, 18, COLOUR_BLUE
            PrintText "PERFECT", 10, 16, 1
            PrintText "SPECIAL BONUS 10000 PTS", 2, 20, COLOUR_YELLOW
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = 2 * game.fps%
            waveData.substate% = 13
        CASE 11
            PrintText "BONUS", 8, 20, COLOUR_BLUE
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = 1.2 * game.fps%
            waveData.substate% = 12
        CASE 12
            ModifyScoreBy waveData.hitCount% * 100
            PrintText "NUMBER OF HITS", 5, 18, COLOUR_BLUE
            PrintText LTRIM$(STR$(waveData.hitCount%)), 21, 18, COLOUR_BLUE
            PrintText "BONUS", 8, 20, COLOUR_BLUE
            PrintText LTRIM$(STR$(waveData.hitCount% * 100)), 15, 20, COLOUR_BLUE
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = 2 * game.fps%
            waveData.substate% = 13
        CASE 13
            HideOverlays
            waveData.state% = WS_PAUSE
            waveData.pauseCounter% = 1 * game.fps%
            waveData.substate% = 13
            waveData.postPauseState% = WS_POST_STAGE
    END SELECT
END SUB

SUB WS_PostStage
    IF NOT player.state% = PLAYER_ACTIVE THEN EXIT SUB
    IF waveData.aliensAttackingPauseCounter% > 0 THEN waveData.aliensAttackingPauseCounter% = waveData.aliensAttackingPauseCounter% - 1: EXIT SUB
    player.canFire% = TRUE
    HideOverlays
    game.stage% = game.stage% + 1
    IF ((game.stage - 3) MOD 4) = 0 THEN
        PrintText "CHALLENGING STAGE", 5, 18, 2
        PlaySfx SFX_CHALLENGING_STAGE
    ELSE
        PrintText "STAGE" + STR$(game.stage%), 10, 18, 2
    END IF
    AddEvent EVENT_PROCESS_FLAGS
    waveData.state% = WS_PAUSE
    waveData.pauseCounter% = game.fps% * 2
    waveData.postPauseState% = WS_INITIALISE_WAVE
END SUB

'===== Helper functions for determining alien actions =================================================================================================================================================

FUNCTION IsStageClear% ' Have we completed the level?
    DIM i%
    FOR i% = 0 TO MAX_ALIENS - 1
        IF CheckIsVisible%(alienData(i%)) THEN IsStageClear% = FALSE: EXIT FUNCTION
    NEXT i%
    IsStageClear% = TRUE
END FUNCTION

FUNCTION OutlyingAlien% (alienType%) ' Fine the alien closest to the formation's edge
    DIM maxX!, i%
    OutlyingAlien% = -1
    maxX! = -1
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).alienType% = alienType% THEN
            IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                IF ABS(alienData(i%).formationXOffset!) >= maxX! AND (maxX! = -1 OR RND < 0.5) THEN
                    OutlyingAlien% = i%
                    maxX! = ABS(alienData(i%).formationXOffset!)
                END IF
            END IF
        END IF
    NEXT i%
END FUNCTION

FUNCTION CaptorId% ' Find the boss galaga that has kidnapped the player
    DIM i%
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).isCaptor% THEN CaptorId% = i%: EXIT FUNCTION
    NEXT i%
    CaptorId% = -1
END FUNCTION

FUNCTION CaptiveId% ' Find the captive alien (looks like she player's ship)
    DIM i%
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).isCaptive% THEN CaptiveId% = i%: EXIT FUNCTION
    NEXT i%
    CaptiveId% = -1
END FUNCTION

FUNCTION EmptyAttackFormationIndex% ' Find an unused formation id for an attack
    DIM i%
    FOR i% = 0 TO MAX_ATTACKING_FORMATIONS - 1
        IF numberInAttackingFormation%(i%) = 0 THEN EmptyAttackFormationIndex% = i%: EXIT FUNCTION
    NEXT i%
END FUNCTION

FUNCTION CanShoot% (alien AS ALIENDATA) ' Check whether the player can shoot
    CanShoot% = alien.alienType% <> TYPE_PLAYER AND (alien.isCaptor% = FALSE OR waveData.hasCaptive% = FALSE OR alien.beamActive% = FALSE)
END FUNCTION

FUNCTION CanDoContinuousAttack% (alien AS ALIENDATA) ' Should the aliens be cintinually attacking without pause?
    CanDoContinuousAttack% = alien.continualPath% = PT_UP_AND_DIVE_WITH_BOSS OR alien.continualPath% = PT_BUTTERFLY_PATH OR alien.continualPath% = PT_BEE_PATH
END FUNCTION

FUNCTION OffSide% (x%) ' Are we off the side of the screen?
    OffSide% = ABS(x%) > 112 + 8
END FUNCTION

FUNCTION OffLeft% (x%) ' Are we off the left of the screen?
    OffLeft% = x% < -112 - 8
END FUNCTION

FUNCTION OffRight% (x%) ' Are we off the right of the screen?
    OffRight% = x% > 112 + 8
END FUNCTION

FUNCTION OffTop% (y%) ' Are we off the top of the screen?
    OffTop% = y% > 108 + 8
END FUNCTION

FUNCTION OffBottom% (y%) ' Are we off the bottom of the screen?
    OffBottom% = y% < -180 - 8
END FUNCTION

FUNCTION CheckInFormation% ' Check if all aliens are in their formation (i.e. with nobody attacking or diving)
    DIM i%
    CheckInFormation% = FALSE
    FOR i% = 0 TO MAX_ALIENS - 1
        IF CheckIsVisible(alienData(i%)) = TRUE AND NOT (alienData(i%).currentAction% = CMD_DOUBLE_UP_PLAYER OR alienData(i%).currentAction% = CMD_HOLD_FORMATION) THEN EXIT FUNCTION
    NEXT i%
    CheckInFormation% = TRUE
END FUNCTION

FUNCTION CheckAllArrived% ' Check if all aliens have arrived
    DIM i%
    CheckAllArrived% = FALSE
    FOR i% = 0 TO MAX_ALIENS - 1
        IF (CheckIsVisible(alienData(i%)) = TRUE OR alienData(i%).currentAction% = CMD_INACTIVE) AND (alienData(i%).currentAction% <> CMD_HOLD_FORMATION) THEN
            EXIT FUNCTION
        END IF
    NEXT i%
    CheckAllArrived% = TRUE
END FUNCTION

FUNCTION CheckIsVisible% (alien AS ALIENDATA) ' Check if an alien is currently visible
    CheckIsVisible% = NOT (alien.currentAction% = CMD_WAIT_FOR_CAPTURE OR alien.currentAction% = CMD_DEAD OR alien.currentAction% = CMD_DESTROYED OR alien.currentAction% = CMD_INACTIVE OR alien.currentAction% = CMD_PLAYER_IN_STORAGE OR alien.currentAction% = CMD_REMOVE OR alien.controlPath% = PT_INACTIVE OR alien.controlPath% = PT_WAITING OR alien.pathDelay% > 0)
END FUNCTION

FUNCTION CountActiveFormations% ' See how many groups of aliens are attacking
    DIM i%, c%
    c% = 0
    FOR i% = 0 TO MAX_ATTACKING_FORMATIONS - 1
        IF numberInAttackingFormation%(i%) > 0 THEN c% = c% + 1
    NEXT i%
    CountActiveFormations% = c%
END FUNCTION

SUB SetPathTypeForAlien (alien AS ALIENDATA, pathName%, delay%, direction%)
    alien.pathDelay% = delay%
    alien.controlPath% = pathName%
    alien.direction% = direction%
    alien.continualPath% = pathName%
END SUB

SUB AddToAttackingGroup (alien AS ALIENDATA, attackingGroup%)
    alien.attackGroup% = attackingGroup%
    numberInAttackingFormation%(attackingGroup%) = numberInAttackingFormation%(attackingGroup%) + 1
END SUB

SUB RemoveFromAttackGroup (alien AS ALIENDATA)
    IF alien.attackGroup% > -1 THEN
        numberInAttackingFormation%(alien.attackGroup%) = numberInAttackingFormation%(alien.attackGroup%) - 1
        alien.attackGroup% = -1
    END IF
END SUB

SUB CheckForBatchOfEight (alien AS ALIENDATA) ' Player scores bonuses for hitting batches of oncoming aliens during challenge stages
    DIM i%, challengeNum%
    FOR i% = alien.batchNum% * 8 TO alien.batchNum% * 8 + 7
        IF alienData(i%).currentAction% <> CMD_DEAD AND alienData(i%).currentAction% <> CMD_DESTROYED THEN EXIT SUB
    NEXT i%
    challengeNum% = Min!(INT(INT((game.stage% - 3) / 4) / 2), 3)
    alien.scoreCostume% = 4 + challengeNum%
    SELECT CASE challengeNum%
        CASE 0
            ModifyScoreBy 1000
        CASE 1
            ModifyScoreBy 1500
        CASE 2
            ModifyScoreBy 2000
        CASE 3
            ModifyScoreBy 3000
    END SELECT
END SUB

'===== Set a boss galaga into a dive - he can take captured ships and/or adjacent aliens with him =====================================================================================================

SUB BossFormationSwoop
    DIM bossIndex%, i%, bossCompany%, captive%
    bossIndex% = -1
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).alienType% = TYPE_BOSS_GALAGA OR alienData(i%).alienType% = TYPE_BOSS_GALAGA_SHOT THEN
            IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                IF bossIndex% = -1 OR RND < 0.5 THEN bossIndex% = i%
            END IF
        END IF
    NEXT i%
    IF bossIndex% = -1 THEN EXIT SUB
    PlaySfx SFX_GALAGA_ATTACK
    SetPathTypeForAlien alienData(bossIndex%), PT_UP_AND_DIVE_WITH_BOSS, 0, (alienData(bossIndex%).formationXOffset! > 0) * -2 - 1
    AddToAttackingGroup alienData(bossIndex%), EmptyAttackFormationIndex%
    IF waveData.hasCaptive% THEN
        IF alienData(bossIndex%).isCaptor% AND alienData(CaptiveId%).currentAction% = CMD_HOLD_FORMATION THEN
            captive% = CaptiveId%
            SetPathTypeForAlien alienData(captive%), PT_UP_AND_DIVE_WITH_BOSS, 0, (alienData(captive%).formationXOffset! > 0) * -2 - 1
            AddToAttackingGroup alienData(captive%), EmptyAttackFormationIndex%
        END IF
    END IF
    bossCompany% = -1
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).alienType% = TYPE_BUTTERFLY THEN
            IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                IF alienData(i%).formationXOffset! = alienData(bossIndex%).formationXOffset! AND alienData(i%).formationYOffset! = alienData(bossIndex%).formationYOffset! + 1 THEN bossCompany% = i%: EXIT FOR
            END IF
        END IF
    NEXT i%
    IF bossCompany% <> -1 THEN
        SetPathTypeForAlien alienData(bossCompany%), PT_UP_AND_DIVE_WITH_BOSS, 0, (alienData(bossCompany%).formationXOffset! > 0) * -2 - 1
        AddToAttackingGroup alienData(bossCompany%), EmptyAttackFormationIndex%
        bossCompany% = -1
        FOR i% = 0 TO MAX_ALIENS - 1
            IF alienData(i%).alienType% = TYPE_BUTTERFLY THEN
                IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                    IF ABS(alienData(i%).formationXOffset! - alienData(bossIndex%).formationXOffset!) = 1 AND alienData(i%).formationYOffset! = alienData(bossIndex%).formationYOffset! + 1 AND (bossCompany% = -1 OR RND < 0.5) THEN bossCompany% = i%
                END IF
            END IF
        NEXT i%
        IF bossCompany% <> -1 THEN
            SetPathTypeForAlien alienData(bossCompany%), PT_UP_AND_DIVE_WITH_BOSS, 0, (alienData(bossCompany%).formationXOffset! > 0) * -2 - 1
            AddToAttackingGroup alienData(bossCompany%), EmptyAttackFormationIndex%
        END IF
    ELSE
        FOR i% = 0 TO MAX_ALIENS - 1
            IF alienData(i%).alienType% = TYPE_BUTTERFLY THEN
                IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                    IF ABS(alienData(i%).formationXOffset! - alienData(bossIndex%).formationXOffset!) = 1 AND alienData(i%).formationYOffset! = alienData(bossIndex%).formationYOffset! + 1 THEN
                        SetPathTypeForAlien alienData(i%), PT_UP_AND_DIVE_WITH_BOSS, 0, (alienData(i%).formationXOffset! > 0) * -2 - 1
                        AddToAttackingGroup alienData(i%), EmptyAttackFormationIndex%
                    END IF
                END IF
            END IF
        NEXT i%
    END IF
END SUB

'===== Start a bee alien attack (possibly in a group) =================================================================================================================================================

SUB BeeLoopBackupDive
    DIM targetIndex%
    targetIndex% = OutlyingAlien%(TYPE_BEE)
    IF targetIndex% <> -1 THEN
        PlaySfx SFX_GALAGA_ATTACK
        SetPathTypeForAlien alienData(targetIndex%), PT_BEE_PATH, 0, (alienData(targetIndex%).formationXOffset! > 0) * -2 - 1
        AddToAttackingGroup alienData(targetIndex%), EmptyAttackFormationIndex%
    END IF
END SUB

'===== Start a butterfly alien attack (possibly in a group) ===========================================================================================================================================

SUB ButterflyDiveOffScreen
    DIM targetIndex%
    targetIndex% = OutlyingAlien%(TYPE_BUTTERFLY)
    IF targetIndex% <> -1 THEN
        PlaySfx SFX_GALAGA_ATTACK
        SetPathTypeForAlien alienData(targetIndex%), PT_BUTTERFLY_PATH, 0, (alienData(targetIndex%).formationXOffset! > 0) * -2 - 1
        AddToAttackingGroup alienData(targetIndex%), EmptyAttackFormationIndex%
    END IF
END SUB

'===== A captured ship can swoop down on its own if its captor has been destroyed while in formation ==================================================================================================

SUB CaptiveSwoop
    IF waveData.hasCaptive% = TRUE THEN
        IF alienData(CaptorId%).currentAction% = CMD_DESTROYED THEN
            IF alienData(CaptiveId%).currentAction% = CMD_HOLD_FORMATION THEN
                SetPathTypeForAlien alienData(CaptiveId%), PT_PLAYER_SWOOP, 0, (alienData(CaptiveId%).formationXOffset! > 0) * -2 - 1
                AddToAttackingGroup alienData(CaptiveId%), EmptyAttackFormationIndex%
            END IF
        END IF
    END IF
END SUB

'===== Start a boss galaga swooping down to fire his capture beam =====================================================================================================================================

SUB BossCaptureDive
    DIM bossIndex%, i%
    IF waveData.hasCaptive% = FALSE AND player.doubleShip% = FALSE THEN
        bossIndex% = -1
        FOR i% = 0 TO MAX_ALIENS - 1
            IF alienData(i%).alienType% = TYPE_BOSS_GALAGA OR alienData(i%).alienType% = TYPE_BOSS_GALAGA_SHOT THEN
                IF alienData(i%).continualPath% = PT_UP_AND_DIVE_TO_CAPTURE AND alienData(i%).currentAction% <> CMD_DESTROYED THEN EXIT SUB
                IF alienData(i%).currentAction% = CMD_HOLD_FORMATION THEN
                    IF bossIndex% = -1 OR RND < 0.5 THEN bossIndex% = i%
                END IF
            END IF
        NEXT i%
        IF bossIndex% = -1 THEN EXIT SUB
        PlaySfx SFX_GALAGA_ATTACK
        SetPathTypeForAlien alienData(bossIndex%), PT_UP_AND_DIVE_TO_CAPTURE, 0, (alienData(bossIndex%).formationXOffset! > 0) * -2 - 1
        AddToAttackingGroup alienData(bossIndex%), EmptyAttackFormationIndex%
    END IF
END SUB

'===== Check for collisions against player or bullets =================================================================================================================================================

SUB CheckAgainstBullets (alien AS ALIENDATA)
    DIM i%
    IF CanShoot%(alien) = FALSE THEN EXIT SUB
    FOR i% = 0 TO MAX_BULLETS - 1
        IF bullet(i%).state% = BULLET_ACTIVE THEN
            IF ABS(alien.xPos! - bullet(i%).xPos%) < 7 AND ABS(alien.yPos! - bullet(i%).yPos%) < 10 THEN
                bullet(i%).state% = BULLET_REMOVING
                HitAlien alien
            END IF
        END IF
    NEXT i%
END SUB

SUB CheckAgainstCollisions (alien AS ALIENDATA)
    DIM i%
    IF alien.alienType% = TYPE_PLAYER THEN EXIT SUB
    IF ABS(alien.yPos! - player.yPos%) < 14 THEN
        FOR i% = 0 TO 1
            IF ABS(alien.xPos! - ship(i%).xPos%) < 14 AND ship(i%).state% = SHIP_ACTIVE AND NOT ship(i%).isHit% THEN
                ship(i%).isHit% = TRUE
                HitAlien alien
            END IF
        NEXT i%
    END IF
END SUB

'===== Functions supporting score modification and display ============================================================================================================================================

SUB ModifyScoreBy (score%)
    IF game.score& < game.extraLife& AND game.score& + score% >= game.extraLife& THEN
        PlaySfx SFX_1_UP
        player.lives% = player.lives% + 1
        IF game.extraLife& = 20000 THEN game.extraLife& = 70000 ELSE game.extraLife& = game.extraLife& + 70000
    END IF
    game.score& = game.score& + score%
    IF game.score& > game.hiscore& THEN
        game.hiscore& = game.score&
    END IF
    HideOverlays
END SUB

SUB ShowScoreAndHiscore
    ShowScore
    ShowHiscore
END SUB

SUB ShowScore
    DIM score$
    score$ = LTRIM$(STR$(game.score&))
    PrintText score$, 6 - LEN(score$), 1, COLOUR_WHITE
END SUB

SUB ShowHiscore
    DIM score$
    score$ = LTRIM$(STR$(game.hiscore&))
    PrintText score$, 17 - LEN(score$), 1, COLOUR_WHITE
END SUB

'===== An alien has been hit so determine the outcome =================================================================================================================================================

SUB HitAlien (alien AS ALIENDATA)
    DIM i%
    alien.scoreCostume% = -1
    IF alien.alienType% = TYPE_BOSS_GALAGA THEN
        PlaySfx SFX_BOSS_GALAGA_HIT
        alien.alienType = TYPE_BOSS_GALAGA_SHOT
    ELSE
        SELECT CASE alien.alienType%
            CASE TYPE_BOSS_GALAGA_SHOT
                PlaySfx SFX_BOSS_GALAGA_DEFEAT
                alien.scoreCostume% = 0
                IF alien.currentAction% <> CMD_HOLD_FORMATION THEN
                    IF alien.attackGroup% = -1 THEN
                        alien.scoreCostume% = 1
                    ELSE
                        FOR i% = 0 TO MAX_ALIENS - 1
                            IF alienData(i%).attackGroup% = alien.attackGroup% THEN alien.scoreCostume% = alien.scoreCostume% + 1
                        NEXT i%
                    END IF
                    ModifyScoreBy bossScores%(alien.scoreCostume%)
                END IF
                IF waveData.hasCaptive% AND alien.isCaptor% AND alien.currentAction% <> CMD_HOLD_FORMATION AND alien.controlPath% <> PT_WAITING THEN
                    player.state% = PLAYER_WAITING_TO_DOUBLE
                    SetPathTypeForAlien alienData(CaptiveId%), PT_RESCUED_PLAYER, 0, 0
                END IF
                IF alien.beamActive% = TRUE THEN BeamCollapse
            CASE TYPE_BUTTERFLY
                PlaySfx SFX_GALAGA_DEFEAT_2
                IF alien.currentAction% = CMD_HOLD_FORMATION THEN
                    ModifyScoreBy 80
                ELSE
                    ModifyScoreBy 160
                END IF
            CASE TYPE_BEE
                PlaySfx SFX_GALAGA_DEFEAT_2
                IF alien.currentAction% = CMD_HOLD_FORMATION THEN
                    ModifyScoreBy 50
                ELSE
                    ModifyScoreBy 100
                END IF
            CASE TYPE_PLAYER_CAPTURED
                PlaySfx SFX_CAPTURED_FIGHTER_DESTROYED
                ResetCaptive
                ModifyScoreBy (1000)
            CASE ELSE
                'TODO Haven't catered for transforms yet so we're only dealing with other types as part of challenge stages
                PlaySfx SFX_GALAGA_DEFEAT_2
                ModifyScoreBy (200)
        END SELECT
        alien.currentAction% = CMD_DEAD
        IF waveData.challengingStage% THEN CheckForBatchOfEight alien
        waveData.hitCount% = waveData.hitCount% + 1
        RemoveFromAttackGroup alien
    END IF
END SUB

SUB ResetCaptive ' If a captured ship is no longer captured then we have some things to reset
    DIM i%
    i% = CaptiveId%
    IF i% > -1 THEN alienData(i%).isCaptive% = FALSE
    i% = CaptorId%
    IF i% > -1 THEN alienData(i%).isCaptor% = FALSE: alienData(i%).beamActive% = FALSE
    waveData.hasCaptive% = FALSE
END SUB

'===== Individual alien management - following the commands on the alien's path =======================================================================================================================

SUB UpdateAliens (initialised%)
    DIM i%, j%
    FOR i% = 0 TO MAX_ALIENS - 1
        IF alienData(i%).currentAction% <> CMD_DESTROYED THEN
            IF alienData(i%).controlPath% <> PT_WAITING AND alienData(i%).controlPath% <> PT_INACTIVE THEN
                IF alienData(i%).currentAction% <> CMD_DEAD THEN
                    FOR j% = 1 TO 60 / game.fps% ' Alien movement is defined at 60fps (so double for 30fps for example)
                        UpdatePosition alienData(i%)
                    NEXT j%
                    IF CheckIsVisible%(alienData(i%)) THEN
                        CheckAgainstBullets alienData(i%)
                        CheckAgainstCollisions alienData(i%)
                    END IF
                    IF alienData(i%).currentAction% = CMD_REMOVE THEN
                        alienData(i%).currentAction% = CMD_DESTROYED
                    ELSE
                        IF alienData(i%).currentAction% = CMD_DEAD THEN
                            IF alienData(i%).alienType% = TYPE_PLAYER_CAPTURED THEN
                                SetPathTypeForAlien alienData(i%), PT_WAIT_FOR_CAPTURE, 0, 1
                                RemoveFromAttackGroup alienData(i%)
                                SpawnAnimation SPAWN_EXPLOSION, alienData(i%)
                                IF alienData(i%).scoreCostume% > -1 THEN SpawnAnimation SPAWN_SCORE, alienData(i%)
                                alienData(i%).currentAction% = CMD_NONE
                            END IF
                            alienData(i%).rotation! = 0
                            alienData(i%).explosionCounter% = 0
                        END IF
                    END IF
                ELSE
                    IF alienData(i%).explosionCounter% < 9 THEN
                        alienData(i%).explosionCounter% = alienData(i%).explosionCounter% + 1
                    ELSE
                        IF alienData(i%).scoreCostume% > -1 THEN SpawnAnimation SPAWN_SCORE, alienData(i%)
                        alienData(i%).currentAction% = CMD_DESTROYED
                    END IF
                END IF
            END IF
        END IF
    NEXT i%
END SUB

SUB UpdatePosition (alien AS ALIENDATA)
    ' Pull any data into local alien structure if starting a new control path
    IF alien.controlPath% <> PT_NONE THEN
        alien.pathIndex% = pathDataOffset%(alien.controlPath%)
        alien.currentAction% = PT_INACTIVE
        alien.fetchNewAction% = TRUE
        alien.controlPath% = PT_NONE
    END IF
    ' Wait for any initial delay to time out before commencing a new control path
    IF alien.pathDelay% > 0 THEN
        alien.pathDelay% = alien.pathDelay% - 1
        IF alien.pathDelay% = 0 THEN
            alien.bombCount% = 0
            IF waveData.bombAvailability% > 0 AND RND < 0.33 THEN alien.bombCount% = 1
        END IF
        EXIT SUB
    END IF
    alien.pathDelay% = -1
    ' Grab a new command from the control path whenever necessary
    DO UNTIL alien.fetchNewAction% = FALSE
        alien.currentAction% = pathData!(alien.pathIndex%)
        alien.pathIndex% = alien.pathIndex% + 1
        alien.fetchNewAction% = FALSE
        SetNewCommand alien
    LOOP
    ' Act out the current path command
    SELECT CASE alien.currentAction%
        CASE CMD_MOVEMENT: DoMovement alien
        CASE CMD_JOIN_FORMATION: DoJoinFormation alien
        CASE CMD_HOLD_FORMATION: DoHoldFormation alien
        CASE CMD_CONTINUE_FLIGHT: DoContinueFlight alien
        CASE CMD_MOVE_ABOVE_FORMATION: DoMoveAboveFormation alien
        CASE CMD_TO_HEIGHT: DoToHeight alien
        CASE CMD_DIVE_TO_BEAM: DoDiveToBeam alien
        CASE CMD_FIRE_BEAM: DoFireBeam alien
        CASE CMD_WAIT_FOR_CAPTURE: DoWaitForCapture alien
        CASE CMD_TAKE_HOSTAGE_POSITION: DoTakeHostagePosition alien
        CASE CMD_DOUBLE_UP_PLAYER: DoDoubleUpPlayer alien
        CASE CMD_DIVE_AT_PLAYER: DoDiveAtPlayer alien
    END SELECT
END SUB

'===== When an alien starts a new command, various parameters need initialising =======================================================================================================================

SUB SetNewCommand (alien AS ALIENDATA)
    SELECT CASE alien.currentAction%
        CASE CMD_SET_POSITION:
            alien.xPos! = (pathData!(alien.pathIndex%) - 112) * alien.direction%
            alien.yPos! = 108 - pathData!(alien.pathIndex% + 1)
            alien.rotation! = 180 + (180 - pathData!(alien.pathIndex% + 2)) * alien.direction%
            alien.pathIndex% = alien.pathIndex% + 3
            alien.fetchNewAction% = TRUE
        CASE CMD_MOVEMENT:
            alien.steps% = pathData!(alien.pathIndex%)
            alien.deltaMove! = pathData!(alien.pathIndex% + 1)
            alien.deltaTurn! = pathData!(alien.pathIndex% + 2) * alien.direction%
            alien.pathIndex% = alien.pathIndex% + 3
        CASE CMD_CONTINUE_FLIGHT:
            alien.deltaMove! = pathData!(alien.pathIndex%)
            alien.deltaTurn! = pathData!(alien.pathIndex% + 1) * alien.direction%
            alien.pathIndex% = alien.pathIndex% + 2
        CASE CMD_TO_HEIGHT:
            alien.targetHeight% = 108 - pathData!(alien.pathIndex%)
            alien.pathIndex% = alien.pathIndex% + 1
        CASE CMD_WAIT_FOR_CAPTURE:
        CASE CMD_PAUSE_ATTACK:
            waveData.aliensAttackingPauseCounter% = pathData!(alien.pathIndex%)
            alien.pathIndex% = alien.pathIndex% + 1
            alien.fetchNewAction% = TRUE
        CASE CMD_DOUBLE_UP_PLAYER:
            player.state% = PLAYER_WAITING_TO_DOUBLE
            waveData.aliensCanAttack% = FALSE
            alien.doubleUpCounter% = 40
            alien.alienType% = TYPE_PLAYER
            SetCostumeWithOffset alien, 0
            PlaySfx SFX_FIGHTER_RESCUED
        CASE CMD_PLAYER_IN_STORAGE:
            waveData.playerInStorage% = TRUE
        CASE CMD_LEAVE_FORMATION:
            IF waveData.continuousAttack% = FALSE OR alien.rotation! = 0 THEN
                alien.steps% = 30
                alien.deltaMove! = 2
                alien.deltaTurn! = 6 * alien.direction%
                alien.currentAction% = CMD_MOVEMENT
            ELSE
                alien.fetchNewAction% = TRUE
            END IF
        CASE CMD_BEE_RETURN:
            IF waveData.continuousAttack% = FALSE THEN
                alien.currentAction% = CMD_JOIN_FORMATION
            ELSE
                alien.fetchNewAction% = TRUE
            END IF
        CASE CMD_SPEED:
            alien.deltaMove! = pathData!(alien.pathIndex%)
            alien.pathIndex% = alien.pathIndex% + 1
            alien.fetchNewAction% = TRUE
        CASE CMD_DIVE_AT_PLAYER:
            alien.targetX! = player.xPos% + ((ship(2).state% = SHIP_ACTIVE) - (ship(1).state% = SHIP_ACTIVE)) * 8
            alien.targetY! = player.yPos%
            alien.targetX! = alien.targetX! + (alien.targetX! - alien.xPos!)
            alien.targetY! = alien.targetY! + (alien.targetY! - alien.yPos!)
    END SELECT
END SUB

'===== Perform the actions ============================================================================================================================================================================

SUB DoMovement (alien AS ALIENDATA) ' Moves a number of steps with delta movement and rotation
    DropBombs alien
    SetCostumeWithTime alien
    Move alien, alien.deltaMove!
    alien.rotation! = alien.rotation! + alien.deltaTurn!
    alien.steps% = alien.steps% - 1
    IF alien.steps% = 0 THEN alien.fetchNewAction% = TRUE
END SUB

'===== Rejoin the formation at the top of the screen ==================================================================================================================================================

SUB DoJoinFormation (alien AS ALIENDATA)
    DIM targetX!, targetY!, deltaX!, deltaY!
    DropBombs alien
    GetFormationPosition alien, targetX!, targetY!
    SetCostumeWithTime alien
    deltaX! = targetX! - alien.xPos!
    deltaY! = targetY! - alien.yPos!
    IF deltaX! ^ 2 + deltaY! ^ 2 > 9 THEN
        TurnTowardsDelta alien, deltaX!, deltaY!, 18
        Move alien, alien.deltaMove!
    ELSE
        alien.xPos! = alien.xPos! + deltaX!
        alien.yPos! = alien.yPos! + deltaY!

        IF waveData.continuousAttack% = FALSE THEN
            IF ABS(ValidateAngle!(alien.rotation!)) < 6 THEN
                alien.bombCount% = waveData.bombAvailability%
                alien.rotation! = 0
                alien.currentAction% = CMD_HOLD_FORMATION
                RemoveFromAttackGroup alien
            ELSE
                alien.rotation! = alien.rotation! + (alien.rotation! < 0) * -12 - 6
            END IF
        ELSE
            IF CanDoContinuousAttack%(alien) THEN
                alien.bombCount% = waveData.bombAvailability%
                alien.rotation! = 180
                SetPathTypeForAlien alien, alien.continualPath%, 0, alien.direction%
                PlaySfx SFX_GALAGA_ATTACK
            ELSE
                IF ABS(alien.rotation!) < 6 THEN
                    alien.bombCount% = waveData.bombAvailability%
                    alien.rotation! = 0
                    alien.currentAction% = CMD_HOLD_FORMATION
                    RemoveFromAttackGroup alien
                ELSE
                    alien.rotation! = alien.rotation! + (alien.rotation! < 0) * -12 + 6
                END IF
            END IF
        END IF
    END IF
END SUB

'===== Stay in the formation at the top of the screen =================================================================================================================================================

SUB DoHoldFormation (alien AS ALIENDATA)
    GetFormationPosition alien, alien.xPos!, alien.yPos!
    alien.continualPath% = PT_NONE
    SetCostumeWithTime alien
END SUB

'===== Continue flying at the current speed and direction =============================================================================================================================================

SUB DoContinueFlight (alien AS ALIENDATA)
    DropBombs alien
    Move alien, alien.deltaMove!
    alien.rotation! = alien.rotation! + alien.deltaTurn!
    SetCostumeWithTime alien
    IF OffSide%(alien.xPos!) OR OffBottom%(alien.yPos!) OR OffTop%(alien.yPos!) THEN alien.fetchNewAction% = TRUE
END SUB

'===== Move above the formation - probably after dropping off the bottom of the screen ================================================================================================================

SUB DoMoveAboveFormation (alien AS ALIENDATA)
    DIM x!, y!
    GetFormationPosition alien, x!, y!
    alien.rotation! = 180
    alien.xPos! = x!
    alien.yPos! = 96
    alien.fetchNewAction% = TRUE
END SUB

'===== Continue with current speed and direction until reaching a target height =======================================================================================================================

SUB DoToHeight (alien AS ALIENDATA)
    DIM y!
    DropBombs alien
    SetCostumeWithTime alien
    y! = alien.yPos!
    Move alien, alien.deltaMove!
    IF (y! - alien.targetHeight%) * (alien.yPos! - alien.targetHeight%) <= 0 THEN
        alien.fetchNewAction% = TRUE
    END IF
END SUB

'===== Dive down to a position where the capture beam can be fired ====================================================================================================================================

SUB DoDiveToBeam (alien AS ALIENDATA)
    IF alien.yPos! >= -70 THEN
        Move alien, 2
        SetCostumeWithTime alien
    ELSE
        alien.beamActive% = TRUE
        alien.yPos! = -70
        alien.pauseCounter% = 0
        alien.currentAction% = CMD_FIRE_BEAM
        alien.isCaptor = TRUE
        alien.rotation! = 180
        SetCostumeWithOffset alien, 0
        player.state% = PLAYER_ACTIVE
        alien.captureCounter% = 0
        PlaySfx SFX_BOSS_GALAGA_TRACTOR_BEAM
    END IF
END SUB

'===== Fire the capture beam ==========================================================================================================================================================================

SUB DoFireBeam (alien AS ALIENDATA)
    DIM sections%
    IF alien.beamActive% = TRUE THEN
        IF alien.captureCounter < 18 * 6 THEN sections% = INT(alien.captureCounter% / 12) ELSE sections% = 8 - INT(alien.captureCounter% - 18 * 6) / 12
        IF sections% = 8 AND player.state% <> PLAYER_CAPTURING AND ABS(player.xPos% + ((ship(0).state% = SHIP_ACTIVE) * 8 - (ship(1).state% = SHIP_ACTIVE) * 8) - alien.xPos!) < 24 AND (ship(0).state% = SHIP_ACTIVE OR ship(1).state% = SHIP_ACTIVE) THEN
            StopSfx SFX_BOSS_GALAGA_TRACTOR_BEAM
            PlaySfx SFX_TRACTOR_BEAM_CAUGHT
            player.state% = PLAYER_CAPTURING
        END IF

        alien.captureCounter% = alien.captureCounter% + 1
        IF alien.captureCounter% = 36 * 6 THEN
            alien.beamActive% = FALSE
        END IF

    ELSE
        IF player.state% = PLAYER_CAPTURING THEN
            IF alien.pauseCounter% = 0 THEN
                PlaySfx SFX_FIGHTER_CAPTURED
                PrintText "FIGHTER CAPTURED", 6, 19, COLOUR_RED
                waveData.aliensCanAttack% = FALSE
            ELSE
                IF alien.pauseCounter% = 120 THEN
                    HideOverlays
                    SetPathTypeForAlien alien, PT_RETURN_WITH_CAPTURED, 0, alien.direction%

                END IF
            END IF
            alien.pauseCounter% = alien.pauseCounter% + 1
        ELSE
            alien.rotation! = 180
            alien.fetchNewAction% = TRUE
            ResetCaptive
        END IF
    END IF
END SUB

SUB BeamCollapse ' If the alien firing the beam is detroyed (or for a few other reasons) we can remove the beam here
    ResetCaptive
    player.state% = PLAYER_ACTIVE
    StopSfx SFX_BOSS_GALAGA_TRACTOR_BEAM
END SUB

'===== The dummy invisible player ship sits in this state until the player is captured (at which point it takes its place) ============================================================================

SUB DoWaitForCapture (alien AS ALIENDATA)
    DIM deltaX!, deltaY!, temp!
    IF NOT waveData.hasCaptive% AND player.state% = PLAYER_CAPTURING THEN
        waveData.hasCaptive% = TRUE
        alien.isCaptive% = TRUE
        alien.xPos! = player.xPos% - 8 - 16 * (ship(2).state% = SHIP_ACTIVE)
        alien.yPos! = player.yPos%
        alien.rotation! = 0
        alien.alienType% = TYPE_PLAYER
        SetCostumeWithOffset alien, 0
    ELSE
        IF waveData.hasCaptive% THEN
            IF alienData(CaptorId%).beamActive% THEN
                deltaX! = alienData(CaptorId%).xPos! - alien.xPos!
                deltaY! = -86 - alien.yPos!
                temp! = alien.rotation!
                IF deltaX! ^ 2 + deltaY! ^ 2 > 2 THEN
                    alien.rotation! = _R2D(_ATAN2(deltaX!, deltaY!))
                    Move alien, 1
                    alien.rotation! = temp! + 4
                ELSE
                    alien.alienType% = TYPE_PLAYER_CAPTURED
                    SetCostumeWithOffset alien, 0
                    alien.xPos! = alien.xPos! + deltaX!
                    alien.yPos! = alien.yPos! + deltaY!
                    IF alien.rotation! MOD 360 <> 0 THEN alien.rotation! = temp! + 4
                END IF
            ELSE
                IF alienData(CaptorId%).currentAction% = CMD_HOLD_FORMATION THEN
                    alien.formationXOffset! = alienData(CaptorId%).formationXOffset!
                    alien.formationYOffset! = 0
                    alien.alienType% = TYPE_PLAYER_CAPTURED
                    SetPathTypeForAlien alien, PT_TAKE_HOSTAGE_POSITION, 0, 0
                ELSE
                    alien.xPos! = alienData(CaptorId%).xPos!
                    alien.yPos! = alienData(CaptorId%).yPos! - 16
                END IF
            END IF
        END IF
    END IF
END SUB

SUB DoTakeHostagePosition (alien AS ALIENDATA)
    DIM targetX!, targetY!, deltaX!, deltaY!
    GetFormationPosition alien, targetX!, targetY!
    deltaX! = targetX! - alien.xPos!
    deltaY! = targetY! - alien.yPos!
    IF deltaX! ^ 2 + deltaY! ^ 2 > 1 THEN
        TurnTowardsDelta alien, deltaX!, deltaY!, 18
        Move alien, 2
    ELSE
        alien.xPos! = alien.xPos! + deltaX!
        alien.yPos! = alien.yPos! + deltaY!
        IF ABS(ValidateAngle!(alien.rotation!)) < 18 THEN
            alien.rotation! = 0
            NewLife
            PrintText "READY", 10, 18, COLOUR_BLUE
            alien.currentAction% = CMD_HOLD_FORMATION
            waveData.aliensCanAttack% = TRUE
            waveData.aliensAttackingPauseCounter% = 60
        ELSE
            alien.rotation! = alien.rotation! + (alien.rotation! < 0) * -36 - 18
        END IF
    END IF
END SUB

'===== This action reunites the player with the captive ship when it has been released ================================================================================================================

SUB DoDoubleUpPlayer (alien AS ALIENDATA)
    IF alien.doubleUpCounter% > 0 OR NOT CheckInFormation% OR alien.rotation! < 0 OR alien.rotation! >= 18 THEN
        alien.rotation! = ValidateAngle(alien.rotation! + 18)
        IF alien.doubleUpCounter% > 0 THEN alien.doubleUpCounter% = alien.doubleUpCounter% - 1
    ELSE
        IF alien.doubleUpCounter% = 0 THEN
            alien.doubleUpCounter% = -1
            DoubleUpShip
        END IF
        IF alien.rotation! >= 0 AND alien.rotation! < 18 THEN
            alien.rotation! = 0
            IF alien.xPos! < 8 THEN
                alien.xPos! = INT(alien.xPos! + 1)
            ELSEIF alien.xPos! > 8 THEN
                alien.xPos! = INT(alien.xPos! - 1)
            ELSEIF alien.yPos! > -156 THEN
                alien.yPos! = INT(alien.yPos! - 1)
            ELSE
                ResetCaptive
                SetPathTypeForAlien alien, PT_WAIT_FOR_CAPTURE, 0, 0
                ShipDoubledUp
                waveData.aliensCanAttack% = TRUE
            END IF
        ELSE
            alien.rotation! = ValidateAngle(alien.rotation! + 18)
        END IF
    END IF
END SUB

'===== Dive in the direction of the player ============================================================================================================================================================

SUB DoDiveAtPlayer (alien AS ALIENDATA)
    TurnTowardsDelta alien, alien.targetX! - alien.xPos!, alien.targetY! - alien.yPos!, 8
    Move alien, alien.deltaMove!
    IF OffSide%(alien.xPos!) OR OffBottom(alien.yPos!) THEN alien.fetchNewAction% = TRUE
END SUB

'===== Moves the centre of the formation (which is used while the aliens are initially flying on to the screen) =======================================================================================

SUB MoveFormation
    waveData.formationCentreX% = waveData.formationCentreX% + waveData.formationDirection!
    IF ABS(waveData.formationCentreX%) > 30 THEN waveData.formationDirection! = -waveData.formationDirection!
END SUB

'===== Moves an alien forward in the direction it is facing ===========================================================================================================================================

SUB Move (alien AS ALIENDATA, deltaMove!)
    alien.xPos! = alien.xPos! + SIN(_D2R(alien.rotation!)) * deltaMove!
    alien.yPos! = alien.yPos! + COS(_D2R(alien.rotation!)) * deltaMove!
END SUB

'===== Gets the position in the formation to return to ================================================================================================================================================

SUB GetFormationPosition (alien AS ALIENDATA, targetX!, targetY!)
    targetX! = waveData.formationCentreX% + alien.formationXOffset! * waveData.formationSpread!
    targetY! = waveData.formationCentreY% - alien.formationYOffset! * waveData.formationSpread!
END SUB

'===== Turns towards a target angle with a maximum angle specified for the turn amount ================================================================================================================

SUB TurnTowardsDelta (alien AS ALIENDATA, deltaX!, deltaY!, maxTurn!)
    DIM deltaAngle!, targetAngle!
    targetAngle! = _R2D(_ATAN2(deltaX!, deltaY!))
    deltaAngle! = ValidateAngle!(targetAngle! - alien.rotation!)
    IF ABS(deltaAngle!) > maxTurn! THEN
        alien.rotation! = alien.rotation! + deltaAngle! / ABS(deltaAngle!) * maxTurn!
    ELSE
        alien.rotation! = targetAngle!
    END IF
END SUB

'===== Bomb manager ===================================================================================================================================================================================

SUB DropBombs (alien AS ALIENDATA)
    DIM n%
    IF NOT waveData.challengingStage% AND (game.stage% > 1 OR waveData.aliensArrived%) AND waveData.aliensCanAttack% AND waveData.aliensAttackingPauseCounter% = 0 THEN
        IF alien.bombCount% > 0 AND RND < 1 / 14 AND alien.yPos! > -20 THEN
            n% = UBOUND(bomb)
            REDIM _PRESERVE bomb(n% + 1) AS BOMB
            bomb(n%).xPos! = alien.xPos!
            bomb(n%).yPos! = alien.yPos!
            BombTurnTowardsDelta bomb(n%), player.xPos% - alien.xPos!, player.yPos% - alien.yPos!, 20
            alien.bombCount% = alien.bombCount% - 1
            waveData.bombCount% = waveData.bombCount% + 1
        END IF
    END IF
END SUB

SUB UpdateBombs (initialised%)
    DIM n%, i%, j%
    n% = UBOUND(bomb)
    i% = n% - 1
    WHILE i% >= 0
        bomb(i%).xPos! = bomb(i%).xPos! + bomb(i%).deltaX!
        bomb(i%).yPos! = bomb(i%).yPos! + bomb(i%).deltaY!

        IF (bomb(i%).deltaX < 0 AND OffLeft%(bomb(i%).xPos!)) OR (bomb(i%).deltaX >= 0 AND OffRight%(bomb(i%).xPos!)) OR OffBottom%(bomb(i%).yPos!) THEN
            j% = i%
            WHILE j% < n% - 1
                bomb(j%) = bomb(j% + 1)
                j% = j% + 1
            WEND
            n% = n% - 1
            REDIM _PRESERVE bomb(n%) AS BOMB
            waveData.bombCount% = waveData.bombCount% - 1
        ELSE
            IF ABS(bomb(i%).yPos! - player.yPos%) < 8 THEN
                IF bomb(i%).xPos! > player.xPos% - 14 - 16 * (ship(0).state% <> SHIP_ACTIVE) AND bomb(i%).xPos! < player.xPos% + 14 + 16 * (ship(0).state% <> SHIP_ACTIVE) THEN
                    IF bomb(i%).xPos! < player.xPos% THEN ship(0).isHit% = TRUE ELSE ship(1).isHit% = TRUE
                END IF
            END IF
        END IF
        i% = i% - 1
    WEND
END SUB

SUB BombTurnTowardsDelta (bomb AS BOMB, deltaX!, deltaY!, maxTurn!)
    DIM rotation!
    rotation! = _R2D(_ATAN2(deltaX!, deltaY!))
    rotation! = ValidateAngle!(rotation!)
    IF 180 - ABS(rotation!) > maxTurn! THEN
        IF rotation! < 0 THEN rotation! = maxTurn! - 180 ELSE rotation! = 180 - maxTurn!
    END IF
    bomb.deltaX! = SIN(_D2R(rotation!)) * 4
    bomb.deltaY! = COS(_D2R(rotation!)) * 4
END SUB

'===== Sound manager ==================================================================================================================================================================================

SUB LoadSfx (sfx%, sfx$, oneShot%)
    sfx(sfx%).handle& = _SNDOPEN("assets/" + sfx$ + ".ogg")
    IF sfx(sfx%).handle& = 0 THEN AssetError sfx$
    sfx(sfx%).oneShot% = oneShot%
END SUB

SUB LoadAllSFX
    LoadSfx SFX_BOSS_GALAGA_TRACTOR_BEAM, "bossgalagatractorbeam", TRUE
    LoadSfx SFX_TRACTOR_BEAM_CAUGHT, "tractorbeamcaught", TRUE
    LoadSfx SFX_AMBIENCE, "ambience", TRUE
    LoadSfx SFX_GALAGA_ATTACK, "galagaattack", TRUE
    LoadSfx SFX_FIGHTER_SHOOT, "fightershoot", TRUE
    LoadSfx SFX_STAGE_INTRO, "stage intro", TRUE
    LoadSfx SFX_GALAGA_DEFEAT_1, "galagadefeat1", TRUE
    LoadSfx SFX_GALAGA_DEFEAT_2, "galagadefeat2", TRUE
    LoadSfx SFX_BOSS_GALAGA_DEFEAT, "bossgalagadefeat", TRUE
    LoadSfx SFX_BOSS_GALAGA_HIT, "bossgalagahit", TRUE
    LoadSfx SFX_CAPTURED_FIGHTER_DESTROYED, "captured fighter destroyed", TRUE
    LoadSfx SFX_FIGHTER_CAPTURED, "fighter captured", TRUE
    LoadSfx SFX_1_UP, "1-up", TRUE
    LoadSfx SFX_FIGHTER_RESCUED, "fighter rescued", TRUE
    LoadSfx SFX_DIE, "die", TRUE
    LoadSfx SFX_NEXT_LEVEL, "nextlevel", TRUE
    LoadSfx SFX_CHALLENGING_STAGE, "challenging stage", TRUE
    LoadSfx SFX_CHALLENGING_STAGE_OVER, "challenging stage over", TRUE
    LoadSfx SFX_CHALLENGING_STAGE_PERFECT, "challenging stage perfect", TRUE
    LoadSfx SFX_NAME_ENTRY_1, "name entry 1", TRUE
    LoadSfx SFX_NAME_ENTRY_NOT_1, "name entry 2+", TRUE
    LoadSfx SFX_COIN_CREDIT, "coin_credit", TRUE
END SUB

SUB PlaySfx (sfx%)
    IF sfx(sfx%).oneShot% THEN
        _SNDPLAY sfx(sfx%).handle&
    ELSE
        _SNDPLAYCOPY sfx(sfx%).handle&
    END IF
END SUB

SUB PlaySfxLooping (sfx%)
    IF sfx(sfx%).oneShot% THEN
        _SNDLOOP sfx(sfx%).handle&
    END IF
END SUB

SUB StopSfx (sfx%)
    IF sfx(sfx%).oneShot% THEN _SNDSTOP sfx(sfx%).handle&
END SUB

FUNCTION IsPlayingSfx% (sfx%)
    IsPlayingSfx% = _SNDPLAYING(sfx(sfx%).handle&)
END FUNCTION

'===== Process the flags the appear to show the current wave number ===================================================================================================================================

SUB ProcessFlags (initialised%)
    STATIC pauseCounter AS INTEGER
    STATIC values(6) AS INTEGER
    STATIC width(6) AS INTEGER
    STATIC flags(50) AS FLAG
    STATIC nFlags%
    DIM i%, x%, value%, numFlags%
    IF initialised% = FALSE THEN
        IF values%(0) = 0 THEN
            values%(0) = 50: width%(0) = 16
            values%(1) = 30: width%(1) = 16
            values%(2) = 20: width%(2) = 16
            values%(3) = 10: width%(3) = 14
            values%(4) = 5: width%(4) = 8
            values%(5) = 1: width%(5) = 8
        END IF
        REDIM flagDisplay(0) AS FLAG
        nFlags% = 0
        value% = game.stage%
        i% = 0
        nFlags% = 0
        WHILE value% > 0
            IF value% >= values%(i%) THEN
                value% = value% - values%(i%)
                flags(nFlags%).flag% = i%
                nFlags% = nFlags% + 1
            ELSE
                i% = i% + 1
            END IF
        WEND
        x% = 111
        FOR i% = nFlags% - 1 TO 0 STEP -1
            flags(i%).xpos% = x% - width%(flags(i%).flag) / 2
            x% = x% - width%(flags(i%).flag)
        NEXT i%
        pauseCounter% = 0.2 * game.fps%
    END IF
    IF pauseCounter% > 0 THEN pauseCounter% = pauseCounter% - 1: EXIT SUB
    numFlags% = UBOUND(flagDisplay)
    flagDisplay(numFlags%) = flags(numFlags%)
    REDIM _PRESERVE flagDisplay(numFlags% + 1) AS FLAG
    IF game.stage% > 1 THEN PlaySfx SFX_NEXT_LEVEL
    pauseCounter% = 0.2 * game.fps%
    IF numFlags% + 1 = nFlags% THEN
        RemoveEvent EVENT_PROCESS_FLAGS
    END IF
END SUB

'===== Controls costume animation for the handful of aliens that actually animate (other than rotation) ===============================================================================================

SUB SetCostumeWithOffset (alien AS ALIENDATA, offset%)
    alien.costume% = offset%
END SUB

SUB SetCostumeWithTime (alien AS ALIENDATA)
    IF alien.alienType% = TYPE_BOSS_GALAGA OR alien.alienType% = TYPE_BOSS_GALAGA_SHOT OR alien.alienType% = TYPE_BUTTERFLY OR alien.alienType% = TYPE_BEE THEN
        SetCostumeWithOffset alien, INT((game.frameCounter& MOD 32) / 16)
    END IF
END SUB

'======================================================================================================================================================================================================

