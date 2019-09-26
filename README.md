# Analysis for Tompson, Kahn, Falk, Vettel, & Bassett (under review)

Data and analysis code for *Tompson, S.H., Kahn, A.E, Falk, E.B., Vettel., J.M., & Bassett, D.S. 
Functional brain network architecture supporting the learning of social networks in humans. 
Manuscript under review.*

[Preprint on PsyArXiv](https://psyarxiv.com/r46gj/)

<img align="right" width=300px src=Figures/fig3.png> 

***

### Code
* [Background Code](code/background_code): code with prefix "Step0" in the "background_code" folder is not linked to 
any raw data to protect participant privacy but shows the steps used to extract the connectivity matrices, 
behavioral performance, and univariate activation. Note that the script to generate z-scores is also not linked to 
any data because the null models were too large to store on Github.
* [1_Hub_Analyses.ipynb](code/1_Hub_Analyses.ipynb) 
takes the z-scored connectivity metrics (both node strength scores and connectivity matrices),
and reproduces the node strength, hub system, and hub-to-hub connectivity analyses
* [2_Behavioral_Analyses.ipynb](code/2_Behavioral_Analyses.ipynb) 
reproduces the main mixed effect models for the behavioral results as well as 
the moderating effect of connectivity on behavior.
* [3_Supplemental_Behavioral_Analyses.ipynb](code/3_Supplemental_Behavioral_Analyses.ipynb) 
reproduces the behavioral analyses from the supplementary results section,
including generating mixed effects models that include brain activation and head motion as covariates.
* [4_Supplemental_Brain_Activation_Analyses.ipynb](code/4_Supplemental_Brain_Activation_Analyses.ipynb) 
reproduces the univariate brain activation analyses from the supplementary results section.

### Data

* files in ../data/brain_atlas provide information for the combined Schaefer/Harvard-Oxford atlas that was used to define nodes
* files in ../data/glm_means contain mean activation for transition versus non-transition trials for each subject in a priori hubs
* files in ../data/netLearn_glm/secondLevel contain results for the second-level contrasts included in the supplement
* files in ../data/ppi_zscores contain z-scores and p-values for connectivity metrics
* files in ../data/subj_data provide information about subjects including trial-level behavior, anonymized scan ID, order info, etc.

### Dependencies
* Python 2.7
* R 3.4.0

Note: These analyses were run on a Macbook Pro with operating system OS X Mojave v10.14.6. 
All analyses were run using Python 2.7 and R 3.4 and so some of the code might not be 100% compatible with newer versions 
or if you try to run them on a Windows or Linux machine. 
The packages themselves should be compatible with newer versions, but you might need to debug the code a bit.

[Anaconda](http://continuum.io/downloads) should provide you with most of what you need.

#### The following packages are used and we feel very indebted to their creators:

* [Project Jupyter](https://github.com/jupyter) 

#### Python
* [bctpy v0.5.0](https://github.com/aestrivex/bctpy) e.g. `pip install bctpy`
* [matplotlib v2.2.2](http://matplotlib.org/)
* [mne v0.16.2](https://www.nmr.mgh.harvard.edu/mne/stable/index.html)
* [nibabel v2.3.0](https://nipy.org/packages/nibabel/index.html)
* [nilearn v0.4.2](https://nipy.org/packages/nilearn/index.html) 
* [nipy v0.4.2](https://nipy.org/packages/nipy/index.html)
* [nistats v0.0.1b](https://nistats.github.io/)
* [numpy v1.16.4](http://www.numpy.org/)
* [pandas v0.23.0](http://pandas.pydata.org/)
* [scipy v1.1.0](https://www.scipy.org/)
* [seaborn v0.9.0](http://seaborn.pydata.org/)
* [statsmodels v0.9.0](https://www.statsmodels.org/stable/index.html)

Note: if you run into errors indicating you miss a package, either enter "pip install packagename" in a terminal or - if in the notebook - 
insert a cell and write "!pip install packagename".

#### R
* [lmerTest v3.0-1](https://cran.r-project.org/web/packages/lmerTest/index.html) e.g. `install.packages("lmerTest")`
* [lme4 v1.1-19](https://cran.r-project.org/web/packages/lme4/index.html)   
* [effects v4.0-0](https://cran.r-project.org/web/packages/effects/index.html)
* [ggplot2 v3.1.0](https://ggplot2.tidyverse.org/)  
* [QuantPsyc v1.5](https://cran.r-project.org/web/packages/QuantPsyc/index.html)
* [plyr v1.8.4](https://cran.r-project.org/web/packages/plyr/index.html)    
* [reshape2 v1.4.3](https://cran.r-project.org/web/packages/reshape2/index.html)

Note: if you run into errors indicating you miss a package, enter "install.packages(packagename)" in a new line in RStudio.

***
2019 | Steven Tompson