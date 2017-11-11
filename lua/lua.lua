premake.modules.lua = {}
local m = premake.modules.lua
local p = premake

newaction {
    trigger = "lua",
    description = "Export project information as Lua tables",

    onStart = function()
        p.indent("  ")
        p.eol("\r\n")
        p.escaper(m.escaper)
    end,

    onWorkspace = function(wks)
        p.generate(wks, ".wks.lua", m.generateWorkspace)
    end,

    onProject = function(prj)
        p.generate(prj, ".prj.lua", m.generateProject)
    end,

    execute = function()
    end,

    onEnd = function()
    end
}

function m.generateWorkspace(wks)
    p.push('workspace = {')
    p.x('name = "%s",', wks.name)

    p.push('projects = {')
        for prj in p.workspace.eachproject(wks) do
            p.x('name = "%s",', prj.name)
        end
    p.pop('},')

    p.pop('}')
end

function m.generateProject(prj)
    p.push('project = {')
    p.x('name = %s",', prj.name)
    p.w('uuid = %s",', prj.uuid)
    p.w('kind = %s",', prj.kind)
    p.pop('}')
end

function m.esc(value)
    value = value:gsub('\\', '\\\\')
    value = value:gsub('"', '"\\"')
end

return m
