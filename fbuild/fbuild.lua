local inspect = require("inspect")

premake.modules.fbuild  = {}
local m = premake.modules.fbuild
local p = premake

newaction {
    trigger = "fbuild",
    description = "Export to FastBuild format",

    toolset = "lol",

    onStart = function()
        p.indent("  ")
        p.eol("\r\n")
        p.escaper(m.escaper)
    end,

    onWorkspace = function(wks)
        p.generate(wks, ".bff", m.generateWorkspace)
    end,

    onProject = function(prj)
        p.generate(prj, ".bff", m.generateProject)
    end,

    execute = function()
    end,

    onEnd = function()
    end
}

function m.generateWorkspace(wks)
    m.generateAllConfigs(wks)
    for prj in p.workspace.eachproject(wks) do
        p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(prj, ".bff")))
    end
end

function m.generateAllConfigs(wks)
    for cfg in p.workspace.eachconfig(wks) do
        local cfgName = cfg.buildcfg
        p.generate(wks, cfgName..".config.bff", m.generateConfig)
        p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(wks, cfgName..".config.bff")))
    end
end

function m.generateConfig(cfg)
    p.w('Coucou les amis')
end

function m.generateProject(prj)
end

function m.esc(value)
    value = value:gsub('\\', '\\\\')
    value = value:gsub('"', '"\\"')
end

function m.map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

return m
