constScript

figure;
sig_ind = electrodes.enum.Fp2.index;
plot(final_data(sig_ind, :))
for ii = 0 : 30
  xline(24000*(ii)/30, ':r')  
end