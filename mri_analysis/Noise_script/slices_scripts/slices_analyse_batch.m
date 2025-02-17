% ANALYSE YOUR FMRI DATA FOR SLICE NOISE
% this it the first script which must be run on all data sets
%
%  written by Antonia Hamilton, Dartmouth College, 2007
%
%  Added option to choose subjects and batch slices_analyse (feb07, ddw)
%  Assumes your bold files are under subject_id/FUNCTIONAL/bold1_0001.img


clear all, close all
spm_defaults  %% assume spm2

disp('Welcome to The Slices Noise Analysis Progam')
disp('  ')
    
try
  load slices_def
catch
  disp('Could not load slices_def.mat')
  disp('Please run the slices_defaults program')
  disp('and make sure you are in the right directory')
  return
end

%templatedir = [pwd,filesep,'noise_templates'];
%if(~exist([templatedir,filesep,'xEPI.img']))
%  disp(['Cannot find EPI template image in ',templatedir])
%  return
%end
%if(~exist([templatedir,filesep,'xwhole_brain.img']))
%  disp(['Cannot find mask template image in ',templatedir])
%  return
%end



%tmp = spm_get(1,'.img','Select the first image of the first block')
%[pth,nam,ext] = fileparts(tmp);

%disp('Assuming all images are called bold*.img')
%nses = input('How many sessions? ')

%Added by ddw for batching
%**************************************************************************
% Session chooser
nses = input('How many sessions? ')
disp('Please select subjects to run slices_analyse on')

%Subject chooser
dir_only = dir('./');
dir_only([dir_only.isdir] == 0)=[];  %eliminates files from the dir_only array
dir_only(1:2.0)=[]; %eliminates the . and .. from the dir_only array
str={dir_only.name};
str=sort(str);
[list] = listdlg('PromptString','Which subjects?',...
                      'Name','Subject Selection','ListString',str);
subjects = str(list);
subjects = sort(subjects);

%Turn off annoying warnings
warning off MATLAB:divideByZero;
warning off

for i = 1:length(subjects)
    tmp = [pwd,'/',char(subjects{i}),'/FUNCTIONAL/bold1_0001.img']; %assumes basic directory and bold naming conventions
    [pth,nam,ext] = fileparts(tmp);
    outname = [pwd,'/',char(subjects{i}),'/',char(subjects{i}),'_noise'];

    
%**************************************************************************
for ses = 1:nses
  P = spm_get('Files',pth,['bold',num2str(ses),'*.img']);

  V = spm_vol(P);
  nslice = V(1).dim(3);
  nscan = length(V);
  
  %% realign data
  if (1)
    disp('realigning the files now')
    spm_realign(V);
  else
    disp('skipping realignment')
  end
  [pth,nam,ext] = fileparts(V(1).fname);
  
  Rnames = fullfile(pth,['rp_',nam,'.txt'])
  ra = load(Rnames);
  
  disp(['Realignment done for session ',num2str(ses),' now reslicing'])
  
  %% reslice data so we can get the mean
  spm_reslice(V);
  %disp('skipping reslice')
  
  %% load in realigned data
  Pr = spm_get('Files',pth,['rbold',num2str(ses),'*.img']);
  Vr = spm_vol(Pr);
  
  Vo = spm_vol(spm_get('Files',pth,['meanbold',num2str(ses),'*.img']));

  %% get characteristics of mean image
  vox_size = diag(Vo.mat); 
  vox_size = vox_size(1:3);

  d = Vo.dim(1:3); 
  % corners in voxel-space
  c = [ 1    1    1    1 
        1    1    d(3) 1 
        1    d(2) 1    1 
        1    d(2) d(3) 1
        d(1) 1    1    1 
        d(1) 1    d(3) 1
        d(1) d(2) 1    1 
        d(1) d(2) d(3) 1 ]'; 
  % corners in world-space
  tc = Vo.mat(1:3,1:4)*c; 
  % reflect in x if required
  if spm_flip_analyze_images; tc(1,:) = -tc(1,:); end; 
  
  % bounding box (world) min and max
  mn = min(tc,[],2)'; 
  mx = max(tc,[],2)'; 
  bb = [mn; mx];
  bb = bb-0.1;

  %% copy mask locally
  eval(['!cp ',sdef.brain_template,' ',...
        pth,filesep,'mask',num2str(ses),'.img'])
  eval(['!cp ',sdef.brain_template(1:end-4),'.hdr ',...
        pth,filesep,'mask',num2str(ses),'.hdr'])
%  eval(['!cp ',templatedir,filesep,'xEPI.img ',... 
%        pth,filesep,'EPI',num2str(ses),'.img'])
%  eval(['!cp ',templatedir,filesep,'xEPI.hdr ',... 
%        pth,filesep,'EPI',num2str(ses),'.hdr']) 
   
  %% normalise EPI template to mean BOLD image
  
  %% load up template
  Ve = spm_vol(sdef.epi_template);
  
  defaults.normalise.write.vox = vox_size';   %% voxel size 
  defaults.normalise.write.bb =  bb;  %% my bounding box
  defaults.normalise.write.interp = 7; 
  defaults.normalise.write.wrap = [0 0 0];
  
  % Normalise template to mean EPI image
  matname  = [pth,filesep,'norm_bold',num2str(ses),'.mat'];
  params   = spm_normalise(Vo,Ve,matname,'','',defaults.normalise.estimate);  
 
  %% apply normalisation to mask image
  Vm = spm_vol(spm_get('Files',pth,['mask',num2str(ses),'.img'])) 
  Vn = spm_write_sn(Vm,params,defaults.normalise.write);
  spm_write_vol(Vn,Vn.dat);
  
  disp(['Mask created for sesssion ',num2str(ses)])

  %-------------------------------------------------------------

 %% work out good neighbours
 neigh = repmat(-5:2:5,nscan,1)+repmat(1:nscan,6,1)';
 neigh(neigh<1) = NaN;
 neigh(neigh>nscan) = NaN;
 
 for kk=1:nscan
        
   %% calculate good neighbours
   df = abs(ra-repmat(ra(kk,:),nscan,1));
   trans = sum(df(:,1:3),2);
   rot = sum(df(:,4:6),2);
   
   good = find(trans<1 & (rot*180/pi)<1);
 
   overlap = intersect(good,neigh(kk,:));
   
   if(length(overlap)<3)  %% really bad scans
     neigh(neigh==kk) = NaN;     
     neigh(kk,:) = NaN;
   elseif(length(overlap<6))  %% moderate bad scans
     missing = setdiff(neigh(kk,:),good);
     for i=1:length(missing)
       mind = find(neigh(kk,:)==missing(i));
       neigh(kk,mind) = NaN;
     end
   end
 end
 
  %% now look for noise within mask
 M = spm_vol(spm_get('Files',pth,['wmask',num2str(ses),'.img']));
 M.dat = spm_read_vols(M);
 
 disp('Now searching every file for noise')
 
 for kk=1:nscan  %% for every input file
   
   gv(kk) = spm_global(V(kk));
   
   [dat1,loc] = spm_read_vols(V(kk),1);  %% read with zero masking   
   nn = neigh(kk,:);
   
   for jj=1:length(nn)  %% read some neighbours
     
     if(isfinite(nn(jj)))  %% for good neighbours
       jind = nn(jj);
       
       [dat2,loc] = spm_read_vols(V(jind),1);  %% read with zero masking
       
       for i=1:nslice
         slice1 = squeeze(dat1(:,:,i));
         slice2 = squeeze(dat2(:,:,i));
         msk = squeeze(M.dat(:,:,i));
         
         df = (slice1-slice2).*(msk>0.5);        
         scan_noise(jj,i) = nanmean(abs(df(msk>0.5)));
       end
     else  %% for bad neighbours
       scan_noise(jj,1:nslice) = NaN;
     end
   end
   noise(:,kk) = nanmean(scan_noise)';
   
   kk
 end
 
 %% save all important info
 a(ses).P = P;
 a(ses).noise = noise;
 a(ses).mask = M;
 a(ses).ra = ra;
 a(ses).neigh = neigh;
 
 slices_summary(a(ses),[outname,'.ps'])
 
 pause(0.1)
 
end

save(outname,'a')
% eval(['print -dpsc2 -painters ',outname,'.ps']) %turned this off
% otherwise it overwrites output for previous runs.
disp(['Noise analysis saved to ',outname,'.mat and printed to ',outname,'.ps'])

end