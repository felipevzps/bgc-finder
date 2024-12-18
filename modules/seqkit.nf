process seqkit {
    conda "metagenomics"

    input:
    tuple file(reads), val(sample_name)

    output:
    path "${sample_name}_stats.txt"

    script:
    """
    /usr/bin/time -v seqkit stats ${reads} > ${sample_name}_stats.txt
    """
}
