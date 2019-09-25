########################################################################################################
########################################################################################################
### Step 1: Set up ###
########################################################################################################
########################################################################################################
rm(list=ls())

## Load packages
library(reshape2)
library(plyr)
library(QuantPsyc)
library(ggplot2)
library(effects)
library(lme4)
library(lmerTest)

## Set Working Directory to be location where CSV files are stored (change to the location you downloaded data to)
wd<-"/Users/steventompson/Git/tompson_netlearn_fmri/data/csv_files/"

## Load trial-level behavioral data

tdf<-read.csv(paste(wd,"tompson_netlearn_fmri_trial_data.csv",sep=""))

tdfNS<-tdf[tdf$Cond=="NS",]
tdfSoc<-tdf[tdf$Cond=="Soc",]
head(tdf) 


########################################################################################################
########################################################################################################
### Step 2: Exclude bad subjects and trials ###
########################################################################################################
########################################################################################################

#################################################
### check summary data for each subject to determine who to exclude
#################################################

print('')
print('Combined Accuracy')
print(tapply(tdf$correct,tdf$pID,function(i){sum(i,na.rm=T)/2000})) #percent correct trials

print('')
print('Non-Social Accuracy')
print(tapply(tdfNS$correct,tdfNS$pID,function(i){sum(i,na.rm=T)/1000})) #percent correct trials

print('')
print('Social Accuracy')
print(tapply(tdfSoc$correct,tdfSoc$pID,function(i){sum(i,na.rm=T)/1000})) #percent correct trials

#################################################
### Exclude subjects with fewer than 70% correct responses

#NOTE: 18 subjects had greater than 70% correct
#NOTE: 2 subjects missed greater than 50% of trials (20=43%, 28=24%)
#NOTE: 2 subjects missed greater than 30% of trials (15=60%, 37=64%) but will keep them in for now
#NOTE: 1 subject had to abort because they were feeling claustrophobic (13)
#NOTE: 1 subject had to be excluded due to brain artifact (4=missing back part of parietal cortex)
#################################################

tdf<-subset(tdf,pID!= 1)
tdf<-subset(tdf,pID!= 4)
tdf<-subset(tdf,pID!= 13)
#tdf<-subset(tdf,pID!= 15)
tdf<-subset(tdf,pID!= 20)
tdf<-subset(tdf,pID!= 28)
#tdf<-subset(tdf,pID!= 37)


#################################################
### Exclude bad trials and trials we won't use in analyses
#################################################

#remove incorrect trials
tdf2<-subset(tdf,tdf$correct_raw==1)

#remove altered trials
tdf2<-subset(tdf2,tdf2$altered=="False")


#Get rid of impossible reaction times (i.e., less than 100, >1500)
tdf2 <- subset(tdf2, rt_raw < 1500)
tdf2 <- subset(tdf2, rt_raw > 100)

##remove Rts > 3 Sd from the mean
tdf2 = ddply(tdf2, .(pID), transform, sRT = scale(rt_raw))
tdf2= subset(tdf2, abs(sRT) < 3)

#check # of transition trials left after cleaning
print('# of transition trials')
print(tapply(tdf2$grouping,tdf2$pID,function(i){sum(i=="transition",na.rm=T)})) #number of transition trials

#convert trial grouping variable to a factor
tdf2$grouping <- factor(tdf2$grouping, levels = c("x", "transition"))


rm(tdf,tdfNS,tdfSoc)

print('')
print(paste('Total # of subjects:',length(unique(tdf2$pID))))



########################################################################################################
########################################################################################################
### Step 3: Load and merge neural data ###
########################################################################################################
########################################################################################################


#################################################
### Load data
#################################################

#Load IDs to link behavioral and neural data
subjIDs<-read.csv(paste(wd,"netLearn_IDs_26subjs.csv",sep="/"))

#Load head motion data file
hmData<-read.csv(paste(wd,"netLearn_headMotion_26subjs.csv",sep="/"))

#Define function for creating df
create_df<-function(dname1,dname2,df1,df2){
  filepath<-paste(wd,"netLearn_",dname1,
                  "_zscores_26subjs_",dname2,".csv",sep="")
  new.df<-read.csv(filepath,header=T,as.is=T)
  new.df<-cbind(df1,new.df)
  new.df<-merge(new.df,df2,by="pID")
  new.df$task<-dname1
  return(new.df)
}

# Load neural data and merge with behavioral/head motion data
combData_gc<-create_df(dname1="combData",dname2="sighubs_global_conn",df1=subjIDs,df2=hmData)
diffData_gc<-create_df("diffData","sighubs_global_conn",subjIDs,hmData)
nsData_gc<-create_df("NSData","sighubs_global_conn",subjIDs,hmData)
socData_gc<-create_df("SocData","sighubs_global_conn",subjIDs,hmData)

combData_ss<-create_df("combData","sighubs_to_sighubs",subjIDs,hmData)
diffData_ss<-create_df("diffData","sighubs_to_sighubs",subjIDs,hmData)
nsData_ss<-create_df("NSData","sighubs_to_sighubs",subjIDs,hmData)
socData_ss<-create_df("SocData","sighubs_to_sighubs",subjIDs,hmData)


#################################################
# Combine neural dataframes
#################################################

longData_gc<-rbind(socData_gc,nsData_gc)
longData_ss<-rbind(socData_ss,nsData_ss)

longData_gc$task<-gsub('Data','',longData_gc$task)
longData_ss$task<-gsub('Data','',longData_ss$task)

#################################################
# Convert key variables to z-scores
#################################################

create_zscores<-function(varlist,df1){
  newlist<-c()
  for(var in varlist){
    newvar<-paste(var,"z",sep="_")
    newlist<-c(newlist,newvar)
    df1[,newvar]<-as.numeric(Make.Z(df1[,var]))
  }
  return(list(newlist,df1))
}

hublist1<-c("combhubs_global","Hippocampus_L_global","Hippocampus_R_global",
            "diffhubs_global","TPJ_L_global","TPJ_R_global",
            "diffhubs_ns_global","dmPFC_L_global","dmPFC_R_global","lPFC_L_global","lPFC_R_global")

hublist2<-c("Hippocampus_L_X_combhubs","Hippocampus_L_X_nshubs","Hippocampus_L_X_sochubs",
            "Hippocampus_R_X_combhubs","Hippocampus_R_X_nshubs","Hippocampus_R_X_sochubs",
            "ws_combhubs","combhubs_X_nshubs","combhubs_X_sochubs",
            "ws_nshubs","nshubs_X_sochubs","ws_sochubs")

zscores<-create_zscores(hublist1,longData_gc)
zvars<-zscores[[1]]
longData_gc<-zscores[[2]]

zscores<-create_zscores(hublist2,longData_ss)
zvars<-zscores[[1]]
longData_ss<-zscores[[2]]

#################################################
# Merge neural and trial-level data
#################################################

combData2_gc<-merge(tdf2,longData_gc,by.x = c("pID","Cond"),by.y=c("pID","task"))
combData2_ss<-merge(tdf2,longData_ss,by.x = c("pID","Cond"),by.y=c("pID","task"))

head(combData2_gc)


########################################################################################################
########################################################################################################
### Step 4: Behavioral analyses ###
########################################################################################################
########################################################################################################

#################################################
### Clean trial df
#################################################

# Create function to clean df
clean_trial_df<-function(df1){
  # Add order info to trial-level df
  df1$order<-NA
  for(subj in unique(df1$pID)){
    df1$order[df1$pID==subj]<-subjIDs$CondNum[subjIDs$pID==subj]
  }
  
  #z-score variables
  df1$strial<-as.numeric(scale(df1$trialNum))
  
  #contrast coding
  contrasts(df1$grouping) <- contr.helmert(2) 
  contrasts(df1$grouping)
  
  df1$Cond<-factor(df1$Cond)
  contrasts(df1$Cond) <- contr.helmert(2) 
  contrasts(df1$Cond)
  
  df1$order<-factor(df1$order)
  contrasts(df1$order) <- contr.helmert(2) 
  contrasts(df1$order)
  
  #log-transform variables
  df1$rt_log<-log(df1$rt_raw)
  df1$rt_log<-df1$rt_log-mean(df1$rt_log)
  return(df1)
}

tdf2<-clean_trial_df(tdf2)

#################################################
### Compute xixed effects model for Grouping (Node Type) x Cond (Network Type) X Order (Social First vs. Non-Social First) x Trial Number
#################################################

mm1_log<- lmer(rt_log ~  grouping*Cond*order*strial + (1 + grouping + Cond + strial| pID), data = tdf2)

print('Both Tasks')
summary(mm1_log)$coefficients

#################################################
### Compute mixed effects model for Social and Non-Social Networks separately
#################################################

socData2<-tdf2[tdf2$Cond=="Soc",]
nsData2<-tdf2[tdf2$Cond=="NS",]

mm1_log_ns= lmer(rt_log ~  grouping*order*strial + (1 + grouping*strial | pID), data = nsData2)
mm1_log_soc= lmer(rt_log ~  grouping*order*strial + (1 + grouping*strial | pID), data = socData2)

print('Non-Social Task')
summary(mm1_log_ns)$coefficients

print('Social Task')
summary(mm1_log_soc)$coefficients

#################################################

