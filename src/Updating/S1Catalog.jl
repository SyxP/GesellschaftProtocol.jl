"""
    This downloads the catalog_s1.json into the source repository.
    A non-exhaustive list of all the previous catalog_s1:
"""

# https://steamdb.info/depot/1973531/history/
# The folder in StreamingAssets/aa change shows new site.

getCatalogS1Versions() = readlines(joinpath(DataDir, "CatalogS1Versions.txt"))

function downloadCatalogS1JSON(catalogURL::String = getCatalogS1Versions()[end])
    URL = "https://d7g8h56xas73g.cloudfront.net/" * catalogURL * "/catalog_S1.json"
    @info "Downloading $(URL)."
    Downloads.download(URL, joinpath(DataDir, "catalog_S1.json"))

    return
end

function getCatalogJSON(file = "$DataDir/catalog_S1.json")
    isfile(file) || downloadCatalogS1JSON()
    
    # Read file
    io = open(file, "r")
    CatalogStr = Base.read(io, String)
    close(io)

    # Parse JSON
    CatalogJSON = JSON3.read(CatalogStr)
end

function parseCatalogURLs(file = "$DataDir/catalog_S1.json") 
    CatalogJSON = getCatalogJSON(file)

    # Extract URLS from file
    URLs = String[]
    try
        for item in CatalogJSON["m_InternalIds"]
            if item isa String && item[1:5] == "https" # A little hacky trick to check if a string is a URL
                push!(URLs, item)
            end
        end
    catch _
        @error "Catalog JSON $file format unparseable"
    end

    return URLs
end


function getFilePathFromBundleURL(bundleURL, bundleLocation, URLBase = "https://d7g8h56xas73g.cloudfront.net")
    bundleURLParts = split(bundleURL, "/")
    urlBaseParts = split(URLBase, "/")
    fileName = bundleURLParts[(length(urlBaseParts) + 1) : end]
    return filePath = joinpath(bundleLocation, fileName...)
end

function getDataURLs()
    URLs = parseCatalogURLs()
    return filter(x -> match(r"localize|static", x) !== nothing, URLs)
end

function DownloadDataBundles(bundleLocation = "$DownloadCache/Bundles/")
    @info "Downloading to $bundleLocation"

    for url in getDataURLs()
        DownloadBundle(url, bundleLocation)
        sleep(0.2) # To not overwhelm the server
    end
end

function DownloadBundle(bundleURL, bundleLocation) 
    filePath = getFilePathFromBundleURL(bundleURL, bundleLocation)
    isfile(filePath) && return true

    # Check if the location to download to has a folder
    mkpath(dirname(filePath))
    @info "Downloading $filePath"

    try
        io = open(filePath, "w")
        Downloads.download(bundleURL, io)
        close(io)
    catch _
        @info "Failed to download $filePath"
        return false
    end

    return filePath
end

function ExtractDataBundles(catalogURL = getCatalogS1Versions()[end])
    # This does everything pseudo-automatically magically
    # It will break if the internal structure changes
    # It will also break with other edits to this file...
    
    # Download the Catalog S1, and then the Data Bundles in them
    downloadCatalogS1JSON(catalogURL)
    DownloadDataBundles()

    bundleLocation = joinpath(DownloadCache, "Bundles")
    unzipLocation = joinpath(DownloadCache, "Unbundled Data")

    for file in getDataURLs()
        filePath = getFilePathFromBundleURL(file, bundleLocation)
        LoadTextBundle(filePath, unzipLocation)
    end

    # We move the files into the data directory.
    # This replaces the old files in the data directory.
    # For anything that was deleted and wish to be saved,
    # this will have to be done manually.

    mv(joinpath(unzipLocation, "Assets", "Resources_moved"), joinpath(DataDir, "Extracted"); force = true)
    CleanupEmptySubfolders(unzipLocation)
end