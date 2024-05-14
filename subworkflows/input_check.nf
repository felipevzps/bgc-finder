/*
 * Check input samplesheet and get read channels
 */

def hasExtension(it, extension) {
	it.toString().toLowerCase().endsWith(extension.toLowerCase())
}

workflow INPUT_CHECK {
	main:
	if(hasExtension(params.input, "csv")){
		// Read the CSV file and split into rows
		ch_input_rows = Channel
			.from(file(params.input))
			.splitCsv(header: true)
        
		// Map each row to extract sample and reads columns
		ch_raw_long_reads = ch_input_rows.map { row ->
			def sample = row.sample
			def reads = row.reads
            
			// Check if sample and reads are provided
			if (!sample || !reads) {
				exit 1, "Invalid input format: Each row must contain 'sample' and 'reads' columns."
			}
			// Construct metadata object
			def meta = [:]
			meta.id = sample
		
			// Return metadata and path to reads
			return [meta, reads]
		}
	}

	emit:
	reads = ch_reads
}
