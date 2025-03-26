%% Solve Forward problem to calculate simulation data
% [imdl2D.fwd_model.stimulation,imdl2D.fwd_model.meas_select] = mk_stim_patterns(numOfChannels,1,[1+NSkip,0],[0, 1+NSkip],{'no_meas_current'},amplitude*1000);
cond_mdl = .1; % in S/m units
img = mk_image( imdl2D.fwd_model, cond_mdl); 
vs = fwd_solve( img);

figure(100);clf;
plot(abs(vs.meas), '.-')
set(gca,'yscale')
title('Simulated EIT data, Magnitude of voltage')
ylabel('abs(voltage) [V]')
grid on