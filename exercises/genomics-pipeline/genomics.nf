#!/usr/bin/env nextflow

include { SAMTOOLS_INDEX          } from './modules/samtools_index.nf'
include { GATK_HAPLOTYPECALLER    } from './modules/gatk_haplotypecaller.nf'

workflow {

    main:
    bam_chanel = channel.fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> file(row.reads_bam) }

    ref_fasta = file(params.reference)
    ref_index = file(params.reference_index)
    ref_dict = file(params.reference_dict)
    interval_list_bed = file(params.intervals)

    SAMTOOLS_INDEX(bam_chanel)

    GATK_HAPLOTYPECALLER(
        SAMTOOLS_INDEX.out.indexed_bam,
        ref_fasta,
        ref_index,
        ref_dict,
        interval_list_bed
    )

    publish:
    indexed_bam = SAMTOOLS_INDEX.out.indexed_bam
    vcf = GATK_HAPLOTYPECALLER.out.vcf
    vcf_idx = GATK_HAPLOTYPECALLER.out.idx
}

output {
    indexed_bam {
        path 'bam'
    }
    vcf {
        path 'vcf'
    }
    vcf_idx {
        path 'vcf'
    }
}
