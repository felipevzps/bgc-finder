process gtdb {
    conda "gtdbtk"

    input:
    file(dastoolBins)

    output:
    path("gtdb_output")

    script:
    """
    /usr/bin/time -v gtdbtk classify_wf --genome_dir ${dastoolBins} --out_dir gtdb_output --cpus 30
    """
}
