workspace "MiuEngine"
    architecture "x64"
    startproject "SandBox"
    configurations{ "Debug", "Release", "Distribute" }

output_folder = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root (solution) path
IncludeDir = {}
IncludeDir["GLFW"] = "MiuEngine/3rdparty/GLFW/include"
IncludeDir["Glad"] = "MiuEngine/3rdparty/Glad/include"
IncludeDir["imgui"] = "MiuEngine/3rdparty/imgui"

group "Dependencies"
    include "MiuEngine/3rdparty/GLFW"
    include "MiuEngine/3rdparty/Glad"
    include "MiuEngine/3rdparty/imgui"
group ""

project "MiuEngine"
    location "MiuEngine"
    kind "SharedLib"
    language "C++"
    staticruntime "off"

    targetdir ("_build/out-bin/" .. output_folder .. "/%{prj.name}")
    objdir ("_build/out-obj/" .. output_folder .. "/%{prj.name}")

    pchheader "pch.h"
    pchsource "%{prj.name}/src/pch.cpp"

    forceincludes { "pch.h" }

    files{
        "%{prj.name}/src/**.h", 
        "%{prj.name}/src/**.cpp"
    }

    includedirs{
        "%{prj.name}/src",
        "%{prj.name}/3rdparty/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.imgui}",
    }

    links{
        "GLFW",
        "Glad",
        "imgui",
        "opengl32.lib",
        "Dwmapi.lib",
    }

    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"

        defines{
            "ME_PLATFORM_WINDOWS",
            "ME_BUILD_DLL",
            "GLFW_INCLUDE_NONE",
        }

        postbuildcommands{
             ("{copy} %{cfg.buildtarget.relpath} \"../_build/out-bin/" .. output_folder .. "/SandBox/\"")
        }


    filter "configurations:Debug"
        defines "ME_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "ME_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "ME_DISTRIBUTE"
        runtime "Release"
        optimize "On"

    --[[
    filters { "system:windows", "configurations:Release" }
        buildoptions "/MT"
    ]]


project "SandBox"
    location "SandBox"
    kind "ConsoleApp"
    language "C++"
    staticruntime "off"

    targetdir ("_build/out-bin/" .. output_folder .. "/%{prj.name}")
    objdir ("_build/out-obj/" .. output_folder .. "/%{prj.name}")

    files{
        "%{prj.name}/src/**.h", 
        "%{prj.name}/src/**.cpp"
    }

    includedirs{
        "MiuEngine/3rdparty/spdlog/include",
        "MiuEngine/src"
    }

    links { "MiuEngine" }

    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"

        defines{
            "ME_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "ME_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "ME_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "ME_DISTRIBUTE"
        runtime "Release"
        optimize "On"
