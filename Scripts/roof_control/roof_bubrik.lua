local mem_name = "roof_mem"
reaper.gmem_attach(mem_name)

local res_path = reaper.GetResourcePath()
local sep = "/" 
-- Теперь обе папки живут в roof_control
local base_dir = res_path .. sep .. "Data" .. sep .. "roof_control"
local src_dir = base_dir .. sep .. "phones_eq"
local db_path = base_dir .. sep .. "hp.db"

-- Функция получения текущего списка файлов в папке
function GetFolderFiles()
    local files = {}
    local i = 0
    repeat
        local name = reaper.EnumerateFiles(src_dir, i)
        if name then
            if name:lower():match("%.txt$") then
                table.insert(files, name)
            end
        end
        i = i + 1
    until not name
    table.sort(files)
    return files
end

-- Функция чтения текущей базы hp.db
function GetStoredFiles()
    local files = {}
    local f = io.open(db_path, "r")
    if f then
        for line in f:lines() do
            -- Убираем возможные пробелы или \r для чистого сравнения
            local clean_line = line:gsub("%s+", "")
            if clean_line ~= "" then table.insert(files, clean_line) end
        end
        f:close()
    end
    table.sort(files)
    return files
end

-- Основная функция обновления базы
function SyncDatabase()
    local folder_files = GetFolderFiles()
    local stored_files = GetStoredFiles()
    
    local update_needed = false
    if #folder_files ~= #stored_files then
        update_needed = true
    else
        for i = 1, #folder_files do
            if folder_files[i] ~= stored_files[i] then
                update_needed = true
                break
            end
        end
    end

    if update_needed then
        local f = io.open(db_path, "w")
        if f then
            for _, v in ipairs(folder_files) do 
                f:write(v .. "\n") 
            end
            f:close()
            --reaper.ShowConsoleMsg("roof_files: База обновлена.\n")
        end
    else
        --reaper.ShowConsoleMsg("roof_files: Изменений нет.\n")
    end
    
    reaper.gmem_write(1, #folder_files)
    reaper.gmem_write(2, 2) 
end

function CheckDB()
    -- Просто проверяем наличие файла базы
    local f = io.open(db_path, "r")
    if f then
        f:close()
    else
        local new_f = io.open(db_path, "w")
        if new_f then
            new_f:write("") 
            new_f:close()
        end
    end
    reaper.gmem_write(2, 1) 
end

function SaveProfile()
    local gain = reaper.gmem_read(1)

    -- читаем имя файла
    local chars = {}
    for i = 0, 255 do
        local ch = reaper.gmem_read(10 + i)
        if ch == 0 then break end
        chars[#chars+1] = string.char(ch)
    end

    local filename = table.concat(chars)
    if filename == "" then return end

    local full_path = src_dir .. sep .. filename

    -- читаем файл
    local lines = {}
    local f = io.open(full_path, "r")
    if not f then return end

    for line in f:lines() do
        table.insert(lines, line)
    end
    f:close()

    -- переписываем
    local f = io.open(full_path, "w")
    if not f then return end

    for _, line in ipairs(lines) do
        if line:match("Preamp:") then
            f:write(string.format("Preamp: %.2f dB\n", gain))
        else
            f:write(line .. "\n")
        end
    end

    f:close()

    -- можно дать сигнал "готово"
    reaper.gmem_write(2, 3)
end

function Main()
    local cmd = reaper.gmem_read(0)

    if cmd == 1 then
        reaper.gmem_write(0, 0)
        SyncDatabase()

    elseif cmd == 2 then
        reaper.gmem_write(0, 0)
        CheckDB()

    elseif cmd == 3 then  -- 🔥 НОВОЕ
        reaper.gmem_write(0, 0)
        SaveProfile()
    end

    reaper.defer(Main)
end

CheckDB()
SyncDatabase()
Main()
