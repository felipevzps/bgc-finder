/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	IMPORT MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
 * MODULES
 */

include { NANOPLOT as NANOPLOT_RAW		} from '../modules/nanoplot'
include { NANOPLOT as NANOPLOT_FILTERED		} from '../modules/nanoplot'
include { SEQKIT as SEQKIT_RAW			} from '../modules/seqkit'
include { SEQKIT as SEQKIT_FILTERED		} from '../modules/seqkit'

/*
 * SUBWORKFLOWS
 */

include { INPUT_CHECK				} from '../subworkflows/input_check'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow BGC-FINDER {

	ch_versions = Channel.empty()

	INPUT_CHECK ()
	ch_reads = INPUT_CHECK.out.reads

	SEQKIT_RAW (ch_reads)
	ch_seqkit_raw = SEQKIT_RAW.out.reads // talvez seja out.stats

	NANOPLOT_RAW (ch_reads)
	ch_nanoplot_raw = NANOPLOT_RAW.out.reads // talvez seja out.nanoplot

}
