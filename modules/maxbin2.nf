process maxbin2 {
    conda "metagenomics"

    input:
    file(bamFile)
    file(assemblyFile)

    output:
    path("maxbin2_bins")

    script:
    """
    /usr/bin/time -v run_MaxBin.pl -contig ${assemblyFile} -abund depth.txt -out maxbin2_bins -thread 5
    """
}
