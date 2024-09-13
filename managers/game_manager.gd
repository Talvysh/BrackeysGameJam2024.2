extends Node

enum GameState {
	INGAME,
	PAUSED,
	LOADING
}
var game_state := GameState.INGAME

enum ActionState {
	SELECTING,
	BUILDING
}
var action_state := ActionState.SELECTING
