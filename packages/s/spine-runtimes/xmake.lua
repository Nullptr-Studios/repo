package("spine-runtimes")
set_homepage("https://github.com/EsotericSoftware/spine-runtimes")
set_description("2D skeletal animation runtimes for Spine (C++ runtime)")
set_license("Spine Runtimes")

add_urls("https://github.com/EsotericSoftware/spine-runtimes.git")

add_versions("4.2", "4.2")

add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

if is_host("windows") then
	set_policy("platform.longpaths", true)
end

on_install(function (package)
	local configs = {}
	if package:is_debug() then
		table.insert(configs, "-DCMAKE_BUILD_TYPE=Debug")
	else
		table.insert(configs, "-DCMAKE_BUILD_TYPE=Release")
	end
	
	-- Navigate to spine-cpp directory
	os.cd("spine-cpp")
	
	-- Copy source files
	io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

target("spine-cpp")
	set_kind("static")
	add_files("spine-cpp/src/spine/**.cpp")
	add_files("spine-cpp-lite/spine-cpp-lite.cpp")
	add_headerfiles("spine-cpp/include/(spine/**.h)")
	add_includedirs("spine-cpp/include", {public = true})
	add_includedirs("spine-cpp-lite", {public = true})
	set_languages("c++11")
]])
	
	import("package.tools.xmake").install(package)
end)

on_test(function (package)
	assert(package:check_cxxsnippets({test = [[
		#include <spine/SkeletonData.h>
		#include <spine/Skeleton.h>
		void test() {
			spine::SkeletonData data;
			(void)data.getName();
		}
	]]}, {configs = {languages = "c++11"}}))
end)
