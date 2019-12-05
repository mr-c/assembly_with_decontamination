#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "Contigs Host Decontamination"

baseCommand: [ echo ]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  contigs:
    type: File
    inputBinding:
      prefix: "--contigs"
  reference:
    type: File
    inputBinding:
      prefix: "--refrence"

outputs:
  contigs_decontaminated:
    type: File
    format: edam:format_1930
    outputBinding:
      glob: $(inputs.contigs).decontaminated.fastq.gz
