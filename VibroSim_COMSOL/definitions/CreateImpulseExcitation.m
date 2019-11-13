%> @brief CreateImpulseExcitation defines the Gaussian pulse for time domain simulations of impulse excitation
%>
%> This function defines a temporal Gaussian pulse with a specified center time and  a specified width. The pulse has units of 1/s and integrates to 1.0

function [impulseexcitation] = CreateImpulseExcitation(M,impulseexcitationtag,impulseexcitation_t0,impulseexcitation_width)

  if isa(impulseexcitation_t0,'double')
    impulseexcitation_t0=sprintf('%s[s]',num2str(impulseexcitation_t0,18));
  end

  if isa(impulseexcitation_width,'double')
    impulseexcitation_width=sprintf('%s[s]',num2str(impulseexcitation_width,18));
  end


  impulseexcitation = CreateFunction(M,impulseexcitationtag,'GaussianPulse');
  impulseexcitation.node.label(impulseexcitationtag);

  % parameter: time
  impulseexcitation.node.set('funcname', 'impulse_excitation');
  impulseexcitation.node.set('location', impulseexcitation_t0);
  impulseexcitation.node.set('sigma', impulseexcitation_width);


  % function units
  %impulseexcitation.node.set('fununit', '1/s');

  % parameter units
  %impulseexcitation.node.set('argunit', 's');

end
