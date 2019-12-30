function [alignedData, peakInd] = peak_align(data)

nSamples = size(data, 1);
nTraces = size(data, 2);

for iTrace = 1:nTraces
    peakInds(iTrace) = find(max(data(:,iTrace)) ==  data(:,iTrace), 1);
end

medPeakInd = floor(median(peakInds));
peakDiff = peakInds - medPeakInd;

% peakDiff - corresponds to the number of data points that trace should be
% shifted forward or backward. Traces with negative peakDiff values are to
% be shifted forward, while traces with positive peakDiff values are to be
% shifted backward.

% if min(peakDiff) < 0
%     peakDiff = peakDiff + abs(min(peakDiff)) + 1;
%     peakInd = medPeakInd + abs(min(peakDiff)) + 1;
% elseif min(peakDiff) >= 0
    peakDiff = peakDiff - min(peakDiff) + 1;
    peakInd = medPeakInd - min(peakDiff) + 1;
% end

nSamples = nSamples - max(peakDiff) + 1;

for iTrace = 1:nTraces
    iStart = peakDiff(iTrace);
    iStop = iStart + nSamples - 1;
    alignedData(:, iTrace) = data(iStart:iStop, iTrace);
end

% peakInd = 


end