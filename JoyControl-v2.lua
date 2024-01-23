--JoyControl version number
VER_NUM = "v2.2-alpha"

-- FUNCTIONS --

--Pause function
function Pause(TIME)
  os.execute("sleep " .. tonumber(TIME)) --Tells OS to pause with time being in seconds
end

--Convert value to string function
--function ValueToString(VALUE)
--	local STRING = tostring(VALUE)


--File detection function
function FileCheck(FILE_NAME)
	DebugLogger("JoyControl: File chekcer started") --Debug message to say when the file checker has started
	
	--Initialises local variables for function
	local FILE_EXISTS = false
	local CORRECT_FILE_VER = false

	--Checks if the file exists
	if FILE_NAME then
		FILE_EXISTS = true

		--Checks if the file has the correct version number
		local FILE_VER = FILE_NAME:read("*line")

		if FILE_VER == VER_NUM then
			CORRECT_FILE_VER = true
		else
			CORRECT_FILE_VER = false
			logMsg("JoyControl: File " .. tostring(FILE_NAME) .. " may require an update. Not updating may cause problems. (JoyControl version: " .. VER_NUM .. ", file version: " .. FILE_VER .. ".)")
		end

		FILE_NAME:read("*line") --Skips blank line after the file version line

	elseif FILE_NAME~=nil then
		io.close(FILE_NAME)
		FILE_EXISTS = false
		logMsg("JoyControl: File " .. FILE_NAME .. " not found.")
	end

	--Outputs the integrity of the file (2=good, 1=wrong version, 0 = missing)
	if CORRECT_FILE_VER and FILE_EXISTS then
		FILE_INTEG = 2
	elseif not CORRECT_FILE_VER and FILE_EXISTS then
		FILE_INTEG = 1
	else
		FILE_INTEG = 0
	end

	DebugLogger("JoyControl: File checker finished") --Debug message to say when the file checker has finished
end

--Function to perform a debug dump
function DebugDump()
	DebugLogger("JoyControl: Debug dumper started") --Debug message to say when the debug dumper has started
	ExtractSimData() --Re-runs the sim data extractor to make sure all information is correct within the debug dump

	logMsg("JoyControl: ~DEBUG DUMP START~") --Sends message to log marking the start of the debug dump
	logMsg("OS: " .. OS_TYPE) --Sends message to log stating what type of OS XP is being run on
	logMsg("Architecture: " .. OS_ARCH) --Sends message to log stating the system architecture (32-bit or 64-bit)
	logMsg("") --Sends message to log leaving a blank line
	logMsg("X-Plane Version: " .. XP_VER) --Sends message to log stating what version of XP is running
	logMsg("XP Language Setting: " .. XP_LANG) --Sends message to log stating what the language is set to within XP
	logMsg("") --Sends message to log leaving a blank line
	logMsg("Joy Control Version: " .. VER_NUM) --Sends message to log stating the version number of JoyControl that is running
	logMsg("") --Sends message to log leaving a blank line
	logMsg("Plane ICAO Code: " .. PL_ICAO) --Sends message to log stating the ICAO code of the current plane being flown
	logMsg("Plane Tail Number: " .. PL_TLNM) --Sends message to log stating the tail number of the current plane being flown
	logMsg("") --Sends message to log leaving a blank line
	logMsg("Plane Author: " .. PL_AUTH) --Sends message to log stating the author of the plane add-on
	logMsg("Aircraft File Path: " .. AC_PATH) --Sends message to log stating the file path of the current plane being flown
	logMsg("Aircraft File Name: " .. AC_FLNM) --Sends message to log stating the file name of the current plane being flown
	logMsg("") --Sends message to log leaving a blank line
	logMsg("Currently loaded datarefs:") --Sends message to log stating that everything underneath is the currently loaded datarefs
	logMsg(AP_DISC_CMD) --Sends message to log stating the currently loaded autopilot disconnect dataref
	logMsg(AT_DISC_CMD) --Sends message to log stating the currently loaded autothrottle disconnect dataref
	logMsg(PARK_BRAKE_CMD) --Sends message to log stating the currently loaded parking brake dataref
	logMsg(TOGA_CMD) --Sends message to log stating the currently loaded autopilot disconnect dataref
	logMsg("JoyControl: ~DEBUG DUMP END~") --Sends message to log marking the end of the debug dump

	DebugLogger("JoyControl: Debug dumper finished") --Debug message to say when the debug dumper has finished
end

--Function to write debug messages to the log
function DebugLogger(DEBUG_LOG_MSG)
	if DEBUG_MODE then
		logMsg(DEBUG_LOG_MSG)
	end
end

--Function to read command packs
function CommandPackReader()
	DebugLogger("JoyControl: Command pack reader started") --Debug message to show when the command pack reader has started

	AP_DISC_CMD_MODE = CMD_PACK:read("*line") --Reads the command handler mode for AP disconnect and saves it to a variable
	AP_DISC_CMD = CMD_PACK:read("*line") --Reads command for AP disconnect and saves it to a variable
	AP_DISC_LOG = CMD_PACK:read("*line") --Reads log message for AP disconnect and saves it to a variable

	CMD_PACK:read("*line") --Skips line

	AT_DISC_CMD_MODE = CMD_PACK:read("*line") --Reads the command handler mode for AP disconnect and saves it to a variable
	AT_DISC_CMD = CMD_PACK:read("*line") --Reads command for AT disconnect and saves it to a variable
	AT_DISC_LOG = CMD_PACK:read("*line") --Reads log message for AT disconnect and saves it to a variable

	CMD_PACK:read("*line") --Skips line

	PARK_BRAKE_CMD_MODE = CMD_PACK:read("*line") --Reads the command handler mode for AP disconnect and saves it to a variable
	PARK_BRAKE_CMD = CMD_PACK:read("*line") --Reads command for parking brake and saves it to a variable
	PARK_BRAKE_LOG = CMD_PACK:read("*line") --Reads log message for parking brake and saves it to a variable

	CMD_PACK:read("*line") --Skips line

	TOGA_CMD_MODE = CMD_PACK:read("*line") --Reads the command handler mode for AP disconnect and saves it to a variable
	TOGA_CMD = CMD_PACK:read("*line") --Reads command for TOGA button and saves it to a variable
	TOGA_LOG = CMD_PACK:read("*line") --Reads log message for parking brake and saves it to a variable

	DebugLogger("JoyControl: Command pack reader finished") --Debug message to show when the command pack reader has finished
end

--Function to read language packs
function LanguagePackReader()
	DebugLogger("JoyControl: Language pack reader started") --Debug message to say when the language pack reader has started

	AP_DISC_CMD_NAME =  LANG_PACK:read("*line") --Reads text for the command name (shows in key-bind menu), and saves it to a variable
	AP_DISC_MACRO_NAME = LANG_PACK:read("*line") --Reads text for the macro name, and saves it to a variable

	LANG_PACK:read("*line") --Skips line

	AT_DISC_CMD_NAME = LANG_PACK:read("*line") --Reads text for the command name (shows in key-bind menu), and saves it to a variable
	AT_DISC_MACRO_NAME = LANG_PACK:read("*line") --Reads text for the macro name, and saves it to a variable

	LANG_PACK:read("*line") --Skips line

	PARK_BRAKE_CMD_NAME = LANG_PACK:read("*line") --Reads text for the command name (shows in key-bind menu), and saves it to a variable
	PARK_BRAKE_MACRO_NAME = LANG_PACK:read("*line") --Reads text for the macro name, and saves it to a variable

	LANG_PACK:read("*line") --Skips line

	TOGA_CMD_NAME = LANG_PACK:read("*line") --Reads text for the command name (shows in key-bind menu), and saves it to a variable
	TOGA_MACRO_NAME = LANG_PACK:read("*line") --Reads text for the macro name, and saves it to a variable

	LANG_PACK:read("*line") --Skips line

	DEBUG_DUMP_MACRO_NAME = LANG_PACK:read("*line") --Reads text for the macro name, and saves it to a variable

	DebugLogger("JoyControl: Language pack reader finished") --Debug message to say when the language pack reader has finished
end

--Config file loader function
function CfgLoader()
	--Sets variable to read the config file when called
	local CFG_FILE = io.open(SCR_DIR .. "JoyControl/JoyControl.cfg", "r")

	--Checks integrity of the config file
	FileCheck(CFG_FILE)

	if FILE_INTEG == 0 then
		logMsg("JoyControl: Config file missing! Please check that this file exists before using JoyControl. JoyControl shutting down...")
		do return end
	end

	LANG_CFG = string.sub(CFG_FILE:read("*line"),23)

	if LANG_CFG == XP then
		XPLanguageHandler()
	end

	CFG_FILE:read("*line")

	DEBUG_MODE = string.sub(CFG_FILE:read("*line"),21)
	FWL_MACRO = string.sub(CFG_FILE:read("*line"),21)
	AUTO_DUMP = string.sub(CFG_FILE:read("*line"),26)
end

--Function to load command packs
function CommandPackLoader()
	DebugLogger("JoyControl: Command pack loader started") --Debug message to say when the command pack loader has started

	local DEFAULT_CMD = false --Initialises the local variables for the function

	CMD_PACK = io.open(SCR_DIR .. "JoyControl/Command Packs/Official/" .. PL_ICAO .. ".txt", "r") --Sets variable to load a command pack from the official folder

	FileCheck(CMD_PACK) --Runs a file check on that command pack

	if FILE_INTEG == 0 then --If file doesn't exist
		local CMD_PACK = io.open(SCR_DIR .. "JoyControl/Command Packs/Community/" .. PL_ICAO .. ".txt", "r") --Sets variable to load a command pack from the community folder

		FileCheck(CMD_PACK) --Runs a file check on that command pack

		if FILE_INTEG == 0 then --If file doesn't exist
			logMsg("JoyControl: Command pack for plane [" .. PL_ICAO .. "] not found. Please make sure this file exists. Using default X-Plane 11 commands.") --Sends message to log stating this
			DEFAULT_CMD = true --Sets variable to tell the loader to load the default command set
		else
			if FILE_INTEG == 1 then --If file is outdated and doesn't match version number
				logMsg("JoyControl: Command pack [" .. PL_ICAO .. "] outdated. This can lead to issues using this command pack. Please check for an update for this command pack.") --Sends message to log warning of this
			end
		end
	else
		if FILE_INTEG == 1 then --If file is outdated and doesn't match version number
			logMsg("JoyControl: Command pack [" .. PL_ICAO .. "] outdated. This can lead to issues using this command pack. Please check for an update for this command pack.") --Sends message to log warning of this
		end
	end

	if DEFAULT_CMD then --If the variable was triggered due to missing command packs
		DefaultCommandSet() --Loads and sets the commands to the default command set
	else
		CommandPackReader() --Activates the command pack reader to read the command pack
	end

	DebugLogger("JoyControl: Command pack loader finished") --Debug message to say when the command pack loader has finished
end

--Function to load language packs
function LanguagePackLoader()
	DebugLogger("JoyControl: Language pack loader started") --Debug message to show the langiage pack loader has started

	local DEFAULT_LANG = false --Initialises the local variables for the function

	XPLanguageHandler()

	if LANG_CFG == XP then --If langiage setting in the config is set to the XP setting
		LANG_PACK = io.open(SCR_DIR .. "JoyControl/Language Packs/Official/" .. XP_LANG .. ".txt", "r") --Sets the variable to load an official language pack based on what the language is within XP

		FileCheck(LANG_PACK) --Runs a file check on the language pack

		if FILE_INTEG == 0 then --If the language pack doesn't exist
			logMsg("JoyControl: Language pack [" .. XP_LANG .. "] not found. Please make sure this file exists. Reverting to hardcoded english language.") --Sends a message to log stating this
			DEFAULT_LANG = true --Sets variable telling the loader system to load the hardcoded language
		else
			if FILE_INTEG == 1 then --If file is outdated with wrong version number
				logMsg("JoyControl: Language pack [" .. XP_LANG .. "] outdated. This can lead to issues using this language pack. Please check for an update to this language pack.") --It sends a message to the log warning of this
			end
		end
	else --If language setting in the config is set to something else
		LANG_PACK = io.open(SCR_DIR .. "JoyControl/Language Packs/Official/" .. LANG_CFG .. ".txt", "r") --Sets the variable to load lanuage pack from the official folder
		
		FileCheck(LANG_PACK) --Runs a file check on the language pack

		if FILE_INTEG == 0 then --If the language pack doesn't exist
			local LANG_PACK = io.open(SCR_DIR .. "JoyControl/Language Packs/Community/" .. LANG_CFG .. ".txt", "r") --Sets the variable to load lanuage pack from the community folder

			FileCheck(LANG_PACK) --Runs a file check on the language pack

			if FILE_INTEG == 0 then --If the language pack doesn't exist
				logMsg("JoyControl: Language pack [" .. LANG_CFG .. "] not found. Please make sure this file exists. Reverting to hardcoded english language.") --Sends a message to log stating this
				DEFAULT_LANG = true --Sets the variable telling the loader system to load the hardcoded language
			else
				if FILE_INTEG == 1 then --If file is outdated with wrong version number
					logMsg("JoyControl: Language pack [" .. LANG_CFG .. "] outdated. This can lead to issues using this language pack. Please check for an update to this language pack.")--It sends a message to the log warning of this
				end
			end
		end
	end

	if DEFAULT_LANG == 1 then --If the variable was triggered due to missing language packs
		HardcodedLanguage() --Loads and sets the language to the hardcoded language
	else
		LanguagePackReader() --Activates the language pack reader to read the language pack
	end

	DebugLogger("JoyControl: Language pack loader finished") --Debug message to show the langiage pack loader has finished
end

--Function to extract data from X-Plane
function ExtractSimData()
	DebugLogger("JoyControl: Sim data extractor started") --Debug message to show the sim data extractor has started

	OS_TYPE = SYSTEM --Detects what OS system XP is running on
	OS_ARCH = SYSTEM_ARCHITECTURE --Detects if sim is running on 32 or 64 bit

	XP_VER = XPLANE_VERSION --Detects what version of XP is being run
	XP_LANG = XPLANE_LANGUAGE --Detects what language is set in XP

	SCR_DIR = SCRIPT_DIRECTORY --Detects the directory that the script is in

	PL_ICAO = PLANE_ICAO --Detects the plane's icao code
	PL_AUTH = PLANE_AUTHOR --Detects the author of the plane add-on

	PL_TLNM = PLANE_TAILNUMBER --Detects the plane's tail number

	AC_PATH = AIRCRAFT_PATH --Detects the path to the aircraft folder
	AC_FLNM = AIRCRAFT_FILENAME --Detects the file name of the aircraft

	DebugLogger("JoyControl: Sim data extractor finished") --Debug message to show the sim data extractor has finished
end

--Function to handle the activation of commands
function CommandHandler(CMD, LOG, CMD_MODE, STAGE)
	if CMD_MODE == "START" then
		ENABLE_STAGE_1 = true
		ENABLE_STAGE_2 = false
		ENABLE_STAGE_3 = false
	elseif CMD_MODE == "ONCE" then
		ENABLE_STAGE_1 = false
		ENABLE_STAGE_2 = true
		ENABLE_STAGE_3 = false
	elseif CMD_MODE == "END" then
		ENABLE_STAGE_1 = false
		ENABLE_STAGE_2 = false
		ENABLE_STAGE_3 = true
	elseif CMD_MODE == "START_END" then
		ENABLE_STAGE_1 = true
		ENABLE_STAGE_2 = false
		ENABLE_STAGE_3 = true
	end
	
	if STAGE == 1 and ENABLE_STAGE_1 == true then
		command_begin(CMD)

		DebugLogger(LOG .. ", Stage: " .. STAGE .. ", " .. CMD_MODE)

	elseif STAGE == 2 and ENABLE_STAGE_2 == true then
		command_once(CMD)

		DebugLogger(LOG .. ", Stage: " .. STAGE .. ", " .. CMD_MODE)

	elseif STAGE == 3 and ENABLE_STAGE_3 == true then
		command_end(CMD)

		DebugLogger(LOG .. ", Stage: " .. STAGE .. ", " .. CMD_MODE)

	end
end

function XPLanguageHandler()
	if XPLANE_LANGUAGE == "English" then
		XP_LANG = EN

	elseif XPLANE_LANGUAGE == "French" then
		XP_LANG = FR

	elseif XPLANE_LANGUAGE == "German" then
		XP_LANG = DE

	elseif XPLANE_LANGUAGE == "Italian" then
		XP_LANG = IT

	elseif XPLANE_LANGUAGE == "Spanish" then
		XP_LANG = ES

	elseif XPLANE_LANGUAGE == "Portuguese" then
		XP_LANG = PT

	elseif XPLANE_LANGUAGE == "Japanese" then
		XP_LANG = JA

	elseif XPLANE_LANGUAGE == "Chinese" then
		XP_LANG = ZH

	elseif XPLANE_LANGUAGE == "Korean" then
		XP_LANG = KO

	elseif XPLANE_LANGUAGE == "Russian" then
		XP_LANG = RU

	elseif XPLANE_LANGUAGE == "Greek" then
		XP_LANG = EL

	end

	--elseif XPLANE_LANGUAGE == "Unknown" then

	--else
end

--Function containing the default set of XP11 commands
function DefaultCommandSet()
	AP_DISC_CMD = "sim/autopilot/servos_toggle" --Sets command for AP disconnect
	AP_DISC_LOG = "JoyControl: Default AP disconnect command activated" --Sets log message for AP disconnect

	AT_DISC_CMD = "sim/autopilot/autothrottle_off" --Sets command for AT disconnect
	AT_DISC_LOG = "JoyControl: Default AT disconnect command activated" --Sets log message for AT disconnect

	PARK_BRAKE_CMD = "sim/flight_controls/brakes_toggle_max" --Sets command for parking brake
	PARK_BRAKE_LOG = "JoyControl: Default parking brake command activated" --Sets log message for parking brake

	TOGA_CMD = "sim/engines/TOGA_power" --Sets command for TOGA button
	TOGA_LOG = "JoyControl: Default TOGA command activated" --Sets log message for TOGA button
end

--Function containing the hardcoded language for JoyControl (in English)
function HardcodedLanguage()
	AP_DISC_CMD_NAME = "JoyControl: Autopilot Disconnect"
	AP_DISC_MACRO_NAME = "JoyControl: Autopilot Disconnect"

	AT_DISC_CMD_NAME = "JoyControl: Autothrottle Disconnect"
	AT_DISC_MACRO_NAME = "JoyControl: Autothrottle Disconnect"

	PARK_BRAKE_CMD_NAME = "JoyControl: Parking Brake Toggle"
	PARK_BRAKE_MACRO_NAME = "JoyControl: Parking Brake Toggle"

	TOGA_CMD_NAME = "JoyControl: Set TOGA Power"
	TOGA_MACRO_NAME = "JoyControl: Set TOGA Power"

	DEBUG_DUMP_MACRO_NAME = "JoyControl: Generate Debug Dump"
end

-- START OF CODE --

ExtractSimData() --Extracts the data from X-Plane that is needed for JoyControl

if AUTO_DUMP == true then
	DebugDump()
end

CfgLoader() --Runs the config loader to load config settings
DebugLogger("JoyControl: Config file loaded") --Debug message to show the config file has loaded

CommandPackLoader()
LanguagePackLoader()

DebugLogger("JoyControl: Loaders finished") --Debug message to show the loaders have finished

--Command Creation

--Creates command for the autopilot disconnect keybind
create_command("FlyWithLua/JoyControl-v2/AP_Disconnect", AP_DISC_CMD_NAME, "CommandHandler(AP_DISC_CMD, AP_DISC_LOG, AP_DISC_CMD_MODE, 1)", "CommandHandler(AP_DISC_CMD, AP_DISC_LOG, AP_DISC_CMD_MODE, 2)", "CommandHandler(AP_DISC_CMD, AP_DISC_LOG, AP_DISC_CMD_MODE, 3)")

--Creates command for the autothrottle disconnect keybind
create_command("FlyWithLua/JoyControl-v2/AT_Disconnect", AT_DISC_CMD_NAME, "CommandHandler(AT_DISC_CMD, AT_DISC_LOG, AT_DISC_CMD_MODE, 1)", "CommandHandler(AT_DISC_CMD, AT_DISC_LOG, AT_DISC_CMD_MODE, 2)", "CommandHandler(AT_DISC_CMD, AT_DISC_LOG, AT_DISC_CMD_MODE, 3)")

--Creates command for the park brake toggle keybind
create_command("FlyWithLua/JoyControl-v2/Park_Brake", PARK_BRAKE_CMD_NAME, "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, PARK_BRAKE_CMD_MODE, 1)", "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, PARK_BRAKE_CMD_MODE, 2)", "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, PARK_BRAKE_CMD_MODE, 3)")

--Creates command for the park brake on keybind
--create_command("FlyWithLua/JoyControl-v2/Park_Brake", PARK_BRAKE_CMD_NAME, "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, 2)", "", "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, 3)")

--Creates command for the park brake off keybind
--create_command("FlyWithLua/JoyControl-v2/Park_Brake", PARK_BRAKE_CMD_NAME, "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, 2)", "", "CommandHandler(PARK_BRAKE_CMD, PARK_BRAKE_LOG, 3)")

--Creates command for the toga keybind
create_command("FlyWithLua/JoyControl-v2/TOGA", TOGA_CMD_NAME, "CommandHandler(TOGA_CMD, TOGA_LOG, TOGA_CMD_MODE, 1)", "CommandHandler(TOGA_CMD, TOGA_LOG, TOGA_CMD_MODE, 2)", "CommandHandler(TOGA_CMD, TOGA_LOG, TOGA_CMD_MODE, 3)")

--Creates command for the seatbelt sign on keybind
--create_command("FlyWithLua/JoyControl-v2/TOGA", TOGA_CMD_NAME, "CommandHandler(TOGA_CMD, TOGA_LOG, 2)", "", "CommandHandler(TOGA_CMD, TOGA_LOG, 3)")

--Creates command for the seatbelt sign off keybind
--create_command("FlyWithLua/JoyControl-v2/TOGA", TOGA_CMD_NAME, "CommandHandler(TOGA_CMD, TOGA_LOG, 2)", "", "CommandHandler(TOGA_CMD, TOGA_LOG, 3)")

--Creates command for the no smoking sign on keybind
--create_command("FlyWithLua/JoyControl-v2/TOGA", TOGA_CMD_NAME, "CommandHandler(TOGA_CMD, TOGA_LOG, 2)", "", "CommandHandler(TOGA_CMD, TOGA_LOG, 3)")

--Creates command for the no smoking sign off keybind
--create_command("FlyWithLua/JoyControl-v2/TOGA", TOGA_CMD_NAME, "CommandHandler(TOGA_CMD, TOGA_LOG, 2)", "", "CommandHandler(TOGA_CMD, TOGA_LOG, 3)")


--Macro Creation

if FWL_MACRO then --If FlyWithLua Macros option is enabled in the config
	--Creates macro to activate the autopilot disconnect command
	add_macro(AP_DISC_MACRO_NAME, "CommandHandler(AP_DISC_CMD, 0)")

	--Creates macro to activate the autopilot disconnect command
	add_macro(AT_DISC_MACRO_NAME, "CommandHandler(AT_DISC_CMD, 0)")

	--Creates macro to activate the autopilot disconnect command
	add_macro(PARK_BRAKE_MACRO_NAME, "CommandHandler(PARK_BRAKE_CMD, 0)")

	--Creates macro to activate the autopilot disconnect command
	add_macro(TOGA_MACRO_NAME, "CommandHandler(TOGA_CMD, 0)")
end

add_macro(DEBUG_DUMP_MACRO_NAME, "DebugDump()")

DebugLogger("JoyControl: Startup finished") --Debug message to that JoyControl has finished starting up