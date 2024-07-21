project "NFD"
	kind "StaticLib"
	language "C"
	staticruntime "on"
	warnings "off"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files { "src/include/nfd.h" }

    includedirs
	{
        "src/include"
    }
    filter "system:windows"
		cppdialect "c++20"
		systemversion "10.0.22621.0"
		defines { "WINDOWS" }
        files { "src/nfd_common.c", "src/nfd_win.cpp" }
        links { "comdlg32" }

    filter "system:macosx"
        files { "src/nfd_common.c", "src/nfd_cocoa.m" }
        linkoptions { "-framework Cocoa" }

    filter "system:linux"
        files { "src/nfd_common.c", "src/nfd_gtk.c" }
        links { "gtk+-3.0" }

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "speed"

    filter "configurations:Dist"
		runtime "Release"
		optimize "speed"
        symbols "off"

