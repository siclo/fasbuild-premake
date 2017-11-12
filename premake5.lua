require "lua"
require "fbuild"

workspace "MyWorkspace"
	configurations { "Debug", "Release" }
    platforms { "x86", "x64" }
    location "build"
    --toolset "msc"

project "MyProject"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"
    toolset "gcc"

    files { "**.h", "**.c" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
        
project "MyProject2"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"
    toolset "gcc"

    files { "**.h", "**.c" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

project "MyProjectICC"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"
    toolset "msc"

    files { "**.h", "**.c" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "platforms:x64"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
