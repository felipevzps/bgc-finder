process bigscape {
    conda "bigscape"

    input:
    file(antismashOutput)

    output:
    path("bigscape_output")

    script:
    """
    /usr/bin/time -v bigscape -i ${antismashOutput} -o bigscape_output --verbose --include_singletons --mode auto --mibig
    """
}
