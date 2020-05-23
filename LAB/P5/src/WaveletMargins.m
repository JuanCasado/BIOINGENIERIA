
function WaveletMargins(frequency, level)
    if nargin < 2
        level=10;
    end
    for i=0:level
        maxA=frequency/power(2, i+1);
        maxD=frequency/power(2, i);
        disp(strcat('A',num2str(i),': [0,'                ,num2str(maxA),'];',...
                   ' D',num2str(i),': [',num2str(maxA),',',num2str(maxD),']'))
    end
end