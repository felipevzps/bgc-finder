process metaflye {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(trimmedReads)

    output:
    tuple val(run), val(barcode), val(sample_name), file("${sample_name}_assembly_output")

    publishDir "5_assembly/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v flye --meta --nano-hq ${trimmedReads} --out-dir ${sample_name}_assembly_output --iterations 2 --threads 10' > ${sample_name}_assembly_output
    """
}
