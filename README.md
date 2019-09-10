# Analysis for Tompson, Kahn, Falk, Vettel, & Bassett (under review)

Data and analysis code for *2.	Tompson, S.H., Kahn, A.E, Falk, E.B., Vettel., J.M., & Bassett, D.S. 
Functional brain network architecture supporting the learning of social networks in humans. 
Manuscript under review.*


***

### Code
* Step0: code with prefix "Step0" is not linked to any raw data to protect participant privacy but shows the steps 
used to extract the connectivity matrices and behavioral performance.
* Step0_Preprocessing.ipynb takes the raw 4-D fMRI images and corrects for confounds and normalizes the images to the MNI template
* Step0_WB_PPI.ipynb takes the preprocessed brain data and computes PPI connectivity scores for each node with every other node
* Step0_Get_Zscores.ipynb takes the extracted connectivity matrices and computes z-scored node strength metrics for each node
as well as z-scored connectivity matrices for each node

* Step1_Hub_Analyses.ipynb takes the z-scored connectivity metrics (both node strength scores and connectivity matrices),
and reproduces the node strength, hub system, and hub-to-hub connectivity analyses
* Step2_Behavioral_Results.ipynb reproduces the main mixed effect models for the behavioral results as well as 
the moderating effect of connectivity on behavior.
* Supp_Analyses_Pt1.ipynb reproduces the behavioral analyses from the supplementary results section
* Supp_Analyses_Pt2.ipynb reproduces the neural GLM analyses from the supplementary results section

### Data

* files in ../data/brain_atlas provide information for the combined Schaefer/Harvard-Oxford atlas that was used to define nodes
* file in ../data/timeseries is just a sample timeseries used to visualize the brain activation for Figure 1
* files in ../data/supp_analyses/netLearn_glm contain results for the second-level contrasts included in the supplement

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
* [seaborn v0.9.0](http://seaborn.pydata.org/)
* [scipy v1.1.0](https://www.scipy.org/)
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
2018 | Steven Tompson