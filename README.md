# oquare-metrics

A module to automatically obtain and save metrics from ontology files based of OQuaRE framework for ontology quality evaluation, generating visual reports which showcase the quality of each ontology and saving them within the repository itself

## OQuaRE

OQuaRE is a framework developed by Astrid Duque Ramos which defines an ontology evaluation system based on ISO/IEC 25000:2005 (SQuaRE), which is presented as an ontology quality evaluation adapted to software quality standard SQuaRE which allows trazability within requirements and metrics of an ontology, with the goal of measuring in an objetive and reproducible way its characteristics as well as bringin assitance to users and developers in taking informed decisions

This module makes use of said framework to bring its capabilities to ontology repositories hosted in GitHub, so that users may evaluate ontologies making use of an stadardized system.

## Features

* Robust tool for ontology metrics, based of OQuaRE framework for ontology quality evaluation
* Easy to configure and use on both existing and new pipelines
* Compatible with Docker
* Set of different plots and graphs, showcasing different aspects of the quality of each ontology and how modifications affects them
* Multiple ontology source folders
* Two different ontology reasoners for ontology metrics calculation (ELK and HermiT)
* Possibility to ignore certain files that might not want to be parsed
* Individual ontology file parsing instead of by folders
* Out of the box functionality with no configuration needed

## Usage
> NOTE: :warning:
> 
> * **IMPORTANT:** Currently you must have both Java and Python installed in the runner machine. This can be done by either a Docker image which has both, or by calling actions/setup-java and actions/setup-python
> * The module has been tested to work under Java 8 Temurin Distribution as well as Python 3.9.4
> * By default the module will search for ontologies on ./ontologies from the repository, and will also save the generated contents in a folder named ./OQuaRE

```yaml
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    name: Evaluate ontologies
    steps:
      - uses: actions/checkout@v2
      # Configuration
      # Java setup
      - uses: actions/setup-java@v2
        with:
          distribution: 'temurin'
          java-version: '8'
      # Python setup
      - uses: actions/setup-python@v3
        with:
          python-version: '3.9'
          
      - name: OQuaRE module
        uses: Emdien/oquare-metrics@v0.0.16 
```

## Inputs

| Input           | Type   | Required | Default      | Description                                                                                      |
|-----------------|--------|----------|--------------|--------------------------------------------------------------------------------------------------|
| ontology-folders | string | true     | 'ontologies' | Sets the folders to track ontologies. Space separated values, no trailing slash needed          |
| ontology-files  | string | false    | ''           | Set of individual ontologies to parse. Space separated values.                                   |
| contents-folder | string | true     | 'OQuaRE'     | Sets the folder on which the module will save all generated content                              |
| ignore-files    | string | false    | ''           | Set of files that the module will ignore when analysing ontology files. Space separated values   |
| reasoner        | string (ELK/HERMIT) | true     | 'ELK'        | Sets the reasoner to be used when evaluating an ontology                            |
| model-plot      | bool   | false    |  true        | Indicates the module to generate OQuaRE model value plot                                         |
| category-plots  | bool   | false    |  true        | Indicates the module to plot OQuaRE categories metrics                                           |
| subcategory-plots  | bool   | false |  true        | Indicates the module to plot OQuaRE subcategories metrics                                        |
| metrics-plots   | bool   | false    |  true        | Indicates the module to plot OQuaRE fine-grained metrics                                         |
| evolution-plot  | bool   | false    |  true        | Indicates if you want the plotting of the evolution of the previous inputs that are set as True  |

## Examples

```yaml
          
    # Assuming that the ontologies that we want to evaluate are stored on src/ontologies/production and src/ontologies/imports
    # And we want to store the metrics on src/ontologies/metrics
    - name: Ontology folder configuration
    uses: Emdien/oquare-metrics@v1 
    with:
        ontology-folders: src/ontologies/production src/ontologies/imports
        contents-folder: src/ontologies/metrics
    
    # Setting up a different reasoner
    - name: Ontology reasoner configuration
    uses: Emdien/oquare-metrics@v1 
    with:
        reasoner: HERMIT

    # Only plot model, subcategories and metrics but not categories and their evolution
    - name: Ontology plots configurtion
    uses: Emdien/oquare-metrics@v1 
    with:
        category-plots: false
        evolution-plot: false

    # Ignore src/ontologies/imports/null_ontology.owl since its empty
    # Also parse ontology_file.owl which is stored on the root folder
    - name: Ontology file configuration
    uses: Emdien/oquare-metrics@v0.0.16 
    with:
        ontology-folders: src/ontologies/imports
        ontology-files: ontology_file.owl
        ignore-files: src/ontologies/imports/null_ontology.owl
    
  
```

## Results

TODO

## Known Limitations

> * The module currently requires of previous, first hand setup of Java and Python. This is done so there is no compatibility issues with some Docker images

## Bug Report

For bug report, you can contact the following emals: (TODO)
* email1@um.es
* email2@um.es
