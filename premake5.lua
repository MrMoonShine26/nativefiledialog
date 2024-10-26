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

        includedirs {
            "/usr/include/gtk-3.0",
            "/usr/include/glib-2.0",
            "/usr/lib/x86_64-linux-gnu/glib-2.0/include",
            "/usr/include/cairo",
            "/usr/include/pango-1.0",
            "/usr/include/harfbuzz",
            "/usr/include/gdk-pixbuf-2.0",
            "/usr/include/atk-1.0"
        }

        libdirs { "/usr/lib/x86_64-linux-gnu" }

        links {
            "gtk-3",
            "gdk-3",
            "gio-2.0",
            "glib-2.0",
            "pango-1.0",
            "harfbuzz",
            "atk-1.0",
            "cairo"
        }

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

