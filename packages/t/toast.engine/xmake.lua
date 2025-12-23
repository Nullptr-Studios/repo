package("toast.engine")
set_description("The toast.engine package")
add_deps("glfw 3.4")
add_deps("glm")
add_deps("nlohmann_json")
add_deps("spdlog")
add_deps("lz4")
add_deps("tracy")
add_deps("glad")
add_deps("stb")
add_deps("yaml-cpp")
add_deps("sol2")
add_deps("tinyobjloader v2.0.0rc13")
add_deps("imgui v1.92.5-docking", {configs = {glfw = true, opengl3 = true}})
add_deps("imguizmo 1.91.3+wip")
add_deps("spine 4.2")

add_urls("https://github.com/Nullptr-Studios/toast-engine.git")
add_versions("1.0", "1.0.0")
add_versions("physics-alpha", "physics/physics-engine")

add_configs("shared", {description = "Build shared library", default = false, type = "boolean", readonly = true})

on_install(function (package)
	local configs = {}
	configs.kind = "static"
	import("package.tools.xmake").install(package, configs, {target = "toast.engine"})
end)
