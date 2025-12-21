package("spine-runtimes")
set_homepage("https://github.com/EsotericSoftware/spine-runtimes")
set_description("2D skeletal animation runtimes for Spine (C++ runtime)")
set_license("Spine Runtimes")

add_urls("https://github.com/EsotericSoftware/spine-runtimes.git")

add_versions("3.8", "d33c10f85634d01efbe4a3ab31dabaeaca41230c")
add_versions("4.0", "4.0")
add_versions("4.1", "4.1")
add_versions("4.2", "4.2")

add_patches("3.8", "patches/3.8/cmake.patch")
add_patches("4.0", "patches/4.x/spine-cpp-only.patch", "a6343bedac1a72657d65765d35321113160fe6622b28c79242e60e5a71d353be")
add_patches("4.1", "patches/4.x/spine-cpp-only.patch", "a6343bedac1a72657d65765d35321113160fe6622b28c79242e60e5a71d353be")
add_patches("4.2", "patches/4.x/spine-cpp-only.patch", "a6343bedac1a72657d65765d35321113160fe6622b28c79242e60e5a71d353be")
add_patches("4.0", "patches/4.x/default_extension_shim.patch", "903a49c9d873956b517374daf232cb25509ee0df0ed3aa6cd44cfa337da3492a")
add_patches("4.1", "patches/4.x/default_extension_shim.patch", "903a49c9d873956b517374daf232cb25509ee0df0ed3aa6cd44cfa337da3492a")
add_patches("4.2", "patches/4.x/default_extension_shim.patch", "903a49c9d873956b517374daf232cb25509ee0df0ed3aa6cd44cfa337da3492a")

add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

if is_host("windows") then
	set_policy("platform.longpaths", true)
end

add_deps("cmake")

on_install(function (package)
	local configs = {
		"-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"),
		"-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF")
	}
	import("package.tools.cmake").install(package, configs)
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
		assert(package:check_cxxsnippets({test = [[
		#include <spine/spine.h>
		void test() {
			spine::Atlas atlas(0, 0, 0, 0);
			(void)atlas.getPages();
		}
		]]}, {configs = {languages = "c++14"}}))
	end
end)
