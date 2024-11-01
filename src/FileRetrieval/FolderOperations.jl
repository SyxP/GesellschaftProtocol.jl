function CleanupEmptySubfolders(folder)
    for (root, dirs, files) in walkdir(folder; topdown = false)
        if length(dirs) == 0 && length(files) == 0
            rm(root)
        end
    end
end