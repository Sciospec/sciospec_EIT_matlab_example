function SciospecData=fnc_read_SciospecData(fname)

readLines = 0;

formatIn = 'yyyy.mm.dd. HH:MM:SS.FFF';

% Date and time are saved as 'datenum'. To get exppress 'datenum' as
% seconds, multiply it by '24*3600'

iter_Ia=0;
iter_Ib=0;

fid = fopen(fname, 'r');

tline = fgetl(fid); readLines=readLines+1;
numHeaders=str2double(tline);

if numHeaders == 9    
    SciospecData.Version = 1;
elseif numHeaders >= 11
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.Version = str2double(tline);
else
    disp('Not supported data format')
    return
end

tline = fgetl(fid);readLines=readLines+1;
SciospecData.Name=tline; 

tline = fgetl(fid);readLines=readLines+1;
SciospecData.Date=tline;
try
    SciospecData.Datenum = datenum(tline,formatIn);
catch ME
    SciospecData.Datenum = datenum(tline,'yyyy.mm.dd. HH:MM:SS');
end

tline = fgetl(fid);readLines=readLines+1;
Freq_min=str2double(tline); SciospecData.Min_Freq=[tline ' Hz'];

tline = fgetl(fid);readLines=readLines+1;
Freq_max=str2double(tline); SciospecData.Max_Freq=[tline ' Hz'];

tline = fgetl(fid);readLines=readLines+1;        
Freq_isLog=str2double(tline);

tline = fgetl(fid);readLines=readLines+1;
NofFreq=str2double(tline); NoS=1+NofFreq;

tline = fgetl(fid);readLines=readLines+1;
SciospecData.Amplitude=[tline ' A'];

tline = fgetl(fid);readLines=readLines+1;
SciospecData.FrameRate=[tline ' Frames/s'];

if(numHeaders>=11)
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.PhaseCorrection=str2double(tline);    
end

if numHeaders > readLines
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.Gain=str2double(tline);
end

if numHeaders > readLines
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.ADCRange=str2double(tline);
end

if numHeaders > readLines
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.MeasureMode=str2double(tline);
end

if numHeaders > readLines
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.Boundary=str2double(tline);
end

if numHeaders > readLines
    tline = fgetl(fid);readLines=readLines+1;
    SciospecData.SwitchType=str2double(tline);
end

for ii=1:2
    if numHeaders > readLines
        tline = fgetl(fid);readLines=readLines+1;
        if startsWith(tline,'MeasurementChannels:')
            tmp = strrep(strrep(tline,'MeasurementChannels: ',''),',',' ');
            SciospecData.MeasurementChannels=str2num(tmp);
        elseif startsWith(tline,'MeasurementChannelsIndependentFromInjectionPattern:')
            tmp = strrep(strrep(tline,'MeasurementChannelsIndependentFromInjectionPattern: ',''),',',' ');
            SciospecData.MeasurementChannelsIndependentFromInjectionPattern=str2num(tmp);
        else
            print("Not supported header")
        end
    end
end

% skip unhandled headers
while numHeaders > readLines
    fgetl(fid); readLines=readLines+1;
end


% Read voltages
NofV = 0;
tline = fgetl(fid); readLines=readLines+1;
while ischar(tline)
   
    NofV=NofV+1;
    
    if mod(NofV,NoS)==1
        iter_Ia=iter_Ia+1;
        temp_in=str2num(tline);
        Injection_setting(iter_Ia,1:2)=temp_in;
    else
        iter_Ib=iter_Ib+1;
        temp_V=str2num(tline);
        VoltageData(iter_Ib,:)=temp_V(1:2:end)+1i*temp_V(2:2:end);
    end
    tline = fgetl(fid); readLines=readLines+1;
end
% disp(readLines)
fclose(fid);


if ~Freq_isLog
    SciospecData.Frequencies=linspace(Freq_min,Freq_max,NofFreq);
else
    % disp('Add the codes for log!!')
%     a=NofFreq^(1/(Freq_max-Freq_min)); b=Freq_min;
%     SciospecData.Frequencies=log(1:NofFreq)/log(a)+b;
%     a=NofFreq^(1/(Freq_max-Freq_min)); b=Freq_min;
    SciospecData.Frequencies=(Freq_max/Freq_min).^(linspace(0,1,NofFreq))*Freq_min;
end

Nof_ij=size(Injection_setting,1);
for kk=1:NofFreq
    idxV=kk:NofFreq:NofFreq*Nof_ij;
    SciospecData.Voltages(kk).voltage=VoltageData(idxV,:);
    SciospecData.Voltages(kk).frequency=SciospecData.Frequencies(kk);
end

SciospecData.Injection_setting=Injection_setting;


% SciospecData.Voltages(kk).voltage(i,j) : voltage measured between j-th electrode and the ground electrdoe subject to the i-th current injection.
% SciospecData.Voltages(kk).voltage(i,:) : i-th row of the matrix is the measured voltages with respect to i-th injection current


