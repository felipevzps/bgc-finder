process porechop {
    conda "metagenomics"

    input:
    tuple file(trimmedReads), val(outputPrefix)

    output:
    path "porechop_output.fastq"

    script:
    """
    /usr/bin/time -v porechop -i ${trimmedReads} -o porechop_output.fastq --threads 5
    """
}
