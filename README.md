# MEGAmini_UTSC_hyperparam_search
This code, written with MATLAB, describes the offline hyperparameter searching of non-linear activation (NLA) approximation based on conditional polynomials. (Related paper: ISSCC'2025, entitled "MEGA.mini: A Universal Generative AI Processor with a New Big/Little Core Architecture for NPU").

The hyperparameter searching performs a grid search of hyperparameters to approximate NLAs such as tanh, SiLU, and GELU. 
This code is used before a user or an engineer utilizes the MEGA.mini processor or core for AI acceleration.
Even though the new NLA has been developed, this MATLAB code can be utilized to find out a new approximation function.
The hyperparameter found with this code will be used in the MEGA.mini processor by programming built-in (on-chip) registers that store hyperparameters for NLA acceleration.
(Unified Tensor Streaming Core (UTSC) uses the hyperparameters for NLA acceleration.)
