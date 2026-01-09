package("vst3sdk", function()
	set_kind("library")
	set_homepage("https://steinbergmedia.github.io/vst3sdk/")
	set_description("Steinberg VST3 SDK")

	add_urls("https://github.com/steinbergmedia/vst3sdk/archive/refs/tags/$(version).tar.gz")
	add_versions("3.8.0_build_66", "D93C12077D848977D4D397C8AB6721C4B4966223A7707BFE6519AA419C396AF4")

	on_install(function (package)
		os.cp("pluginterfaces", package:installdir("include"))
		os.cp("public.sdk", package:installdir("include"))
	end)

	on_load(function (package)
		package:add("defines", "SMTG_CREATE_PLUGIN_LINK")
	end)
end)