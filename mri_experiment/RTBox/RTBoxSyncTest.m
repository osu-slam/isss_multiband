function RTBoxSyncTest(secs, interval, nSyncTrial)
% RTBoxSyncTest (measuringSecs, interval, nSyncTrial)
% 
% This tests the reliability of the synchronization between the computer and
% device clocks. If the variation range is within 1 ms, it should be okay for
% most RT measurement. A good setup could achieve a result with range less than
% 0.05 ms. 
% 
% If the variation before drift correction is large (1m within 30 secs), it is
% an indication to run RTBox('ClockRatio').

% 080501 wrote it (xiangrui.li@gmail.com)
% 110401 change xlabel from trials to seconds
% 111001 remove dependence on robustfit
% 141225 reverse residual sign, and use lscov to replace polyfit
% 170315 use 'clockdiff' rather than 'clear'
% 170402 Simplify the result display by removing confusing numbers

if nargin<1 || isempty(secs), secs = 30; end % default measuring time
persistent t obj h nSync
switch secs
    case 'stopfcn' % executed when timer stops for whatever reason
        try % fit a line and plot residual
            % slope is clock ratio, residual is the variation
            n = size(t,1);
            x = t(:,2) - t(1,2); % boxSecs
            y = (t(:,1) - mean(t(:,1))) * 1000; % GetSecs-boxSecs in ms
            b = polyfit(x, y, 1);
            r = y - (x*b(1) + b(2)); % residual
            se = sqrt(r'*r/(n-2)) / (std(x) * sqrt(n-1));

            figure(9); 
            set(gcf, 'color', 'white', 'userdata', t, ...
                'filename', 'RTBoxSyncTestResult.fig');
            plot(x, [y r], '.');
            set(gca, 'box', 'off', 'tickdir', 'out', 'ylim', [-1 1]);
            xlabel('Seconds'); ylabel('Clock diff variation (ms)');
            legend({['Before drift removal: ' sprintf('%.2g', max(y)-min(y))]
                    ['After drift removal: ' sprintf('%.2g', max(r)-min(r))]}, ...
                    'location', 'best')
            if abs(b(1)/se)>6 % arbituary T
                text(0.2, 0.2, 'Recommend to run RTBox(''ClockRatio'')', 'Unit', 'normalized');
            end
        catch me
            fprintf(2, '%s\n', me.message);
            fprintf('Variation range %.2g | %.2g ms (before | after removing drift)\n', ...
                max(y)-min(y), max(r)-min(r));
            if abs(b(1))>0.01
                text(0.2, 0.2, 'Recommend to run RTBox(''ClockRatio'')', 'Unit', 'normalized');
            end
        end
        RTBox close;
        stop(obj); delete(obj); clear obj;  % done, stop and close timer
        try close(h); end %#ok, try to close Measuring dialog
        munlock;  % unlock it from memory
    case 'timerfcn'  % executed at each timer call
        t4 = RTBox('clockDiff', nSync);
        i = find(isnan(t(:,1)), 1);
        t(i,:) = t4(1:2); % update a row
    otherwise  % secs for timer: set and start timer
        mfile = mfilename;
        if mislocked
            fprintf(2,' %s is already running.\n', mfile); 
            return; 
        end
        if nargin<3 || isempty(nSyncTrial), nSync = 20; 
        else nSync = nSyncTrial; 
        end
        if nargin<2 || isempty(interval), interval = 1; end % timer interval
        RTBox('clear'); % open device if hasn't
        repeats = max(3, round(secs/interval)); % # of trials
        
        % define timer: functions, interval and trials
        obj = timer('TimerFcn', [mfile '(''timerfcn'')'], ...
            'StopFcn', [mfile '(''stopfcn'')'], ...
            'ExecutionMode', 'FixedRate', ...
            'Period', interval, 'TasksToExecute', repeats);
        t = nan(repeats, 2);
        start(obj); % start timer

        str = datestr(now+(repeats-1)*interval/86400,'HH:MM:SS PM');
        str = sprintf('The result will be shown by %s.\nDon''t quit Matlab till then.',str);
        h = helpdlg(str, 'Measuring ...');

        mlock; % lock m file, avoid being cleared
end
