process metabat2 {
    conda "metagenomics"

    input:
    file(bamFile)
    file(assemblyFile)

    output:
    path("metabat2_bins")

    script:
    """
    /usr/bin/time -v jgi_summarize_bam_contig_depths --outputDepth depth.txt ${bamFile}
    /usr/bin/time -v metabat2 -i ${assemblyFile} -a depth.txt -o metabat2_bins -t 5
    """
}
