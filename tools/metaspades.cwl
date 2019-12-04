#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: "metaSPAdes: de novo metagenomics assembler"

baseCommand: [ spades.py, "--only-assembler", "--meta" ]

requirements:
  InlineJavascriptRequirement: {}

hints:
  #SoftwareRequirement:
    #packages:
      #spades:
        #specs: [ "https://identifiers.org/rrid/RRID:SCR_000131" ]
        #version: [ "20610fec3ecc8c3218" ]
  ResourceRequirement:
    coresMin: $(inputs.threads)
    ramMin: $(inputs.memory * 1024)


inputs:
  forward_reads:
    type: File?
    inputBinding:
      prefix: "-1"
  reverse_reads:
    type: File?
    inputBinding:
      prefix: "-2"
  memory:
    type: int
    default: 250
    doc: |
      Max memory for metaspades in Gb.
    inputBinding:
      prefix: "--memory"
  threads:
    type: int
    default: 16
    doc: |
      Number of threads.
    inputBinding:
      prefix: "--threads"
  continue:
    type: boolean
    default: False
    doc: |
      Spades will try to continue from the latest checkpoint.
      The checkpoint information is stored on the spades result folder.
    inputBinding:
      prefix: "--continue"

arguments:
  - valueFrom: $(runtime.outdir)
    prefix: -o
  - valueFrom: $(runtime.tmpdir)
    prefix: --tmp-dir

stdout: stdout.txt
stderr: stderr.txt

outputs:
  stdout: stdout
  stderr: stderr

  assembly_dir:
    type: Directory
    outputBinding:
      glob: $(runtime.outdir)
    
  contigs:
    type: File?
    format: edam:format_1929  # FASTA
    outputBinding:
      glob: contigs.fasta

  # Scaffolds can be missing if assembly produces no contigs
  scaffolds:
    type: File?
    format: edam:format_1929  # FASTA
    outputBinding:
      glob: scaffolds.fasta

  assembly_graph:
    type: File?
    #format: edam:format_TBD  # FASTG
    outputBinding:
      glob: assembly_graph.fastg

  # Contig paths can be missing if assembly produces no contigs
  contigs_assembly_graph:
    type: File?
    outputBinding:
      glob: contigs.paths

  # Scaffolds paths can be missing if assembly produces no contigs
  scaffolds_assembly_graph:
    type: File?
    outputBinding:
      glob: scaffolds.paths

  contigs_before_rr:
    label: contigs before repeat resolution
    type: File
    format: edam:format_1929  # FASTA
    outputBinding:
      glob: before_rr.fasta

  params:
    label: information about SPAdes parameters in this run
    type: File
    format: iana:text/plain
    outputBinding:
      glob: params.txt

  log:
    label: MetaSP log
    type: File
    format: iana:text/plain
    outputBinding:
      glob: spades.log

  internal_config:
    label: internal configuration file
    type: File
    # format: text/plain
    outputBinding:
      glob: dataset.info

  internal_dataset:
    label: internal YAML data set file
    type: File
    outputBinding:
      glob: input_dataset.yaml

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

doc: |
  https://arxiv.org/abs/1604.03071
  http://cab.spbu.ru/files/release3.12.0/manual.html#meta