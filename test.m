ss=load('demo1.dat');%Load comb-shape cliped record (i.e., back-to-zero type), which is from the Supplementary data of Yang and Ben-Zion (2010), http://www.seismosoc.org/Publications/srl/SRL_81/srl_81-1_yang_and_ben-zion-esupp/index.html

% ss=load('seis.txt');%Load flat-top cliped record

th=0.9;%The threshold for peak amplitude. Roughly, the clipping  is much easier to happen above it than below it. Usually 0.9-0.98
sigma=0.0001;% A small amplitude of random serial to purturb the peak amplitude. Usually 0.0001-0.001
tic
p=ClipAutoDetectLoop(ss,th,sigma);%Call the function of automatic detection of clippe samples, p contains the marked Clipped Samples, 0: unclipped; otherwise: clipped.
t0=toc

plot(ss,'.-b');hold on   %Plot the input signal.
plot(p(:),'r.-');hold on %Plot the marked samples.
set(gcf,'unit','centimeters','position',[3 5 22 5])
% xlim([13200 14000]);%Limit the axis range.
% xlim([1100 1550]);%Limit the axis range.