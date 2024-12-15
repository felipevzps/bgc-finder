process whokaryote {
    conda "whokaryote"

    input:
    file(assemblyFile)

    output:
    path("whokaryote_output")

    script:
    """
    /usr/bin/time -v whokaryote.py --contigs ${assemblyFile} --outdir whokaryote_output --threads 4
    """
}
