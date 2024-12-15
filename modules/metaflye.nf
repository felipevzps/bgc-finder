process metaflye {
    conda "metagenomics"

    input:
    file(trimmedReads)

    output:
    path("assembly_output")

    script:
    """
    /usr/bin/time -v flye --meta --nano-hq ${trimmedReads} --out-dir assembly_output --iterations 2 --threads 10
    """
}
