function RenderUATC()
    % Create default TimbreModel;
    refPhonMin = 10;
    refPhonMax = 90;
    T = TimbreModel(refPhonMin,refPhonMax);
    m = FilterSet(T,...
        'transitionflat','on',...
        'smoothing','off',...
        'phonMax',150,...
        'phonLevels',150);
    
    %Print filter coefficients
    clearIncludeList();
    for n = 2.^(2:6)
        printModelToCoeffFile(n, m, 'iirywsos', 44100);
        printModelToCoeffFile(n, m, 'iiryw', 44100);
    end
    for n = 2.^(5:10)
        printModelToCoeffFile(n, m, 'fir', 44100);
        printModelToCoeffFile(n, m, 'fdfir', 44100);
    end
end