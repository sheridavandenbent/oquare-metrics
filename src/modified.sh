#!/bin/bash

# Inputs
contents_folder=$1
ontology_folders=$2
ignore_files=$3
ontology_files=$4
reasoner=$5
model_plot=$6
category_plot=$7
subcategory_plot=$8
metrics_plot=$9
shift
evolution_plot=$9
shift
modified_files=$9


date="$(date +%Y-%m-%d_%H-%M-%S)"
if [ -z "$(ls -A ./$contents_folder/results)" ]
then
    for ontology_source in $ontology_folders
    do
    if [ -d "$ontology_source" ]
    then
        find $ontology_source -maxdepth 1 -type f -name "*.owl" | while read file
        do
        if [ -z $(printf '%s\n' "$ignore_files" | grep -Fx $file)] && [ -z $(printf '%s\n' "$ontology_files" | grep -Fx $file)]
        then
            outputFile=$(basename "$file" .owl) 
            mkdir -p $contents_folder/temp_results/$ontology_source/$outputFile/$date/metrics
            mkdir -p $contents_folder/temp_results/$dir/$outputFile/$date/img
            outputFilePath="$contents_folder/temp_results/$ontology_source/$outputFile/$date/metrics/$outputFile.xml"
            java -jar $GITHUB_ACTION_PATH/libs/oquare-versions.jar --ontology "$file" --reasoner "$reasoner" --outputFile "$outputFilePath"
            
            if [ $model_plot = "true" ]
            then
            python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $ontology_source -M -f $outputFile -d $date
            fi

            if [ $category_plot = "true" ]
            then
            python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $ontology_source -c -f "$outputFile" -d $date
            fi

            if [ $subcategory_plot = "true" ]
            then
            python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $ontology_source -S -f "$outputFile" -d $date
            fi

            if [ $metrics_plot = "true" ]
            then
            python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $ontology_source -m -f $outputFile -d $date
            fi
        fi
        done
    fi
    done
    for ontology_file in $ontology_files
    do
    if [ -f "$ontology_file" ]
    then
        dir=$(dirname "$ontology_file")
        outputFile=$(basename "$ontology_file" .owl)
        mkdir -p $contents_folder/temp_results/$dir/$outputFile/$date/metrics
        mkdir -p $contents_folder/temp_results/$dir/$outputFile/$date/img
        outputFilePath="$contents_folder/temp_results/$dir/$outputFile/$date/metrics/$outputFile.xml"
        rm -f "$outputFilePath"
        rm -f "$contents_folder/temp_results/$dir/$outputFile/$date/README.md"
        java -jar $GITHUB_ACTION_PATH/libs/oquare-versions.jar --ontology "$ontology_file" --reasoner "$reasoner" --outputFile "$outputFilePath"

        if [ $model_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -M -f $outputFile -d $date
        fi

        if [ $category_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -c -f "$outputFile" -d $date
        fi

        if [ $subcategory_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -S -f "$outputFile" -d $date
        fi

        if [ $metrics_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -m -f $outputFile -d $date
        fi
    fi
    done
else
    for file in $modified_files
    do
    dir=$(dirname "$file")
    outputFile=$(basename "$file" .owl)
    mkdir -p $contents_folder/temp_results/$dir/$outputFile/$date/metrics
    mkdir -p $contents_folder/temp_results/$dir/$outputFile/$date/img
    outputFilePath="$contents_folder/temp_results/$dir/$outputFile/$date/metrics/$outputFile.xml"
    rm -f "$outputFilePath"
    rm -f "$contents_folder/temp_results/$dir/$outputFile/$date/README.md"
    java -jar $GITHUB_ACTION_PATH/libs/oquare-versions.jar --ontology "$file" --reasoner "$reasoner" --outputFile "$outputFilePath"

    if [ $model_plot = "true" ]
    then
        if [ $evolution_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -M -e -f $outputFile -d $date
        else
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -M -f $outputFile -d $date
        fi
    fi

    if [ $category_plot = "true" ]
    then
        if [ $evolution_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -c -e -f $outputFile -d $date
        else
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -c -f $outputFile -d $date
        fi
    fi

    if [ $subcategory_plot = "true" ]
    then
        if [ $evolution_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -S -e -f $outputFile -d $date
        else
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -s $dir -S -f $outputFile -d $date
        fi
    fi

    if [ $metrics_plot = "true" ]
    then
        if [ $evolution_plot = "true" ]
        then
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -m -e -s $dir -f $outputFile -d $date
        else
        python $GITHUB_ACTION_PATH/src/main.py -i $contents_folder -m -s $dir -f $outputFile -d $date
        fi
    fi
    done
fi