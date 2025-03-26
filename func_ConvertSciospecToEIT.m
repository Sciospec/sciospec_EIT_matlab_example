% convert Sciospec data to EIT data

function Veit=func_ConvertSciospecToEIT(V,NChannel,NSkip,fulldata)

% V(i,j) : voltage between i-th electrode and the ground electrode subject to the j-th injection current
% V(:,j) : j-th column of the matrix V is the measured voltages with respect to j-th injection current

eyeN = eye(NChannel);
Mat_Conv = eyeN - circshift(eyeN,-(NSkip+1));

Veit_temp=Mat_Conv*(V);
Veit=Veit_temp(:);

if ~fulldata
    rmv_indx=func_rmv_skip(NChannel,NSkip);
    Veit(rmv_indx)=[];
end