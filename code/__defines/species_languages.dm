// Species flags.
#define NO_MINOR_CUT      0x1    // Can step on broken glass with no ill-effects. Either thick skin (diona/vox), cut resistant (slimes) or incorporeal (shadows)
#define IS_PLANT          0x2    // Is a treeperson.
#define NO_PAIN           0x4    // Cannot suffer subdual/recieves deceptive health indicator.
#define NO_SLIP           0x8   // Cannot fall over.
#define NO_POISON         0x10   // Cannot not suffer toxloss.
// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define IS_WHITELISTED    0x1    // Must be whitelisted to play.
#define CAN_JOIN          0x2    // Species is selectable in chargen.
#define IS_RESTRICTED     0x4    // Is not a core/normally playable species. (castes, mutantraces)

// Species appearance flags
#define HAS_SKIN_COLOR    0x1    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          0x2    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     0x4    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     0x8    // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    0x10   // Hair colour selectable in chargen. (RGB)

// Languages.
#define LANGUAGE_EAL "Encoded Audio Language"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_SKRELLIAN "Skrellian"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Gutter"

// Language flags.
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL    4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all mobs with this language.
#define NONGLOBAL    32  // Do not add to general languages list.
#define INNATE       64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
