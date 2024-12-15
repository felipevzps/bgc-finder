process extractProkaryoticContigs {
    conda "metagenomics"

    input:
    file(assemblyFile) 
    file(prokaryoteHeaders) 

    output:
    path("prokaryote_dataset") 

    script:
    """
    /usr/bin/time -v ./extractContigsFromWhokaryote.py -i ${assemblyFile} -p ${prokaryoteHeaders} -o prokaryote_dataset
    """
}
