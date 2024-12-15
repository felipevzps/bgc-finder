process graphmb {
    conda "graphmb"

    input:
    file(bamFile)
    file(assemblyFile)

    output:
    path("graphmb_bins")

    script:
    """
    /usr/bin/time -v graphmb --assembly ${assemblyFile} --outdir graphmb_bins --depth depth.txt --numcores 10
    """
}
