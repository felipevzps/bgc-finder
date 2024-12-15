process bakta {
    conda "bakta"

    input:
    file(dastoolBins)

    output:
    path("bakta_output")

    script:
    """
    /usr/bin/time -v bakta --db /path/to/bakta/db --prefix bakta_output --output bakta_output --meta --threads 10 ${dastoolBins}
    """
}
