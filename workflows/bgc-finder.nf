nextflow.enable.dsl = 2

// Define input samples file
params.samples = file('samples.csv')

// Print details of the samples file
println "Samples file: ${params.samples}"

// Include external module scripts
include { nanoplot      } from '../modules/nanoplot.nf'
include { seqkit        } from '../modules/seqkit.nf'
include { filtlong      } from '../modules/filtlong.nf'
include { porechop      } from '../modules/porechop.nf'
include { metaflye      } from '../modules/metaflye.nf'
include { whokaryote    } from '../modules/whokaryote.nf'
include { mapping       } from '../modules/mapping.nf'
include { samtools      } from '../modules/samtools.nf'
include { metabat2      } from '../modules/metabat2.nf'
include { maxbin2       } from '../modules/maxbin2.nf'
include { concoct       } from '../modules/concoct.nf'
include { graphmb       } from '../modules/graphmb.nf'
include { dastool       } from '../modules/dastool.nf'
include { checkm        } from '../modules/checkm.nf'
include { gtdb          } from '../modules/gtdb.nf'
include { bakta         } from '../modules/bakta.nf'
include { antismash     } from '../modules/antismash.nf'
include { bigscape      } from '../modules/bigscape.nf'

// Main workflow definition
workflow {
    // Read samples file and create a channel with sample name and FASTQ path
    Channel.from(file(params.samples).splitCsv(header: true))
        .map { row -> tuple(row.sample_name, row.fastq_path) }
        .view { sample_name, fastq_path -> "sample: $sample_name, fastq path: $fastq_path" } // Print sample details
        .set { samples_channel } // Set the samples channel

    // Quality control for raw reads using NanoPlot and SeqKit
    samples_channel
        .flatMap { sample_name, reads ->
            nanoplot(reads, "raw_${sample_name}") // Run NanoPlot for visualization
            seqkit(reads, "raw_${sample_name}_stats.txt") // Generate statistics with SeqKit
        }

    // Process reads with Filtlong and Porechop
    samples_channel
        .map { sample_name, reads ->
            filtlong(reads) // Trim low-quality reads with Filtlong
        }
        .map { filtlong_out ->
            porechop(filtlong_out) // Remove adapters with Porechop
        }
        .set { porechop_channel } // Set the output channel for trimmed reads

    // Quality control for trimmed reads
    porechop_channel
        .map { trimmed_reads ->
            nanoplot(trimmed_reads, "trimmed") // Run NanoPlot for trimmed reads
            seqkit(trimmed_reads, "trimmed_stats.txt") // Generate statistics for trimmed reads
        }

    // Assemble reads using MetaFlye
    porechop_channel
        .map { trimmed_reads ->
            metaflye(trimmed_reads) // Perform genome assembly
        }
        .set { metaflye_channel } // Set the assembly output channel

    // Assign taxonomy using WhoKaryote
    metaflye_channel
        .map { assembly ->
            whokaryote(assembly) // Predict organism taxonomy
        }
        .set { whokaryote_channel } // Set the taxonomy output channel

    // Perform genome binning
    metaflye_channel
        .map { assembly ->
            mapping(porechop_channel, assembly) // Map reads to the assembly
        }
        .map { mapping_out ->
            samtools(mapping_out) // Process mapping results with Samtools
        }
        .flatMap { samtools_out ->
            tuple(
                metabat2(samtools_out, metaflye_channel), // Binning with MetaBAT2
                maxbin2(samtools_out, metaflye_channel),  // Binning with MaxBin2
                concoct(samtools_out, metaflye_channel),  // Binning with CONCOCT
                graphmb(samtools_out, metaflye_channel)   // Binning with GraphMB
            )
        }
        .set { binning_channel } // Set the binning output channel

    // Consolidate bins using DAS Tool
    binning_channel
        .flatMap { bins ->
            dastool(*bins) // Refine bins with DAS Tool
        }
        .set { dastool_channel } // Set the refined bins output channel

    // Evaluate bin quality with CheckM
    dastool_channel
        .map { dastool_out ->
            checkm(dastool_out) // Assess bin quality
        }

    // Classify bins taxonomically using GTDB
    dastool_channel
        .map { dastool_out ->
            gtdb(dastool_out) // Assign taxonomy to bins
        }

    // Annotate genomes using Bakta
    dastool_channel
        .map { dastool_out ->
            bakta(dastool_out) // Annotate genomes
        }
        .set { bakta_channel } // Set the genome annotation output channel

    // Identify biosynthetic gene clusters (BGCs) with antiSMASH
    bakta_channel
        .map { bakta_out ->
            antismash(bakta_out) // Detect BGCs
        }
        .set { antismash_channel } // Set the BGC detection output channel

    // Visualize BGCs using BiG-SCAPE
    antismash_channel
        .map { antismash_out ->
            bigscape(antismash_out) // Group and visualize BGCs
        }
}

