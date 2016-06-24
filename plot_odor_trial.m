function plot_odor_trial(h, trace, stim, sampRate, sub)
    
    stim = (stim - min(stim)) / max(stim);
    stim(stim < 0.5) = NaN;
    
%     stim = (stim * max(trace)) + (0.05 * max(trace));
    stim =  stim * 2.5 *  mean(abs(trace));
    
    figure(h)
%     clf
%     subplot(3,1,sub)
    plot((1/sampRate):(1/sampRate):(length(trace)/sampRate), trace)
    hold on
       plot((1/sampRate):(1/sampRate):(length(stim)/sampRate), stim, 'k', 'linewidth', 5);
    axis tight
    hold off
    xlabel('Seconds')
end