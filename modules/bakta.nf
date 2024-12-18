process bakta {
    conda "bakta"

    input:
    tuple val(run), val(barcode), val(sample_name), file(dastoolBins)

    output:
    path("${sample_name}_bakta_output")

    publishDir "13_bakta/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v bakta --db /path/to/bakta/db --prefix ${sample_name}_bakta_output --output ${sample_name}_bakta_output --meta --threads 10 ${dastoolBins}' > ${sample_name}_bakta_output
    """
}
