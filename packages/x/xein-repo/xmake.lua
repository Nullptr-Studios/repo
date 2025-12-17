package("xein-repo", function()
	set_description("the xein-repo package")

	add_urls("https://github.com/ynks/xmake-repo-test.git")
	add_versions("1.0", "v1.0")

	on_install(function (package)
		local configs = {}
		if package:config("shared") then
			configs.kind = "shared"
		end
		import("package.tools.xmake").install(package, configs)
	end)

	on_test(function (package)
	end)
end)
