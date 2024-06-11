import logging
import os
import subprocess
import yaml
import pandas as pd
import datetime 
import gc
import re

#Function to read the Yaml file
def read_config_file(filepath):
    with open(filepath, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            logging.error(exc)

def replacer(string, char):
    pattern = char + '{2,}'
    string = re.sub(pattern, char, string) 
    return string

#Function to perform validation between the Windmill dataset and the schema we require for the data
def col_header_val(df, table_config):
    '''
This Function transform all column names to lowecase,ensure any character in the column that is not a word to _,
Removes leading and trailing zeros in colum names,replace multiple undescores to single underscores 
    '''
    df.columns = df.columns.str.lower()
    df.columns = df.columns.str.replace('[^\w]', '_', regex=True)
    df.columns = list(map(lambda x: x.strip('_'), list(df.columns)))
    df.columns = list(map(lambda x: replacer(x, '_'), list(df.columns)))


    #Convert the columns in configration file to lowercase and sort 

    expected_col = list(map(lambda x: x.lower(), table_config['columns']))
    expected_col.sort()

    df.columns = list(map(lambda x: x.lower(), list(df.columns)))
   

    if len(df.columns) == len(expected_col) and list(expected_col) == list(df.columns):
        print("column name and  length are same in the givendataset and congiration -> validation passed")
        return 1
    else:
        print("column name and length mismatch, validation failed")
        mismatched_columns = list(set(df.columns).difference(expected_col))

        print("These columns are not found in the YAML file", mismatched_columns)
        missing_YAML_file = list(set(expected_col).difference(df.columns))
        
        print("Following YAML columns are not in the file uploaded", missing_YAML_file)
        logging.info(f'df columns: {df.columns}')
        logging.info(f'expected columns: {expected_col}')
        return 0
