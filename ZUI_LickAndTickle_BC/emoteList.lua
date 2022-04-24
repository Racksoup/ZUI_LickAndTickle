local ZUI_Emotes = LibStub("AceAddon-3.0"): GetAddon("ZUI_LickAndTickle")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_LickAndTickle_Locale")
if not ZUI_Emotes then return end

local emotes = {
    anim = {
        {
            text = L["Angry"],
            emote = "angry"
        },
        {
            text = L["Applaud"],
            emote = "applaud"
        },
        {
            text = L["Attack Target"],
            emote = "attackmytarget"
        },
        {
            text = L["Bashful"],
            emote = "bashful"
        },
        {
            text = L["Beg"],
            emote = "beg"
        },
        {
            text = L["Blame"],
            emote = "blame"
        },
        {
            text = L["Blow"],
            emote = "kiss"
        },
        {
            text = L["Blush"],
            emote = "blush"
        },
        {
            text = L["Boggle"],
            emote = "boggle"
        },
        {
            text = L["Boop"],
            emote = "boop",
        },
        {
            text = L["Bow"],
            emote = "bow",
        },
        {
            text = L["Bravo"],
            emote = "applaud",
        },
        {
            text = L["Bye"],
            emote = "bye",
        },
        {
            text = L["Cackle"],
            emote = "cackle",
        },
        {
            text = L["Charge"],
            emote = "charge",
        },
        {
            text = L["Cheer"],
            emote = "cheer",
        },
        {
            text = L["Chew"],
            emote = "eat",
        },
        {
            text = L["Chicken"],
            emote = "chicken",
        },
        {
            text = L["Chuckle"],
            emote = "chuckle",
        },
        {
            text = L["Clap"],
            emote = "clap",
        },
        {
            text = L["Commend"],
            emote = "commend",
        },
        {
            text = L["Confused"],
            emote = "confused",
        },
        {
            text = L["Congratulate"],
            emote = "congratulate",
        },
        {
            text = L["Cower"],
            emote = "cower",
        },
        {
            text = L["Cry"],
            emote = "cry",
        },
        {
            text = L["Curious"],
            emote = "curious",
        },
        {
            text = L["Curtsey"],
            emote = "curtsey",
        },
        {
            text = L["Dance"],
            emote = "dance",
        },
        {
            text = L["Drink"],
            emote = "drink",
        },
        {
            text = L["Eat"],
            emote = "eat",
        },
        {
            text = L["Excited"],
            emote = "talkex",
        },
        {
            text = L["Farewell"],
            emote = "bye",
        },
        {
            text = L["Feast"],
            emote = "eat",
        },
        {
            text = L["Flap"],
            emote = "chicken",
        },
        {
            text = L["Flee"],
            emote = "flee",
        },
        {
            text = L["Flex"],
            emote = "flex",
        },
        {
            text = L["Flirt"],
            emote = "flirt",
        },
        {
            text = L["Follow Me"],
            emote = "follow",
        },
        {
            text = L["Gasp"],
            emote = "gasp",
        },
        {
            text = L["Giggle"],
            emote = "giggle",
        },
        {
            text = L["Gloat"],
            emote = "gloat",
        },
        {
            text = L["Golf Clap"],
            emote = "golfclap",
        },
        {
            text = L["Goodbye"],
            emote = "bye",
        },
        {
            text = L["Greet"],
            emote = "greet",
        },
        {
            text = L["Grovel"],
            emote = "grovel",
        },
        {
            text = L["Growl"],
            emote = "growl",
        },
        {
            text = L["Guffaw"],
            emote = "guffaw",
        },
        {
            text = L["Hail"],
            emote = "hail",
        },
        {
            text = L["Heal Me"],
            emote = "healme",
        },
        {
            text = L["Hello"],
            emote = "hello",
        },
        {
            text = L["Help Me"],
            emote = "helpme",
        },
        {
            text = L["Hi"],
            emote = "hello",
        },
        {
            text = L["Incoming"],
            emote = "incoming",
        },
        {
            text = L["Insult"],
            emote = "insult",
        },
        {
            text = L["Kiss"],
            emote = "kiss",
        },
        {
            text = L["Kneel"],
            emote = "kneel",
        },
        {
            text = L["Laugh"],
            emote = "laugh",
        },
        {
            text = L["Laydown"],
            emote = "laydown",
        },
        {
            text = L["LoL"],
            emote = "laugh",
        },
        {
            text = L["Lost"],
            emote = "lost",
        },
        {
            text = L["Mad"],
            emote = "angry",
        },
        {
            text = L["Mount-Rear"],
            emote = "mountspecial",
        },
        {
            text = L["Mourn"],
            emote = "mourn",
        },
        {
            text = L["No"],
            emote = "no",
        },
        {
            text = L["Nod"],
            emote = "nod",
        },
        {
            text = L["OOM"],
            emote = "oom",
        },
        {
            text = L["Open-Fire"],
            emote = "openfire",
        },
        {
            text = L["Party"],
            emote = "drink",
        },
        {
            text = L["Peon"],
            emote = "grovel",
        },
        {
            text = L["Plead"],
            emote = "plead",
        },
        {
            text = L["Point"],
            emote = "point",
        },
        {
            text = L["Ponder"],
            emote = "ponder",
        },
        {
            text = L["Pray"],
            emote = "pray",
        },
        {
            text = L["Puzzled"],
            emote = "puzzle",
        },
        {
            text = L["Rasp"],
            emote = "rasp",
        },
        {
            text = L["Roar"],
            emote = "roar",
        },
        {
            text = L["Rofl"],
            emote = "rofl",
        },
        {
            text = L["Rude"],
            emote = "rude",
        },
        {
            text = L["Salute"],
            emote = "salute",
        },
        {
            text = L["Shindig"],
            emote = "drink",
        },
        {
            text = L["Shrug"],
            emote = "shrug",
        },
        {
            text = L["Shy"],
            emote = "shy",
        },
        {
            text = L["Silly"],
            emote = "joke",
        },
        {
            text = L["Sit"],
            emote = "sit"
        },
        {
            text = L["Sleep"],
            emote = "sleep",
        },
        {
            text = L["Sob"],
            emote = "cry",
        },
        {
            text = L["Stand"],
            emote = "stand"
        },
        {
            text = L["Strong"],
            emote = "flex",
        },
        {
            text = L["Strut"],
            emote = "chicken",
        },
        {
            text = L["Surrender"],
            emote = "surrender",
        },
        {
            text = L["Talk"],
            emote = "talk",
        },
        {
            text = L["Talk Excitedly"],
            emote = "talkex",
        },
        {
            text = L["Question?"],
            emote = "talkq",
        },
        {
            text = L["Taunt"],
            emote = "taunt",
        },
        {
            text = L["Thank"],
            emote = "thank",
        },
        {
            text = L["Train"],
            emote = "train",
        },
        {
            text = L["Victory"],
            emote = "victory",
        },
        {
            text = L["Violin"],
            emote = "violin",
        },
        {
            text = L["Wait"],
            emote = "wait",
        },
        {
            text = L["Wave"],
            emote = "wave",
        },
        {
            text = L["Weep"],
            emote = "cry",
        },
        {
            text = L["Welcome"],
            emote = "welcome",
        },
        {
            text = L["Woot"],
            emote = "cheer",
        },
        {
            text = L["Yes"],
            emote = "nod",
        },
        {
            text = L["YW"],
            emote = "yw",
        },
    },
    voice = {
        {
            text = "Applaud",
            emote = "applaud"
        },
        {
            text = "Attack Target",
            emote = "attackmytarget"
        },
        {
            text = "Blow",
            emote = "kiss"
        },
        {
            text = "Bored",
            emote = "bored"
        },
        {
            text = "Bravo",
            emote = "applaud",
        },
        {
            text = "Bye",
            emote = "bye",
        },
        {
            text = "Cackle",
            emote = "cackle",
        },
        {
            text = "Charge",
            emote = "charge",
        },
        {
            text = "Cheer",
            emote = "cheer",
        },
        {
            text = "Chicken",
            emote = "chicken",
        },
        {
            text = "Chuckle",
            emote = "chuckle",
        },
        {
            text = "Clap",
            emote = "clap",
        },
        {
            text = "Commend",
            emote = "commend",
        },
        {
            text = "Congratulate",
            emote = "congratulate",
        },
        {
            text = "Cry",
            emote = "cry",
        },
        {
            text = "Farewell",
            emote = "bye",
        },
        {
            text = "Flap",
            emote = "chicken",
        },
        {
            text = "Flee",
            emote = "flee",
        },
        {
            text = "Flirt",
            emote = "flirt",
        },
        {
            text = "Follow Me",
            emote = "follow",
        },
        {
            text = "Giggle",
            emote = "giggle",
        },
        {
            text = "Gloat",
            emote = "gloat",
        },
        {
            text = "Golf Clap",
            emote = "golfclap",
        },
        {
            text = "Goodbye",
            emote = "bye",
        },
        {
            text = "Guffaw",
            emote = "guffaw",
        },
        {
            text = "Heal Me",
            emote = "healme",
        },
        {
            text = "Hello",
            emote = "hello",
        },
        {
            text = "Help Me",
            emote = "helpme",
        },
        {
            text = "Hi",
            emote = "hello",
        },
        {
            text = "Incoming",
            emote = "incoming",
        },
        {
            text = "Kiss",
            emote = "kiss",
        },
        {
            text = "Laugh",
            emote = "laugh",
        },
        {
            text = "LoL",
            emote = "laugh",
        },
        {
            text = "Moo",
            emote = "moo",
        },
        {
            text = "Mourn",
            emote = "mourn",
        },
        {
            text = "No",
            emote = "no",
        },
        {
            text = "Nod",
            emote = "nod",
        },
        {
            text = "OOM",
            emote = "oom",
        },
        {
            text = "Open-Fire",
            emote = "openfire",
        },            
        {
            text = "Rasp",
            emote = "rasp",
        },            
        {
            text = "Rofl",
            emote = "rofl",
        },
        {
            text = "Sigh",
            emote = "sigh",
        },
        {
            text = "Silly",
            emote = "joke",
        },            
        {
            text = "Sob",
            emote = "cry",
        },
        {
            text = "Strut",
            emote = "chicken",
        },
        {
            text = "Taunt",
            emote = "taunt",
        },
        {
            text = "Thank",
            emote = "thank",
        },
        {
            text = "Train",
            emote = "train",
        },
        {
            text = "Violin",
            emote = "violin",
        },
        {
            text = "Wait",
            emote = "wait",
        },
        {
            text = "Weep",
            emote = "cry",
        },
        {
            text = "Welcome",
            emote = "welcome",
        },           
        {
            text = "Whistle",
            emote = "whistle",
        },
        {
            text = "Woot",
            emote = "cheer",
        },
        {
            text = "Yawn",
            emote = "yawn",
        },
        {
            text = "Yes",
            emote = "nod",
        },
    },
    other = {
        {
            text = L["Absent"],
            emote = "absent"
        },
        {
            text = L["Agree"],
            emote = "agree"
        },
        {
            text = L["Amaze"],
            emote = "amaze"
        },
        {
            text = L["Apologize"],
            emote = "apologize"
        },
        {
            text = L["Arm"],
            emote = "arm"
        },
        {
            text = L["Awe"],
            emote = "awe"
        },
        {
            text = L["Backpack"],
            emote = "backpack"
        },
        {
            text = L["Bad Feeling"],
            emote = "badfeeling"
        },
        {
            text = L["Bark"],
            emote = "bark"
        },
        {
            text = L["Beckon"],
            emote = "beckon"
        },
        {
            text = L["Belch"],
            emote = "burp"
        },
        {
            text = L["Bite"],
            emote = "bite"
        },
        {
            text = L["Blank"],
            emote = "blank"
        },
        {
            text = L["Bleed"],
            emote = "bleed"
        },
        {
            text = L["Blood"],
            emote = "bleed"
        },
        {
            text = L["Blink"],
            emote = "blink"
        },
        {
            text = L["Bonk"],
            emote = "bonk"
        },
        {
            text = L["Bounce"],
            emote = "bounce"
        },
        {
            text = L["Brandish"],
            emote = "brandish",
        },
        {
            text = L["Brb"],
            emote = "brb",
        },
        {
            text = L["Breath"],
            emote = "breath",
        },
        {
            text = L["Burp"],
            emote = "burp",
        },
        {
            text = L["Calm"],
            emote = "calm",
        },
        {
            text = L["Challenge"],
            emote = "challenge"
        },
        {
            text = L["Cat"],
            emote = "scratch",
        },
        {
            text = L["Catty"],
            emote = "scratch",
        },
        {
            text = L["Charm"],
            emote = "charm",
        },
        {
            text = L["Chug"],
            emote = "chug",
        },
        {
            text = L["Cold"],
            emote = "cold",
        },
        {
            text = L["Comfort"],
            emote = "comfort",
        },
        {
            text = L["Cough"],
            emote = "cough",
        },
        {
            text = L["Cover Ears"],
            emote = "coverears",
        },
        {
            text = L["Crack"],
            emote = "crack",
        },
        {
            text = L["Cringe"],
            emote = "cringe",
        },
        {
            text = L["Cross-Arms"],
            emote = "crossarms",
        },
        {
            text = L["Cuddle"],
            emote = "cuddle",
        },
        {
            text = L["Ding"],
            emote = "ding",
        },
        {
            text = L["Disagree"],
            emote = "disagree",
        },
        {
            text = L["Doubt"],
            emote = "doubt",
        },
        {
            text = L["Disappointed"],
            emote = "frown",
        },
        {
            text = L["Doh.."],
            emote = "bonk",
        },
        {
            text = L["Doom"],
            emote = "threaten",
        },
        {
            text = L["Drool"],
            emote = "drool",
        },
        {
            text = L["Duck"],
            emote = "duck",
        },
        {
            text = L["Embarrass"],
            emote = "embarrass",
        },
        {
            text = L["Encourage"],
            emote = "encourage",
        },
        {
            text = L["Enemy"],
            emote = "enemy",
        },
        {
            text = L["Eye"],
            emote = "eye",
        },
        {
            text = L["Eyebrow"],
            emote = "eyebrow",
        },
        {
            text = L["Facepalm"],
            emote = "facepalm",
        },
        {
            text = L["Faint"],
            emote = "faint",
        },
        {
            text = L["Fart"],
            emote = "fart",
        },
        {
            text = L["Fear"],
            emote = "cower",
        },
        {
            text = L["Fidget"],
            emote = "fidget",
        },
        {
            text = L["Flop"],
            emote = "flop",
        },
        {
            text = L["Food"],
            emote = "hungry",
        },
        {
            text = L["Frown"],
            emote = "frown",
        },
        {
            text = L["Gaze"],
            emote = "gaze",
        },
        {
            text = L["Glad"],
            emote = "happy",
        },
        {
            text = L["Glare"],
            emote = "glare",
        },
        {
            text = L["Glower"],
            emote = "glower",
        },
        {
            text = L["Go"],
            emote = "go",
        },
        {
            text = L["Going"],
            emote = "going",
        },
        {
            text = L["Grin"],
            emote = "grin",
        },
        {
            text = L["Groan"],
            emote = "groan",
        },
        {
            text = L["Happy"],
            emote = "happy",
        },
        {
            text = L["High-Five"],
            emote = "highfive",
        },
        {
            text = L["Hug"],
            emote = "hug",
        },
        {
            text = L["Hungry"],
            emote = "hungry",
        },
        {
            text = L["Impatient"],
            emote = "fidget",
        },
        {
            text = L["Introduce"],
            emote = "introduce",
        },
        {
            text = L["JK"],
            emote = "jk",
        },
        {
            text = L["Knuckles"],
            emote = "crack",
        },
        {
            text = L["Lavish"],
            emote = "praise",
        },
        {
            text = L["Lick"],
            emote = "lick",
        },
        {
            text = L["Luck"],
            emote = "luck",
        },
        {
            text = L["Listen"],
            emote = "listen",
        },
        {
            text = L["Love"],
            emote = "love",
        },
        {
            text = L["Map"],
            emote = "map",
        },
        {
            text = L["Massage"],
            emote = "massage",
        },
        {
            text = L["Moan"],
            emote = "moan",
        },
        {
            text = L["Mock"],
            emote = "mock",
        },
        {
            text = L["Moon"],
            emote = "moon",
        },
        {
            text = L["Nosepick"],
            emote = "nosepick",
        },
        {
            text = L["Panic"],
            emote = "panic",
        },
        {
            text = L["Pat"],
            emote = "pat",
        },
        {
            text = L["Peer"],
            emote = "peer",
        },
        {
            text = L["Pest"],
            emote = "shoo",
        },
        {
            text = L["Pick"],
            emote = "nosepick",
        },
        {
            text = L["Pity"],
            emote = "pity",
        },
        {
            text = L["Pizza"],
            emote = "hungry",
        },
        {
            text = L["Poke"],
            emote = "poke",
        },
        {
            text = L["Pounce"],
            emote = "pounce",
        },
        {
            text = L["Praise"],
            emote = "praise",
        },
        {
            text = L["Purr"],
            emote = "purr",
        },
        {
            text = L["Question"],
            emote = "talkq",
        },
        {
            text = L["Raise"],
            emote = "raise",
        },
        {
            text = L["Ready"],
            emote = "ready",
        },
        {
            text = L["Rear"],
            emote = "shake",
        },
        {
            text = L["Sad"],
            emote = "sad",
        },
        {
            text = L["Scared"],
            emote = "scared",
        },
        {
            text = L["Scratch"],
            emote = "scratch",
        },
        {
            text = L["Sexy"],
            emote = "sexy",
        },
        {
            text = L["Shake"],
            emote = "shake",
        },
        {
            text = L["Shimmy"],
            emote = "shimmy",
        },
        {
            text = L["Shiver"],
            emote = "shiver",
        },
        {
            text = L["Shoo"],
            emote = "shoo",
        },
        {
            text = L["Slap"],
            emote = "slap",
        },
        {
            text = L["Smell"],
            emote = "stink",
        },
        {
            text = L["Smirk"],
            emote = "smirk",
        },
        {
            text = L["Snarl"],
            emote = "snarl",
        },
        {
            text = L["Snicker"],
            emote = "snicker",
        },
        {
            text = L["Sniff"],
            emote = "sniff",
        },
        {
            text = L["Snub"],
            emote = "snub",
        },
        {
            text = L["Soothe"],
            emote = "soothe",
        },
        {
            text = L["Sorry"],
            emote = "apologize",
        },
        {
            text = L["Spit"],
            emote = "spit",
        },
        {
            text = L["Spoon"],
            emote = "cuddle",
        },
        {
            text = L["Stare"],
            emote = "stare",
        },
        {
            text = L["Stink"],
            emote = "stink",
        },
        {
            text = L["Surprised"],
            emote = "surprised",
        },
        {
            text = L["Tap"],
            emote = "tap",
        },
        {
            text = L["Tease"],
            emote = "tease",
        },
        {
            text = L["Thirsty"],
            emote = "thirsty",
        },
        {
            text = L["Threat"],
            emote = "threaten",
        },
        {
            text = L["Tickle"],
            emote = "tickle",
        },
        {
            text = L["Tired"],
            emote = "tired",
        },
        {
            text = L["Veto"],
            emote = "veto",
        },
        {
            text = L["Volunteer"],
            emote = "raise",
        },
        {
            text = L["Whine"],
            emote = "whine",
        },
        {
            text = L["Wickedly"],
            emote = "grin",
        },
        {
            text = L["Wink"],
            emote = "wink",
        },
        {
            text = L["Work"],
            emote = "work",
        },
        {
            text = L["Wrath"],
            emote = "threaten",
        },
        {
            text = L["Yay!"],
            emote = "happy",
        },
    },
}
ZUI_LickAndTickle:setEmoteList(emotes)