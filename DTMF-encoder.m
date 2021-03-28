%% Preliminary
symbol = {'1','2','3','4','5','6','7','8','9','0'};
f1 = [697 770 852 941]; % low
f2 = [1209 1336 1477];  % high
seq = [1 2 3 4 5];

y = [];

Fs = 5*1e4;                         % Default Sampling Frequency (Hz)
n = 5*1e3;                          % Samples of Points in Fs
t = (0:n-1)/Fs;                     % 100ms per signal
f = [];

%% Building Lookup Matrix 
for i=1:4
    for j=1:3
        f = [f [f2(j);f1(i)]]; %#ok<AGROW> %build up look-up table
    end
end

f(:,10) = []; %clean up special characters
f(:,11) = [];

seq_sig = zeros(n,size(seq,2));
pit = 2*pi*t;

%% Generating Signal
for i=1:size(f,2)
    seq_sig(:,i) = sum(sin(f(:,i)*pit))';
end

num_1   =  seq_sig(:,1)';
num_2   =  seq_sig(:,2)';
num_3 =  seq_sig(:,3)';
num_4  =  seq_sig(:,4)';
num_5  =  seq_sig(:,5)';
num_6   =  seq_sig(:,6)';
num_7 =  seq_sig(:,7)';
num_8 =  seq_sig(:,8)';
num_9  =  seq_sig(:,9)';
num_0  =  seq_sig(:,10)';
p =  zeros(1,n);

for i=1:size(seq,2) 
        switch seq(i) %build signal depending on sequence
            case 0
                y = [y, num_0 p];
                disp('Case 0')
            case 1
                y = [y, num_1 p];
                disp('Case 1')
            case 2
                y = [y, num_2 p];
                disp('Case 2')
            case 3
                y = [y, num_3 p];
                disp('Case 3')
            case 4
                y = [y, num_4 p];
                disp('Case 4')
            case 5
                y = [y, num_5 p];
                disp('Case 5')
            case 6
                y = [y, num_6 p];
                disp('Case 6')
            case 7
                y = [y, num_7 p];
                disp('Case 7')
            case 8
                y = [y, num_8 p];
                disp('Case 8')
            case 9
                y = [y, num_9 p];
                disp('Case 9')
            otherwise
                disp('Error: No Integer')
        end
end

y = y(1,1:45000); %Delete last Pause_signal

for i=1:length(y)
    y(1,i) = (y(1,i))/2;
end

plot(y)
%sound(y, Fs)