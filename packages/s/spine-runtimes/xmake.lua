package("spine-runtimes")
set_homepage("https://github.com/EsotericSoftware/spine-runtimes")
set_description("2D skeletal animation runtimes for Spine (C++ runtime)")
set_license("Spine Runtimes")

add_urls("https://github.com/EsotericSoftware/spine-runtimes.git")

add_versions("3.8", "d33c10f85634d01efbe4a3ab31dabaeaca41230c")
add_versions("4.0", "4.0")
add_versions("4.1", "4.1")
add_versions("4.2", "4.2")

add_patches("3.8", "patches/3.8/cmake.patch", "bbfa70e3e36f8b3beefbc84d8047eb6735e1e75f4dce643d8916e231b13b992c")

add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

if is_host("windows") then
	set_policy("platform.longpaths", true)
end

add_deps("cmake")

on_install(function (package)
	if package:version():eq("3.8") then
		local configs = {}
		table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
		table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
		import("package.tools.cmake").install(package, configs)
		return
	end

	local xmake_lua = [[
	add_rules("mode.debug", "mode.release")
	set_languages("c++17")

	target("spine-cpp")
	set_kind("static")
	add_files("spine-cpp/spine-cpp/src/spine/**.cpp")
	add_headerfiles("spine-cpp/spine-cpp/include/(**.h)")
	add_includedirs("spine-cpp/spine-cpp/include", {public = true})
	if is_plat("windows") then
		add_defines("NOMINMAX")
	end
	]]
	io.writefile("xmake.lua", xmake_lua)
	import("package.tools.xmake").install(package)
end)

on_test(function (package)
	if package:version():ge("4.0") then
		assert(package:check_cxxsnippets({test = [[
		#include <spine/SkeletonData.h>
		#include <spine/Skeleton.h>
		void test() {
			spine::SkeletonData data;
			(void)data.getName();
		}
		]]}, {configs = {languages = "c++17"}}))
	else
		-- 3.8 API surface
		assert(package:check_cxxsnippets({test = [[
		#include <spine/spine.h>
		void test() {
			spine::Atlas atlas(0, 0, 0, 0);
			(void)atlas.getPages();
		}
		]]}, {configs = {languages = "c++14"}}))
	end
end)
