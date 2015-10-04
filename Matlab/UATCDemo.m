function [ ] = UATCDemo(  )
% TIMBREMODEL DEMO

% TimbreModel contains all functionality needed to render ISO226 contours
% and create a linear scalar ( k(f) ).
refPhonMin = 10;
refPhonMax = 90;
m = TimbreModel(refPhonMin,refPhonMax);

figure('name','UATC Demo');

% k(f) (the amount of attenuation in dB required for 1 phon of attenuation)
subplot(2,2,1);
semilogx(m.freqs,m.linearContourScalar);
title('K(f), the constant of proportionality between phon and SPL');
xlabel('Frequency');
xlim([20,20000]);

% Get a filter specification for an arbitrary phon level
arbPhon = 20.53; % arbitrary phon level
arbSpec = m.createFilterSpec(arbPhon);
subplot(2,2,2);
semilogx(m.freqs,arbSpec);
title('A filter spec for an arbitrary phon level');
xlabel('Frequency');
xlim([20,20000]);

% Create a filter set. Both of the supplied arguments can be removed or
% disabled if desired.
fil = FilterSet(m,'transitionflat','on','smoothing','off');

% A basic set of filter response specifications. TimbreModel also
% implements a smoothing from around 50% maximum attenuation to approach a
% flat response, permitted a smooth fade to silence.
subplot(2,2,3);
semilogx(fil.freqs,fil.gains');
title('A set of filter specs a range of phon levels');
xlabel('Frequency');
xlim([20,20000]);
ylim([-100,0]);

% When viewed with a linear frequency axis, the filter designs pose a much
% greater challenge than was previously on a log plot, due to the sharp
% low-frequency slope.
subplot(2,2,4);
plot(fil.freqs,fil.gains(1:3:end,:)');
title(['A reduced set of filters on a reduced linear frequency scale. '...
    'Note the sharp low-frequency curve, posing a significant'...
    ' filter design challenge.']);
xlabel('Frequency');
xlim([20,12500]);
ylim([-100,0]);

end