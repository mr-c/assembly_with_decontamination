#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
    forward_reads: File
    reverse_reads: File
    reference: string

steps:
  # QC
  trimmomatic:
    doc: |
      Low quality trimming (low quality ends and sequences with < quality scores
      less than 15 over a 4 nucleotide wide window are removed)
    run: tools/trimmomatic.cwl
    in:
      forward_reads: forward_reads
      reverse_reads: reverse_reads
      phred: { default: "33" }
      leading: { default: 3 }
      trailing: { default: 3 }
      end_mode: { default: PE }
      minlen: { default: 90 }
      slidingwindow: { default: "4:15" }
    out:
      - forward_reads_trimmed_paired
      - reverse_reads_trimmed_paired 
      - summary
  # Reads decontamination
  reads_host_decontamination:
    doc: |
      Remove host contamination from the reads.
    run: tools/pre_assembly_host_decont.cwl
    in:
      reference: reference
      forward_reads: trimmomatic/forward_reads_trimmed_paired
      reverse_reads: trimmomatic/reverse_reads_trimmed_paired
    out:
      - forward_reads_decontaminated
      - reverse_reads_decontaminated
      - summary
  # Assembly
  metaspades:
    doc: |
      Assemble the trimmed reads using metaSpades.
      metaSpades will be run in assembly mode (no error correction).
    run: tools/metaspades.cwl
    in:
      forward_reads: reads_host_decontamination/forward_reads_trimmed_paired
      reverse_reads: reads_host_decontamination/reverse_reads_trimmed_paired
    out:
      - assembly_dir
      - contigs
  # Contigs decontamination
  contigs_host_decontamination:
    doc: |
      Remove any host contamination from the assembled contigs.
    run: tools/post_assembly_host_decont.cwl
    in:
      reference: reference
      contigs: metaspades/contigs
    out:
      - contigs_decontaminated  

outputs:
  trimmomatic_log:
    type: File
    outputSource: trimmomatic/summary
  reads_decontamination_log:
    type: File
    outputSource: reads_host_decontamination/summary
  assembly_dir:
    type: Directory
    outputSource: metaspades/assembly_dir
  contigs_host_decont:
    type: File
    outputSource: contigs_host_decontamination/contigs_decontaminated

