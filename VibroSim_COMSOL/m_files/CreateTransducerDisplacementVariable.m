%>  NOTE: tag hardwired to 'xducerdisplacement'
function [xducerdispvar] = CreateTransducerDisplacementVariable(M,xducercalib)
% CREATETRANSDUCERDISPLACEMENTFUNCTION Creates the Transducer Displacement Function
%   [xducerdispvar] = CREATETRANSDUCERDISPLACEMENTFUNCTION(M)


  tag='xducerdisplacement';

  % Formula for displacement variable from ExcitationModeling.xoj/pdf

  % Create Variable Reference
  variabletag = CreateVariable(M, tag, 'amplitude*(xducercalib_real(freq)+i*xducercalib_imag(freq))/2.0');
  variable=FindWrappedObject(M,variabletag);

  % Make sure we have amplitude
  ObtainDCParameter(M,'amplitude','V');


  % filename is xducercalib

  addprop(variable,'xducercalib');
  variable.xducercalib=CreateFunction(M,'xducercalib','Interpolation');
  variable.xducercalib.node.set('source','file');
  variable.xducercalib.node.setIndex('funcs','xducercalib_real',0,0);
  variable.xducercalib.node.setIndex('funcs','1',0,1);
  variable.xducercalib.node.setIndex('funcs','xducercalib_imag',1,0);
  variable.xducercalib.node.setIndex('funcs','2',1,1);
  variable.xducercalib.node.set('filename',xducercalib);
  variable.xducercalib.node.set('nargs','1');
  variable.xducercalib.node.set('argunit','Hz');
  variable.xducercalib.node.set('fununit','m/V');


end
