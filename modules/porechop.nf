process porechop {
    conda "metagenomics"

    input:
    file(trimmedReads)

    output:
    path("porechop_output.fastq")

    script:
    """
    /usr/bin/time -v porechop -i ${trimmedReads} -o porechop_output.fastq --threads 5
    """
}
