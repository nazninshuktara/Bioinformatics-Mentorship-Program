# 🧬 Day 4 — Introduction to Programming in the Bioinformatics: R Fundamentals

> **Week 2, Day 4** · Saturday, July 11, 2026  
> **Author:** Naznin Akter
---

## 🎯 Learning Checklist
- [1] R Syntax & Variables: Create variables, understand assignment operators (`<- vs =`), and use basic atomic types (`numeric, character, logical`).
- [2] Vector Operations: Create vectors with `c()`, perform vectorized arithmetic, and index elements using integer or boolean masks.
- [3] Factors & Categories: Create factors for biological grouping variables (`e.g., Control vs Treated, Wildtype vs Mutant`).
- [4] Matrices & Data Frames: Construct 2D matrices for gene expression matrices and manipulation using `data.frame` or `tibble`.
- [5] Data Manipulation with dplyr: Use core dplyr verbs `(filter(), select(), mutate(), arrange(), group_by(), summarise())`.
- [6] Basic Visualization with ggplot2: Build scatter plots, boxplots, and bar charts for genomic metrics.
- [7] Bioconductor Basics: Install and load Bioconductor packages `(Biostrings, GEOquery)` and inspect sequence/expression objects.
---

## 🎯 1. Setup Check — RStudio & Environment Verification
### 💡 What is RStudio?
RStudio is a powerful, web-based and desktop interactive development environment (IDE) designed specifically for statistical computing, biological data analysis, and data visualization in R.

### 🎯 Why Use It?
- **All-in-One Interface**: View code, terminal, environment variables, plots, files, and help documentation in a clean 4-pane panel layout.

- **Interactive Scripting & R Markdown**: Write clean R scripts `(.R)` or interactive documents `(.Rmd)` that blend documentation, computational code, and generated outputs.

- **Built-in Biological Plots**: Render high-resolution genomic charts, heatmaps, boxplots, and scatter plots directly in the Plots viewer. Easily monitor active objects, matrices, vectors, and data frames in real time under the "Environment" tab.

- **Essential for Computational Biology**: Designed for seamless integration with Bioconductor and Tidyverse packages to process transcriptomics, genomics, and sequence datasets.

## 🐙 2. Step-by-step walkthrough

### 💡Step 1 — Install R & RStudio
Make sure both R and RStudio Desktop are installed on your computer:

- Download R from CRAN

- Download RStudio Desktop from Posit

### 💡Step 2 - Verify Your R Version

Open your terminal or R console inside RStudio and verify your setup:

```R
R.version.string
```

### 💡Step 3 - Install Core Packages in RStudio
Open RStudio, go to the Console pane at the bottom left, and run the following command to install the required data wrangling and bioinformatics packages:

```
R
# Install Tidyverse and BiocManager
install.packages("tidyverse")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Biostrings")
```

## 📚 3. Interactive Practice Scripts
Complete the hands-on exercises in the following scripts in sequential order:

- [Scripts 1: R Basics, Vectors, Matrices & Factors](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/blob/main/01_foundations/day_4/scripts/01_Basics.R)

- [Scripts 2: Data Frames, Conditional operatins & Custom Functions](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/blob/main/01_foundations/day_4/scripts/02_Conditional_Operations.R)

- [Scripts 3: Data Exploration & Plotting with Tidyverse](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/blob/main/01_foundations/day_4/scripts/03_Data_Exploration.R)

- [Scripts 4: DESeq2 Analysis](https://github.com/nazninshuktara/Bioinformatics-Mentorship-Program/blob/main/01_foundations/day_4/scripts/04_DESeq2_Analysis.R)

🔗 Recommended Resources
- [Statistical Analysis with R by Jubayer Hossain](https://mdjubayerhossain.com/SAR)
- [R graph gallery](https://r-graph-gallery.com/)
- [Data Visualization](https://www.data-to-viz.com/)
- [ggsci](https://nanx.me/ggsci/)
- [Themes](https://github.com/hrbrmstr/hrbrthemes)
- [R graph gallery](https://r-graph-gallery.com/package/ggthemes.html)
- [Tidyplots](https://tidyplots.org/)
- [ggpubr](https://rpkgs.datanovia.com/ggpubr/)





