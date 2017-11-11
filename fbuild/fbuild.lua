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
    m.generateAllToolsets(wks)
    for prj in p.workspace.eachproject(wks) do
        p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(prj, ".bff")))

        for cfg in p.project.eachconfig(prj) do
            print("Toolset", inspect(p.config.toolset(cfg)))
		end

    end
end

function m.generateAllToolsets(wks)

    --local toolsets = m.map(p.workspace.eachproject(wks), 
    p.generate(wks, ".toolset.bff", m.generateToolset)
    p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(wks, ".toolset.bff")))
end

function m.generateToolset(wks)
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
