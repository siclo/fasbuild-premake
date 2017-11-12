local inspect = require("inspect")

premake.modules.fbuild  = {}
local m = premake.modules.fbuild
local p = premake

newaction {
    trigger = "fbuild",
    description = "Export to FastBuild format",

    --toolset = "msc-14",

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
    m.generateAllCompilers(wks)
    for prj in p.workspace.eachproject(wks) do
        p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(prj, ".bff")))
    end
end

function m.generateAllCompilers(wks)
    for compilerName, compiler in pairs(m.listCompilers(wks)) do
        local generator = m.compilerGenerators[compilerName]
        if generator then
            p.generate(wks, compilerName..".compiler.bff", generator)
            p.x('#include "%s"', p.workspace.getrelative(wks, p.filename(wks, compilerName..".compiler.bff")))
        else
            error("Unknown compiler: " .. compilerName)
        end
    end
end

function m.listCompilers(wks)
    local compilers = {}
    for prj in p.workspace.eachproject(wks) do
        for cfg in p.project.eachconfig(prj) do
            local compilerName = m.trim(cfg.toolset .. "_" .. cfg.architecture)
            compilers[compilerName] = { toolset = cfg.toolset,
                architecture = cfg.architecture }
        end
    end
    return compilers
end

function m.generateCompiler_msc_x86(cfg)
    p.w('Coucou les amis x86')
end

function m.generateCompiler_msc_x86_64(cfg)
    p.w('Coucou les amis x64')
end

m.compilerGenerators =
{
    msc_x86 = m.generateCompiler_msc_x86,
    msc_x86_64 = m.generateCompiler_msc_x86_64
}

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

function m.trim(text)
    return text:gsub("%s+", "")
end

return m
