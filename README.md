# Overview:

Results are stored in Models > PyTorch > model_checkpoints > Results.xlsx
### 0. Setting up Environment with Anaconda
conda create --name <name> --file TS_MCC_env

### 1. Data Generation from Raw
Data is available from \
# INSERT LINK TO DATA
Dataprocessing > GetAllData\\
set RAW_DATA_pathway to the directory containing the raw rhd data\
set save_pathway to the directory where you want to save processed data\
set Rat_num\
Change RATDF_files, RATPF_files, RATPrick_files to refer to the files \
within the raw data folders you want to process
set signal_length to desired size, \
if crashing occurs due to RAM limitations increase the variable "total_section"\
Run the Code\

### 2. Converting to .pt/np
Dataprocessing > Convert_mat_to_np.ipynb\
Will convert .mat files into .npy. Will generate a signal file for each\
CAP in the .mat\
NOTE: Can adjust this easily to produce .pt or can use a separate script\
NOTE: May have to adjust for loop depending on number of processed files produced

### 3. Three Cross Fold Validating
Models > PyTorch > Get_Three_fold_cross_validation.ipynb\
Will take a directory of .npy or .pt files and generate three cross fold \
validation splits\
method defaults to "min_class" which undersamples to balance class sizes\
simply set method = "Normal" to avoid this

### 4. Data Augmentation
Models > PyTorch > Data_Augmentation.ipynb\
Will apply three types of data augmentation balance classes

### 5. Training
Models > PyTorch > Training.ipynb\
Specify model within script, point to directory with data and run script.

### 6. Evaluate
Models > PyTorch > Val_Test_Eval.ipynb\
Specify model within script, point to directory with data, \
point to weights and run script.