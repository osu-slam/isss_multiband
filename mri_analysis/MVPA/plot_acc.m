%% plot_acc

function plot_acc(subj, study, dd, ss, class)
%% Check input
if ~isstruct(subj) || length(subj) ~= 1
    error('Input (subj, study, dd) where subj is a SINGLE struct')
end

if ~isstruct(study)
    error('Input (subj, study, dd) where study is struct')
end

if ~isnumeric(dd)
    error('Input (subj, study, dd) where dd specifies which design')
end

if ~ischar(class)
    error('Input (subj, study, dd, class) where class specifies which classifier to plot!')
end

%% Pathing and parameters
radius = study.mvpa.radius; 
design = study.design(dd); 
scan   = study.scan(ss); 
scanname = strsplit(scan.runname, '_'); scanname = scanname{1}; 

dir_subj   = fullfile(study.path, 'data', subj.name); 
dir_MVPA   = fullfile(dir_subj, 'MVPA'); 
dir_design = fullfile(dir_subj, 'design', [scanname '_' design.name]); 
dir_docs   = fullfile(study.path, 'docs'); 
mask_file  = fullfile(dir_design, 'mask.nii'); 

%% Code     
acc_file = fullfile(dir_MVPA, ...
    [subj.name '_' scanname '_' design.name '_beta_' class '_rad' num2str(radius) '.nii']); 

Vacc = spm_vol(acc_file);
yacc = spm_read_vols(Vacc);

acc_vec = yacc(~isnan(yacc));
acc_mean = mean(acc_vec);
acc_median = median(acc_vec);

%% Figure 
figure
histogram(acc_vec)

hold on;
title(['Histogram of accuracy: ' subj.name])
line([0 0], ylim, 'LineWidth', 2, 'Color', 'r');
line([acc_mean, acc_mean], ylim, 'LineWidth', 2, 'Color', 'g');
line([acc_median, acc_median], ylim, 'LineWidth', 2, 'Color', 'b');
legend('acc', 'zero', 'mean', 'median')
xlabel('Accuracy - 50%')

filename = fullfile(dir_docs, [subj.name '_' scanname '_' class]);
saveas(gcf, filename, 'png')
hold off

end