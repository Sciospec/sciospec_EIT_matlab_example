function measure_mode =fnc_get_measure_mode(fname)
% This codes to check measurement mode from the setup file. Reading all the
% paramters from the setup file has not done yet.

fid = fopen(fname, 'r');  % Open file for reading
readLines = 0;

if fid == -1
    error('File could not be opened.');
end

while ~feof(fid)
    tline = fgetl(fid);     % Read one line
    readLines = readLines + 1;  % Increment line counter

    if ~isempty(strfind(tline, ':'))
        if is_octave()
            tmp = strsplit(tline,':');
        else
            tmp = split(tline,':');
        end
        str = strtrim(tmp{2});
        try 
            val = str2num(str);
        catch ex 
            disp(ex)
        end
        if isempty(val) 
            val = str;
        end
        eval(['SciospecData. ' matlab.lang.makeValidName(strtrim(tmp{1})) ' = val;'])
    end
    
end

measure_mode = SciospecData.MeasureMode;
