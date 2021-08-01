function sequences = creating_aud_stimuli(freqs, first_diff,second_diff)
%CREATING_AUD_STIMULI Creating auditory stimuli
%This function takes in a vector of desired frequencies and
%returns a matrix where the frequencies are trippled.
%
%freqs = Vector of freqs; e.g. 100:50:450
%first_diff = Scalar: desired difference between the first and the second freqs (Hz)
%second_diff = Scalar: desired difference between the first and the third freqs (Hz)

%% Distributing seqeunces
sequences = [];

for i = 1:length(freqs)
a = freqs(i);
b = freqs(i) + first_diff;
c = freqs(i) + second_diff;
  if b && c > freqs(end)
  break
  else
  vector = [a b c];
sequences(i,:) = [vector];
  end
end


end