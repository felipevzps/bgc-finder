process mapping {
    conda "metagenomics"

    input:
    tuple val(run), val(barcode), val(sample_name), file(trimmedReads), file(assemblyFile)

    output:
    tuple val(run), val(barcode), val(sample_name), file("${sample_name}_mapped_reads_output.sam")

    publishDir "9_genome_binning/${run}/${barcode}/mapping/${sample_name}", mode: 'copy'

    script:
    """
    echo '/usr/bin/time -v bbmap.sh ref=${assemblyFile} in=${trimmedReads} out=${sample_name}_mapped_reads_output.sam threads=10' > ${sample_name}_mapped_reads_output.sam
    """
}
