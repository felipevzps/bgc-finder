process bigscape {
    conda "bigscape"

    input:
    tuple val(run), val(barcode), val(sample_name), file(antismashOutput)

    output:
    path("${sample_name}_bigscape_output")

    publishDir "15_bigscape/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v bigscape -i ${antismashOutput} -o ${sample_name}_bigscape_output --verbose --include_singletons --mode auto --mibig' > ${sample_name}_bigscape_output
    """
}
