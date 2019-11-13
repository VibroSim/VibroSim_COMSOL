%> Extract stress and strain fields from physics tag
%> Parameters:
%> -----------
%> phsyicstag - (str) tag name of physics interface to extract fields
%>
%> Returns:
%> --------
%> strainfieldexpr - (cell array) expressions for strain field
%> stressfieldexpr - (cell array) expressions for stress field
%> freqexpr - (str) expressions for excitation frequency
function [strainfieldexpr,stressfieldexpr,freqexpr] = GenerateFieldExpressions(physicstag)

    % strain field
    eX=strcat(physicstag,'.eel11');
    eXY=strcat(physicstag,'.eel12');
    eXZ=strcat(physicstag,'.eel13');
    eY=strcat(physicstag,'.eel22');
    eYZ=strcat(physicstag,'.eel23');
    eZ=strcat(physicstag,'.eel33');
    strainfieldexpr={eX,eXY,eXZ,eY,eYZ,eZ};

    % stress field
    SX=strcat(physicstag,'.Sl11');
    SXY=strcat(physicstag,'.Sl12');
    SXZ=strcat(physicstag,'.Sl13');
    SY=strcat(physicstag,'.Sl22');
    SYZ=strcat(physicstag,'.Sl23');
    SZ=strcat(physicstag,'.Sl33');
    stressfieldexpr={SX,SXY,SXZ,SY,SYZ,SZ};


    % Frequency
    freqexpr=strcat(physicstag,'.freq');

end
