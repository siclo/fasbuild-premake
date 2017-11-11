require "lua"
require "fbuild"

workspace "MyWorkspace"
	configurations { "Debug", "Release" }

project "MyProject"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"

    files { "**.h", "**.c" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
