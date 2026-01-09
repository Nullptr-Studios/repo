package("vstwebview", function()
	set_kind("library")
	set_homepage("https://github.com/rdaum/vstwebview")
	set_description("VST3 WebView UI support")

	add_urls("https://github.com/rdaum/vstwebview.git")
	add_versions("main", "main")

	add_deps("vst3sdk")

	if is_plat("linux") then
		add_deps("webkit2gtk")
	end

	on_install(function (package)
		os.cp("include", package:installdir())
		os.cp("src", package:installdir())
	end)

	on_load(function (package)
		package:add("includedirs", "include")
		package:add("srcs", "src/**.cpp")

		if is_plat("windows") then
			package:add("defines", "VSTWEBVIEW_USE_WEBVIEW2")
			package:add("syslinks", "user32", "ole32")
		elseif is_plat("macosx") then
			package:add("frameworks", "WebKit", "Cocoa")
		elseif is_plat("linux") then
			package:add("defines", "VSTWEBVIEW_USE_WEBKITGTK")
		end
	end)
end)