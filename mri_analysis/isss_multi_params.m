%% YA_FST_params
% Parameter info for YA_FST
% 
% MM/DD/YY: CHANGELOG
% 02/10/20: Changelog started. Added study structure with relevant
%   information re: the experiment. MJH
% 02/24/20: No silent event anymore, updating contrasts. 
% 02/29/20: Added nscans param to subjects--number of images BEFORE
%   dropping. Updated scan info with a few other details. 
% 03/09/20: Added subjects 2 and 3, added appa field to distinguish between
%   AP-PA files acquired for RSFC and task-based EPIs. 
% 03/10/20: New design, includes CONN regressors. Added conn field. 
% 03/26/20: Cloned for isss_multi. The ultimate test for my code! 

%% Study info
study.name = 'isss_multi'; 
study.path = 'C:\Users\heard\Documents\MATLAB\mri_data\isss_multi'; 

study.scan(1).runname = 'hybrid_run'; 
study.scan(1).TR   = 1; % in seconds
study.scan(1).tert = 39.5993; % in milliseconds
study.scan(1).epis = 10; % in TRs
study.scan(1).silence = 4; % in TRs
study.scan(1).first   = 11; % in TRs
study.scan(1).numscans = 180; % 
study.scan(1).regnum = 14; 
% study.scan(1).regnum = 14; 

study.scan(2).runname = 'isss_run'; 
study.scan(2).TR   = 2; % in seconds
study.scan(2).tert = 19.5250; % in milliseconds
study.scan(2).epis = 5; % in TRs
study.scan(2).silence = 2; % in TRs
study.scan(2).first   = 6; % in TRs
study.scan(2).numscans = 90; % 
study.scan(2).regnum = 8; 
% study.scan(2).regnum = 8; 

study.scan(3).runname = 'multiband_run'; 
study.scan(3).TR   = 1; % in seconds
study.scan(3).tert = 39.5993; % in milliseconds
study.scan(3).epis = 10; % in TRs
study.scan(3).silence = 4; % in TRs
study.scan(3).first   = 15; % in TRs
study.scan(3).numscans = 248; % 
study.scan(3).regnum = 18; 
% study.scan(3).regnum = 18; 

study.events.all  = 16; 
study.events.each = 4; 

study.anat = 'MPRAGE.nii'; 
study.prefix = 'swu'; 

study.mvpa.radius = 2; % voxel radius for searchlight
study.mvpa.prefix = 'wu'; 

study.results.thresh = 0.001; 
study.results.extent = 20;
study.results.dest   = '/users/PAS1342/osu9912/fmri/isss_multi/isss_multiband_122119/docs/p001_k20'; 

%% Designs
study.design(1).name    = 'allevents_nophysio'; 
study.design(1).physio  = 0; 
study.design(1).correct = 0; 
study.design(1).conn    = 0; % first 2 PCs from WM and CSF
study.design(1).cond    = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR',  ...
    }; 
study.design(1).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    }; 
study.design(1).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    ]; 

study.design(2).name    = 'allevents_physio'; 
study.design(2).physio  = 1; 
study.design(2).correct = 0; 
study.design(2).conn    = 0; % first 2 PCs from WM and CSF
study.design(2).cond    = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR',  ...
    }; 
study.design(2).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    }; 
study.design(2).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    ]; 

study.design(3).name     = 'groupreg_physio'; 
study.design(3).physio   = 1; 
study.design(3).correct  = 0; 
study.design(3).groupreg = 1;
study.design(3).conn = 0; % first 2 PCs from WM and CSF
study.design(3).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(3).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    }; 
study.design(3).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    ]; 

study.design(4).name     = 'groupreg_conn'; 
study.design(4).mvpa     = 0;
study.design(4).physio   = 0; 
study.design(4).correct  = 0; 
study.design(4).groupreg = 1;
study.design(4).conn = 1; % first 2 PCs from WM and CSF
study.design(4).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(4).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    'OR_NOI', ...
    'SR_NOI', ...
    'LNG', ...
    }; 
study.design(4).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    -1 1 0; ...
    -1 0 1; ...
    0 1 1; ...
    ]; 

study.design(5).name     = 'groupreg_conn_MVPA'; 
study.design(5).mvpa     = 1;
study.design(5).physio   = 0; 
study.design(5).correct  = 0; 
study.design(5).groupreg = 1;
study.design(5).conn = 1; % first 2 PCs from WM and CSF
study.design(5).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(5).con.name = [];
study.design(5).con.vec  = []; 

study.design(6).name     = 'groupreg_conn_v2'; 
study.design(6).physio   = 0; 
study.design(6).correct  = 0; 
study.design(6).groupreg = 1;
study.design(6).dummyscans = 'first'; 
study.design(6).conn = 1; % first 2 PCs from WM and CSF
study.design(6).cond = { ...
    'NOI', ...
    'SIL', ...
    'LNG', ...
    }; 
study.design(6).con.name = { ...
    'NOI_SIL', ...
    'LNG_NOI', ...
    'NOI', ...
    'SIL', ...
    'LNG', ...
    }; 
study.design(6).con.vec = [ ...
    1 -1 0; ...
    -1 0 1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    ]; 

study.design(7).name     = 'groupreg_conn_13subj'; 
study.design(7).mvpa     = 0;
study.design(7).physio   = 0; 
study.design(7).correct  = 0; 
study.design(7).groupreg = 1;
study.design(7).conn = 1; % first 2 PCs from WM and CSF
study.design(7).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(7).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    'OR_NOI', ...
    'SR_NOI', ...
    'LNG', ...
    }; 
study.design(7).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    -1 1 0; ...
    -1 0 1; ...
    0 1 1; ...
    ]; 

study.design(8).name     = 'groupreg_conn_MVPA_unsmoothed'; 
study.design(8).mvpa     = 1;
study.design(8).physio   = 0; 
study.design(8).correct  = 0; 
study.design(8).groupreg = 1;
study.design(8).conn = 1; % first 2 PCs from WM and CSF
study.design(8).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(8).con.name = [];
study.design(8).con.vec  = []; 

study.design(9).name     = 'noacc_conn'; 
study.design(9).mvpa     = 0;
study.design(9).physio   = 0; 
study.design(9).correct  = 0; 
study.design(9).groupreg = 0;
study.design(9).conn = 1; % first 2 PCs from WM and CSF
study.design(9).cond = { ...
    'NOI', ...%     'SIL', ...
    'OR', ...
    'SR', ...
    }; 
study.design(9).con.name = { ...%     'NOI_SIL', ...
    'LNG_NOI', ...
    'OR_SR', ...
    'NOI', ...
    'OR', ...
    'SR', ...
    'OR_NOI', ...
    'SR_NOI', ...
    'LNG', ...
    }; 
study.design(9).con.vec = [ ...%     1 -1 0 0; ...
    -2 1 1; ...
    0 1 -1; ...
    1 0 0; ...
    0 1 0; ...
    0 0 1; ...
    -1 1 0; ...
    -1 0 1; ...
    0 1 1; ...
    ]; 

% study.design(2).name    = 'all_events_conn_MVPA'; 
% study.design(2).physio  = 0; 
% study.design(2).correct = 0; 
% study.design(2).conn    = 1; % first 2 PCS from WM + CSF
% study.design(2).cond    = { ...
%     'NOI', ...
%     'SIL', ...
%     'OR', ...
%     'SR',  ...
%     }; 
% study.design(2).con.name = {};
% study.design(2).con.vec = [];

%% Subjects
subj(1).name   = 'JV_30Aug17';
subj(1).runs   = [1 1 1];  
subj(1).rename = {};
subj(1).physio = 1; 
subj(2).name   = 'EH_10Oct17'; 
subj(2).runs   = [2 2 2];  
subj(2).rename = {};
subj(2).physio = 1; 
subj(3).name   = 'JC_13Oct17'; 
subj(3).runs   = [2 2 2];  
subj(3).rename = {};
subj(3).physio = 1; 
subj(4).name   = 'SS_16Oct17'; 
subj(4).runs   = [2 2 2];  
subj(4).rename = {};
subj(4).physio = 1; 
subj(5).name   = 'JD_18Oct17'; 
subj(5).runs   = [2 2 2];  
subj(5).rename = {};
subj(5).physio = 1; 
subj(6).name   = 'KN_27Oct17'; 
subj(6).runs   = [2 2 2];  
subj(6).rename = {};
subj(6).physio = 1; 
subj(7).name   = 'ZG_03Nov17'; 
subj(7).runs   = [2 2 2];  
subj(7).rename = {};
subj(7).physio = 0; 
subj(8).name   = 'CS_11Dec17'; 
subj(8).runs   = [2 2 2];  
subj(8).rename = {};
subj(8).physio = 1; 
subj(9).name   = 'CC_04Jan18'; 
subj(9).runs   = [2 2 2];  
subj(9).rename = {};
subj(9).physio = 0; 
subj(10).name   = 'KB_19Jan18'; 
subj(10).runs   = [2 2 2];  
subj(10).rename = {};
subj(10).physio = 1; 
subj(11).name   = 'DM_05Feb18'; 
subj(11).runs   = [2 2 2];  
subj(11).rename = {};
subj(11).physio = 1; 
subj(12).name   = 'KC_21Feb18'; 
subj(12).runs   = [2 2 2];  
subj(12).rename = {};
subj(12).physio = 1; 
subj(13).name   = 'MA_12Apr18'; 
subj(13).runs   = [2 2 2];  
subj(13).rename = {};
subj(13).physio = 1; 
subj(14).name   = 'KV_27Apr18'; 
subj(14).runs   = [2 2 2];  
subj(14).rename = {};
subj(14).physio = 1; 
