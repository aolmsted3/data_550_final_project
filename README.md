# DATA 550 Final Project: Analysis of Simulated EFGH Data

## Overview

This Github repository contains all code for the final project analysis. Dependencies are listed in renv.lock.

## File structure

The repository contains the following subfolders:

Raw_data: contains a simulated version of the Enterics for Global Health (EFGH) dataset.

Code: includes R scripts to generate the table and figure required for report rendering.

Output: contains outputted files from R scripts (i.e., table and figure).

Renv: contains files for package management.

## Rendering report

Once you have cloned the repository onto your local drive, synchronize the package repository using make install. Render the report using make efgh_report.html.
