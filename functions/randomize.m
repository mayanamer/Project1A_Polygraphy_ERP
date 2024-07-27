% Define the range of numbers excluding 6 and 7
validNumbers = setdiff(1:15, [6, 7]);

% Choose 3 random numbers from the valid numbers
randomNumbers = validNumbers(randperm(length(validNumbers), 3));

% Display the random numbers
disp('Three random numbers from 1 to 15 excluding 6 and 7:');
disp(randomNumbers);