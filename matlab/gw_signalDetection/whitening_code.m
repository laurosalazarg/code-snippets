fs1=8192;
t=0:1/fs1:(length(trend1)-1)/fs1;
[pxx,f]=psd(trend1,2*fs1,fs1,[]);
pxx_med_est=rngmed2(pxx,fs1/16); %% Median estimated.
freq=0:1/fs1:1;
bfilt=fir2(1000,freq',1./sqrt(pxx_med_est) );
dat_white_DARM=fftfilt(bfilt,trend1);
