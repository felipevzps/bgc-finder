process filtlong {
    conda "metagenomics"

    input:
    file(readsFile)

    output:
    path("filtlong_output.fastq")

    script:
    """
    /usr/bin/time -v filtlong --min_length 1000 ${readsFile} > filtlong_output.fastq
    """
}
