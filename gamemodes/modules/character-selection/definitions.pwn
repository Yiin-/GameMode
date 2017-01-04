#include <YSI\y_hooks>

/**
 * Virtual worlds
 */
const VW_OFFSET_CHARSELECT = UNIQUE_SYMBOL;

/**
 * States
 */

#define CHARACTER_SELECTION_STATE_SELECTING_NAME (CHARACTER_STATE_LAST + 1)
#define CHARACTER_SELECTION_STATE_SELECTING_CHARACTER (CHARACTER_STATE_LAST + 2)
#define CHARACTER_SELECTION_STATE_SELECTING_SKIN (CHARACTER_STATE_LAST + 3)
#define CHARACTER_SELECTION_STATE_WAITING_FOR_SPECTATE (CHARACTER_STATE_LAST + 4)
#define CHARACTER_SELECTION_STATE_WAITING_FOR_NEW_CHARACTER (CHARACTER_STATE_LAST + 5)
#define CHARACTER_SELECTION_STATE_NEW_CHARACTER_JUST_CREATED (CHARACTER_STATE_LAST + 6)

const CHARACTER_SELECTION_STATE_LAST = CHARACTER_STATE_LAST + 5;
#if defined CHARACTER_STATE_LAST
	#undef CHARACTER_STATE_LAST
#endif
#define CHARACTER_STATE_LAST (CHARACTER_SELECTION_STATE_LAST)

/**
 * Events
 */
const EVENT_LOADING_PREVIEW_SKIN = UNIQUE_SYMBOL + 1;
const EVENT_LOADED_PREVIEW_SKIN = UNIQUE_SYMBOL + 2;
const EVENT_GAMESTART_SPAWN = UNIQUE_SYMBOL + 3;

/**
 * Errors
 */
#define CHARACTER_CREATION_ERROR_CHARACTERS_LIMIT_REACHED (1)
#define CHARACTER_CREATION_ERROR_NAME_ALREADY_EXISTS (2)
#define CHARACTER_CREATION_ERROR_INVALID_NAME (3)

/**
 * Limits
 */
#define MAX_CHARACTERS (4)