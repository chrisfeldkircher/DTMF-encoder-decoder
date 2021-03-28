%% Preliminary
load('phone_signals.mat');

seq = [];
sig = [];
num = [];

% for i=1:numel(phone_signal_1(:))/5000
%     k = i;
%     if i == 1
%         k = 0;
%         sig = [sig , phone_signal_1(1:i*5000)];
%     else
%         sig = [sig , phone_signal_1((5000*k)+1:i*5000)];
%         
%     end
% end

x1 = phone_signal_5(:,1:5000);
x2 = phone_signal_5(:,10001:15000);
x3 = phone_signal_5(:,20001:25000);
x4 = phone_signal_5(:,30001:35000);
x5 = phone_signal_5(:,40001:45000);

sig = [x1;x2;x3;x4;x5];

% N = length(sig(1,1:5000));
% Fs = 5*1e4;
% t = (0:N-1)/Fs;

f1 = [697 770 852 941]; % low
f2 = [1209 1336 1477];  % high

targetFreq = [f1(:);f2(:)];

%% FFT
% figure;
% 
% Fs_1 = 5*1e4;
% n = length(x1);
% f = (Fs_1/n)*(1:n);
% 
% p = abs(fft(x1));
% 
% stem(f,p)
% ax = gca;
% ax.XTick = targetFreq/1e3;


%% Goertzel algorithm

% figure;

for z = 1:(numel(phone_signal_2(:))/5000)-4

    N = 4999;%length(sig(z,1:5000));
    Fs = 5*1e4;                         % Default Sampling Frequency (Hz)
    t = (0:N-1)/Fs;                     % 100ms per signal

    squareMagnitude(length(targetFreq)) = 0;

    for i = 1:length(targetFreq)
        k = round(0.5 + N*targetFreq(i)/Fs);
        w = 2*pi*k/N;
        cosine = cos(w);
        sine = sin(w);
        coeff = 2*cosine;
        x1 = 0;
        x2 = 0;
        for j = 1:N
            x0 = sig(z,j) + coeff*x1 - x2;
            x2 = x1;
            x1 = x0;
        end
        squareMagnitude(i) = x1*x1 + x2*x2 - x1*x2*coeff;
        
        real = (x1 - x2 * cosine);
        imag = (x2 * sine);
        mag_sqr = real^2 + imag^2;
    end

    magnitude(length(targetFreq)) = 0;
    for i = 1:length(targetFreq)
        magnitude(i) = sqrt(squareMagnitude(i));
    end
    
    s_magnitude = sort(magnitude);
    
    seq = [seq; targetFreq(magnitude == s_magnitude(numel(s_magnitude))),targetFreq(magnitude == s_magnitude(numel(s_magnitude)-1))]; 
    %seq = [seq; f1(find(magnitude == s_magnitude(numel(s_magnitude))) - 4),f2(find(magnitude == s_magnitude(numel(s_magnitude)-1))-3)]; 
end

for i=1:5
    if eq(seq(i,2),1209) && eq(seq(i,1),697) || eq(seq(i,1),1209) && eq(seq(i,2),697)      %1
        num(1,i) = 1;
    elseif eq(seq(i,2),1336) && eq(seq(i,1),697) || eq(seq(i,1),1336) && eq(seq(i,2),697)  %2
        num(1,i) = 2;
    elseif eq(seq(i,2),1477) && eq(seq(i,1),697) || eq(seq(i,1),1477) && eq(seq(i,2),697)  %3
        num(1,i) = 3;
    elseif eq(seq(i,2),1209) && eq(seq(i,1),770) || eq(seq(i,1),1209) && eq(seq(i,2),770)  %4
        num(1,i) = 4;
    elseif eq(seq(i,2),1336) && eq(seq(i,1),770) || eq(seq(i,1),1336) && eq(seq(i,2),770)  %5
        num(1,i) = 5;
    elseif eq(seq(i,2),1477) && eq(seq(i,1),770) || eq(seq(i,1),1477) && eq(seq(i,2),770)  %6
        num(1,i) = 6;
    elseif eq(seq(i,2),1209) && eq(seq(i,1),852) || eq(seq(i,1),1209) && eq(seq(i,2),852)  %7
        num(1,i) = 7;
    elseif eq(seq(i,2),1336) && eq(seq(i,1),852) || eq(seq(i,1),1336) && eq(seq(i,2),852)  %8
        num(1,i) = 8;
    elseif eq(seq(i,2),1477) && eq(seq(i,1),852) || eq(seq(i,1),1477) && eq(seq(i,2),852)  %9
        num(1,i) = 9;
    else                                                                                %0
        num(1,i) = 0;
    end
end

num

stem(targetFreq/1e3,magnitude)
ax = gca;
ax.XTick = targetFreq/1e3;
xlabel('f (KHz)')
ylabel('Magnitude')
title('The power of the detected frequencies in our signal')
