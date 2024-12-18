process gtdb {
    conda "gtdbtk"

    input:
    tuple val(run), val(barcode), val(sample_name), file(dastoolBins)

    output:
    path("${sample_name}_gtdb_output")

    publishDir "12_gtdb/${run}/${barcode}/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v gtdbtk classify_wf --genome_dir ${dastoolBins} --out_dir ${sample_name}_gtdb_output --cpus 30' > ${sample_name}_gtdb_output
    """
}
