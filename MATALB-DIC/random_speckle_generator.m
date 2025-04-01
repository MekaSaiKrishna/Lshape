clc; clear; close all;

% Define image size
img_size = [512, 512]; % Image resolution
num_dots = 2500; % Number of dots


% img_size = [1024, 512]; % Image resolution
% num_dots = 5000; % Number of dots
radius_range = [3, 4]; % Min and max radius of the dots

% Create a blank binary image
speckle_pattern = ones(img_size);

% Store placed dot positions to check for overlap
dot_positions = [];

for i = 1:num_dots
    max_attempts = 100; % Limit attempts to find a non-overlapping position
    attempt = 0;
    placed = false;

    while ~placed && attempt < max_attempts
        % Random center location
        x = randi([1 img_size(2)]);
        y = randi([1 img_size(1)]);
        
        % Random radius within the defined range
        r = randi(radius_range);
        
        % Check for overlap with existing dots
        overlap = false;
        for j = 1:size(dot_positions, 1)
            existing_x = dot_positions(j, 1);
            existing_y = dot_positions(j, 2);
            existing_r = dot_positions(j, 3);
            
            % Compute distance between centers
            distance = sqrt((x - existing_x)^2 + (y - existing_y)^2);
            
            % Check if circles overlap (sum of radii)
            if distance < (r + existing_r)
                overlap = true;
                break;
            end
        end

        % If no overlap, place the circle
        if ~overlap
            dot_positions = [dot_positions; x, y, r]; % Store dot position
            
            % Create a circular mask
            [xx, yy] = meshgrid(1:img_size(2), 1:img_size(1));
            mask = ((xx - x).^2 + (yy - y).^2) <= r^2;
            
            % Apply mask to the speckle pattern
            speckle_pattern(mask) = 0;
            
            placed = true;
        end
        
        attempt = attempt + 1;
    end
end

% Display the pattern
imshow(speckle_pattern, []);

% Save the pattern if needed
imwrite(speckle_pattern, 'non_overlapping_speckle.png');
