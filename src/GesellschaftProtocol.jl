module GesellschaftProtocol

    # We use implicit imports, understanding the risks
    using Downloads, JSON3
    using Scratch
    using UnityPy

    
    
    SourceDir = pkgdir(@__MODULE__, "src")
    for folder in ["FileRetrieval", "Updating"]
        for file in readdir(joinpath(SourceDir, folder); join = true)
            include(file)
        end
    end

    function __init__()
        global DownloadCache = @get_scratch!("downloaded_files")
    end
end