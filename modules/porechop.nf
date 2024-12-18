process porechop {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(trimmedReads)

    output:
    tuple val(run), val(barcode), val(sample_name), file("${sample_name}_porechop_output.fastq")

    publishDir "3_adapter_removal/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v porechop -i ${trimmedReads} -o ${sample_name}_porechop_output.fastq --threads 5' > ${sample_name}_porechop_output.fastq
    """
}
