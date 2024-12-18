process filtlong {
    conda "metagenomics"

    input:
    tuple val(sample_name), file(reads)

    output:
    tuple val(sample_name), file("${sample_name}_filtlong.fastq")

    script:
    """
    /usr/bin/time -v filtlong --min_length 1000 ${reads} > ${sample_name}_filtlong.fastq
    """
}
