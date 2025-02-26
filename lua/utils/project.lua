local M = {}

local function open_json()
    local Path = require("plenary.path")
    local file_path = Path:new(vim.fn.stdpath("data") .. "/projects.json")
    if not file_path:exists() then
        file_path:write("[]", "w")
    end
    return file_path
end

M.query = function()
    local file = open_json()
    return vim.fn.json_decode(file:read())
end

M.save = function(name)
    local file = open_json()
    local projects = vim.fn.json_decode(file:read())
    local exists = false
    for _, project in ipairs(projects) do
        if project.name == name then
            project.path = vim.uv.cwd()
            exists = true
            break
        end
    end
    if not exists then
        table.insert(projects, {
            name = name,
            path = vim.uv.cwd()
        })
    end
    file:write(vim.fn.json_encode(projects), "w")
    Utils.info('project name: ' .. name .. ' saved!', {
        title = 'Project'
    })
end

M.load = function(name)
    local projects = M.query()
    for _, project in ipairs(projects) do
        if project.name == name then
            vim.fn.chdir(project.path)
            Utils.info('project name: ' .. name .. ' loaded!', {
                title = 'Project'
            })
            _G.context.current_project = name
            return
        end
    end
    Utils.error('project name: ' .. name .. ' not found!', {
        title = 'Project'
    })
end

M.delete = function(name)
    local file = open_json()
    local projects = vim.fn.json_decode(file:read())
    local projects_after = {}
    local project_to_del = nil
    for _, project in ipairs(projects) do
        if project.name == name then
            project_to_del = project
        else
            table.insert(projects_after, project)
        end
    end
    if not project_to_del then
        Utils.error('project name: ' .. name .. ' not found!', {
            title = 'Project'
        })
        return
    end
    file:write(vim.fn.json_encode(projects_after), "w")
    Utils.info('project name: ' .. name .. ' deleted!', {
        title = 'Project'
    })
end

M.export_func = function(opts)
    local func_name = opts.name:lower():sub(8)
    M[func_name](opts.args)
end

return M
