process mapping {
    conda "metagenomics"

    input:
    file(trimmedReads)
    file(assemblyFile)

    output:
    path("mapped_reads_output.sam")

    script:
    """
    /usr/bin/time -v bbmap.sh ref=${assemblyFile} in=${trimmedReads} out=mapped_reads_output.sam threads=10
    """
}
